using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class Catalogue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
                ViewState["CurrentCategory"] = "";
                LoadCatalogueItems("", "");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCatalogueItems(txtSearch.Text.Trim(), ViewState["CurrentCategory"].ToString());
        }

        protected void FilterCategory_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            ViewState["CurrentCategory"] = btn.CommandArgument;
            txtSearch.Text = "";
            LoadCatalogueItems("", btn.CommandArgument);
        }

        private void LoadCatalogueItems(string searchTerm, string category)
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = @"
                        SELECT i.itemID, i.itemName, i.itemDescription, i.price, i.condition, i.category, i.imagePath, i.sellerID, u.userName AS SellerName,
                               ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,1))) FROM Review WHERE ItemID = i.itemID), 0) AS AvgRating,
                               (SELECT COUNT(*) FROM Review WHERE ItemID = i.itemID) AS ReviewCount
                        FROM Item i
                        INNER JOIN UserDetails u ON i.sellerID = u.userID
                        WHERE i.avalibiltyStatus = 'Available'";

                    if (!string.IsNullOrEmpty(searchTerm)) query += " AND (i.itemName LIKE @Search OR i.itemDescription LIKE @Search)";
                    if (!string.IsNullOrEmpty(category)) query += " AND i.category = @Category";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (!string.IsNullOrEmpty(searchTerm)) cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                        if (!string.IsNullOrEmpty(category)) cmd.Parameters.AddWithValue("@Category", category);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptCatalogue.DataSource = dt;
                            rptCatalogue.DataBind();

                            if (rptCatalogue.Controls.Count > 0)
                            {
                                Control footer = rptCatalogue.Controls[rptCatalogue.Controls.Count - 1];
                                Label lblNoItems = (Label)footer.FindControl("lblNoItems");
                                if (lblNoItems != null) lblNoItems.Visible = (dt.Rows.Count == 0);
                            }
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error: " + ex.Message; }
        }

        protected void rptCatalogue_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DropDownList ddlColors = (DropDownList)e.Item.FindControl("ddlColors");
                string itemID = DataBinder.Eval(e.Item.DataItem, "itemID").ToString();
                int stockCount = 0;

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        string query = "SELECT Color, Quantity FROM ItemVariation WHERE ItemID = @ItemID AND Quantity > 0";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@ItemID", itemID);
                            conn.Open();
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    string hexColor = reader["Color"].ToString();
                                    string qty = reader["Quantity"].ToString();

                                    ListItem colorItem = new ListItem($" ({qty} in stock)", hexColor);
                                    // Apply the hex background to the individual list item
                                    colorItem.Attributes.Add("style", $"background-color: {hexColor}; color: #ffffff; text-shadow: 1px 1px 3px #000000;");

                                    ddlColors.Items.Add(colorItem);
                                    stockCount++;
                                }
                            }
                        }
                    }

                    if (stockCount > 0)
                    {
                        // Initial color setup
                        string firstColor = ddlColors.Items[0].Value;
                        ddlColors.Attributes.Add("style", $"background-color: {firstColor}; color: #ffffff; text-shadow: 1px 1px 2px #000000;");

                        // RESTORED: JavaScript to change the dropdown color dynamically on the client-side
                        ddlColors.Attributes.Add("onchange", "this.style.backgroundColor = this.options[this.selectedIndex].style.backgroundColor;");
                    }
                    else
                    {
                        ddlColors.Items.Add(new ListItem("Out of Stock", ""));
                        ddlColors.Enabled = false;
                    }
                }
                catch { }
            }
        }

        protected void rptCatalogue_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                if (Session["UserID"] == null) { Response.Redirect("Login.aspx"); return; }

                string itemID = e.CommandArgument.ToString();
                string userID = Session["UserID"].ToString();
                string color = ((DropDownList)e.Item.FindControl("ddlColors")).SelectedValue;

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        string sql = "INSERT INTO Cart (userID, itemID, selectedColor) VALUES (@UID, @IID, @Col)";
                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@UID", userID);
                            cmd.Parameters.AddWithValue("@IID", itemID);
                            cmd.Parameters.AddWithValue("@Col", color);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                        lblMessage.Text = "Item successfully added to your cart!";
                        lblMessage.CssClass = "alert alert-success d-block fw-bold border-0 shadow-sm";
                    }
                }
                catch (Exception ex) { lblMessage.Text = "Error: " + ex.Message; }
            }
        }
    }
}