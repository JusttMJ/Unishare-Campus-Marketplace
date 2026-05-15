using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class ItemDetails : System.Web.UI.Page
    {
        private string currentItemID = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Protect page from logged-out users
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Grab the item ID from the URL (e.g. ItemDetails.aspx?id=14)
            if (Request.QueryString["id"] != null)
            {
                currentItemID = Request.QueryString["id"].ToString();
            }
            else
            {
                Response.Redirect("Catalogue.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadItemData();
            }
        }

        private void LoadItemData()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // Master Query pulling from existing Item, UserDetails, and Review tables
                    string query = @"
                        SELECT i.itemID, i.itemName, i.itemDescription, i.price, i.condition, i.category, i.imagePath, i.sellerID,
                               u.userName AS SellerName,
                               ISNULL((SELECT AVG(CAST(Rating AS DECIMAL(3,1))) FROM Review WHERE ItemID = i.itemID), 0) AS AvgRating,
                               (SELECT COUNT(*) FROM Review WHERE ItemID = i.itemID) AS ReviewCount
                        FROM Item i
                        INNER JOIN UserDetails u ON i.sellerID = u.userID
                        WHERE i.itemID = @ItemID AND i.avalibiltyStatus = 'Available'";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ItemID", currentItemID);
                        conn.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Populate the UI
                                lblItemName.Text = reader["itemName"].ToString();
                                lblPrice.Text = Convert.ToDecimal(reader["price"]).ToString("0.00");
                                lblDescription.Text = reader["itemDescription"].ToString();
                                lblCategory.Text = reader["category"].ToString();
                                lblConditionBadge.Text = reader["condition"].ToString();
                                imgProduct.ImageUrl = reader["imagePath"].ToString();

                                lblSellerName.Text = reader["SellerName"].ToString();
                                lblRating.Text = Convert.ToDecimal(reader["AvgRating"]).ToString("0.0");
                                lblReviewCount.Text = $"({reader["ReviewCount"]} reviews)";

                                // Check if user is the seller
                                string sellerID = reader["sellerID"].ToString();
                                if (sellerID == Session["UserID"].ToString())
                                {
                                    btnAddToCart.Visible = false;
                                    lblOwnItem.Visible = true;
                                }

                                LoadVariations();
                            }
                            else
                            {
                                // Hide the product layout if someone typed a fake ID in the URL
                                ProductContainer.Visible = false;
                                lblMessage.Text = "Item not found or is no longer available.";
                                lblMessage.CssClass = "alert alert-danger d-block fw-bold border-0 shadow-sm px-4 py-3";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ProductContainer.Visible = false;
                lblMessage.Text = "Error loading details: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger d-block fw-bold border-0 shadow-sm px-4 py-3";
            }
        }

        private void LoadVariations()
        {
            ddlColors.Items.Clear();
            int stockCount = 0;

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "SELECT Color, Quantity FROM ItemVariation WHERE ItemID = @ItemID AND Quantity > 0";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ItemID", currentItemID);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string hexColor = reader["Color"].ToString();
                                string qty = reader["Quantity"].ToString();

                                ListItem colorItem = new ListItem($"Color Variant ({qty} in stock)", hexColor);
                                colorItem.Attributes.Add("style", $"background-color: {hexColor}; color: #ffffff; text-shadow: 1px 1px 3px #000000;");

                                ddlColors.Items.Add(colorItem);
                                stockCount++;
                            }
                        }
                    }
                }

                if (stockCount > 0)
                {
                    string firstColor = ddlColors.Items[0].Value;
                    ddlColors.Attributes.Add("style", $"background-color: {firstColor}; color: #ffffff; text-shadow: 1px 1px 3px #000000;");
                }
                else
                {
                    ddlColors.Items.Add(new ListItem("Out of Stock", ""));
                    ddlColors.Enabled = false;

                    btnAddToCart.Text = "Out of Stock";
                    btnAddToCart.Enabled = false;
                    btnAddToCart.CssClass = "btn btn-secondary w-100 fw-bold rounded-pill py-3 fs-5 disabled";
                }
            }
            catch
            {
                // Fallback gracefully if variation loading fails
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            string selectedColor = ddlColors.SelectedValue;
            string currentUserID = Session["UserID"].ToString();

            if (string.IsNullOrEmpty(selectedColor))
            {
                lblMessage.Text = "Please select a valid variant.";
                lblMessage.CssClass = "alert alert-warning d-block fw-bold border-0 shadow-sm px-4 py-3";
                return;
            }

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // 1. Prevent duplicate items
                    string checkQuery = "SELECT COUNT(*) FROM Cart WHERE userID = @UserID AND itemID = @ItemID AND selectedColor = @Color";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", currentUserID);
                        checkCmd.Parameters.AddWithValue("@ItemID", currentItemID);
                        checkCmd.Parameters.AddWithValue("@Color", selectedColor);
                        conn.Open();

                        if ((int)checkCmd.ExecuteScalar() > 0)
                        {
                            lblMessage.Text = "<i class='bi bi-info-circle me-2'></i>This exact item and variant is already in your cart!";
                            lblMessage.CssClass = "alert alert-info d-block fw-bold border-0 shadow-sm px-4 py-3";
                            return;
                        }
                    }

                    // 2. Insert into Cart
                    string insertQuery = "INSERT INTO Cart (userID, itemID, selectedColor) VALUES (@UserID, @ItemID, @Color)";
                    using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@UserID", currentUserID);
                        insertCmd.Parameters.AddWithValue("@ItemID", currentItemID);
                        insertCmd.Parameters.AddWithValue("@Color", selectedColor);
                        insertCmd.ExecuteNonQuery();
                    }

                    lblMessage.Text = "<i class='bi bi-check-circle-fill me-2'></i>Successfully added to your cart!";
                    lblMessage.CssClass = "alert alert-success d-block fw-bold border-0 shadow-sm px-4 py-3";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error adding to cart: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger d-block fw-bold border-0 shadow-sm px-4 py-3";
            }
        }
    }
}