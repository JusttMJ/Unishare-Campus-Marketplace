using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class MySales : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                LoadSalesHistory();
            }
        }

        private void LoadSalesHistory()
        {
            string userID = Session["UserID"].ToString();

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // ADDED: o.orderStatus to the SELECT statement
                    string query = @"
                        SELECT o.orderID, o.orderDate, o.fulfillmentMethod, o.paymentStatus, o.deliveryAddress, o.orderStatus,
                               i.itemName, oi.priceAtPurchase, u.userName AS BuyerName
                        FROM OrderItem oi
                        INNER JOIN OrderRecord o ON oi.orderID = o.orderID
                        INNER JOIN Item i ON oi.itemID = i.itemID
                        INNER JOIN UserDetails u ON o.buyerID = u.userID
                        WHERE oi.sellerID = @SellerID
                        ORDER BY o.orderDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@SellerID", userID);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            rptSales.DataSource = dt;
                            rptSales.DataBind();

                            Control footer = rptSales.Controls[rptSales.Controls.Count - 1];
                            if (footer != null)
                            {
                                Label lblNoSales = (Label)footer.FindControl("lblNoSales");
                                if (lblNoSales != null)
                                {
                                    lblNoSales.Visible = (dt.Rows.Count == 0);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading sales history: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        // NEW: Handles the "Save" button click to update the status
        protected void rptSales_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                string orderID = e.CommandArgument.ToString();

                // Find the dropdown list in the specific row they clicked
                RepeaterItem item = e.Item;
                DropDownList ddlStatus = (DropDownList)item.FindControl("ddlStatus");

                if (ddlStatus != null)
                {
                    string newStatus = ddlStatus.SelectedValue;

                    try
                    {
                        using (SqlConnection conn = DatabaseHelper.GetConnection())
                        {
                            string query = "UPDATE OrderRecord SET orderStatus = @Status WHERE orderID = @OrderID";
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@Status", newStatus);
                                cmd.Parameters.AddWithValue("@OrderID", orderID);
                                conn.Open();
                                cmd.ExecuteNonQuery();
                            }
                        }

                        lblMessage.Text = $"Order #{orderID} successfully updated to '{newStatus}'!";
                        lblMessage.CssClass = "text-success fw-bold d-block mb-3";

                        // Reload the page to show the new status
                        LoadSalesHistory();
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error updating status: " + ex.Message;
                        lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                    }
                }
            }
        }
    }
}