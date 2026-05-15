using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class MyPurchases : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                LoadPurchases();
            }
        }

        private void LoadPurchases()
        {
            string userID = Session["UserID"].ToString();

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = @"
                        SELECT o.orderID, o.orderDate, o.orderStatus, o.paymentStatus, o.totalAmount,
                               i.itemID, i.itemName, oi.priceAtPurchase, oi.selectedColor, u.userName AS SellerName
                        FROM OrderItem oi
                        INNER JOIN OrderRecord o ON oi.orderID = o.orderID
                        INNER JOIN Item i ON oi.itemID = i.itemID
                        INNER JOIN UserDetails u ON oi.sellerID = u.userID
                        WHERE o.buyerID = @BuyerID
                        ORDER BY o.orderDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BuyerID", userID);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            rptPurchases.DataSource = dt;
                            rptPurchases.DataBind();

                            Control footer = rptPurchases.Controls[rptPurchases.Controls.Count - 1];
                            if (footer != null)
                            {
                                Label lblNoPurchases = (Label)footer.FindControl("lblNoPurchases");
                                if (lblNoPurchases != null)
                                {
                                    lblNoPurchases.Visible = (dt.Rows.Count == 0);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading purchases: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        protected void rptPurchases_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string currentUserID = Session["UserID"].ToString();

            // HANDLING THE CANCELLATION
            if (e.CommandName == "CancelOrder")
            {
                string orderID = e.CommandArgument.ToString();

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        conn.Open();

                        using (SqlTransaction transaction = conn.BeginTransaction())
                        {
                            try
                            {
                                string updateOrder = "UPDATE OrderRecord SET orderStatus = 'Cancelled', paymentStatus = 'Refunded' WHERE orderID = @OrderID AND buyerID = @BuyerID";
                                using (SqlCommand cmdOrder = new SqlCommand(updateOrder, conn, transaction))
                                {
                                    cmdOrder.Parameters.AddWithValue("@OrderID", orderID);
                                    cmdOrder.Parameters.AddWithValue("@BuyerID", currentUserID);
                                    cmdOrder.ExecuteNonQuery();
                                }

                                string getItems = "SELECT itemID, selectedColor FROM OrderItem WHERE orderID = @OrderID";
                                DataTable dtItems = new DataTable();
                                using (SqlCommand cmdGet = new SqlCommand(getItems, conn, transaction))
                                {
                                    cmdGet.Parameters.AddWithValue("@OrderID", orderID);
                                    using (SqlDataReader reader = cmdGet.ExecuteReader())
                                    {
                                        dtItems.Load(reader);
                                    }
                                }

                                foreach (DataRow row in dtItems.Rows)
                                {
                                    string reverseInventory = "UPDATE ItemVariation SET Quantity = Quantity + 1 WHERE ItemID = @ItemID AND Color = @Color";
                                    using (SqlCommand cmdInv = new SqlCommand(reverseInventory, conn, transaction))
                                    {
                                        cmdInv.Parameters.AddWithValue("@ItemID", row["itemID"]);
                                        cmdInv.Parameters.AddWithValue("@Color", row["selectedColor"]);
                                        cmdInv.ExecuteNonQuery();
                                    }
                                }

                                string logQuery = "INSERT INTO Audit_Log (recordID, Auditdescription, actionDate, userID) VALUES (@OrderID, @Desc, GETDATE(), @UserID)";
                                using (SqlCommand cmdLog = new SqlCommand(logQuery, conn, transaction))
                                {
                                    cmdLog.Parameters.AddWithValue("@OrderID", orderID);
                                    cmdLog.Parameters.AddWithValue("@Desc", $"User {Session["UserName"]} cancelled Order #{orderID}.");
                                    cmdLog.Parameters.AddWithValue("@UserID", currentUserID);
                                    cmdLog.ExecuteNonQuery();
                                }

                                transaction.Commit();
                                lblMessage.Text = $"Order #{orderID} has been successfully cancelled and refunded.";
                                lblMessage.CssClass = "text-success fw-bold d-block mb-3";
                                LoadPurchases();
                            }
                            catch (Exception innerEx)
                            {
                                transaction.Rollback();
                                lblMessage.Text = "Cancellation failed: " + innerEx.Message;
                                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Connection error: " + ex.Message;
                    lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                }
            }

            // NEW: HANDLING THE REVIEW SUBMISSION
            if (e.CommandName == "SubmitReview")
            {
                string itemID = e.CommandArgument.ToString();

                // Find the dropdown and textbox in the specific row they clicked
                RepeaterItem item = (RepeaterItem)((Button)e.CommandSource).NamingContainer;
                DropDownList ddlRating = (DropDownList)item.FindControl("ddlRating");
                TextBox txtReviewComment = (TextBox)item.FindControl("txtReviewComment");

                int rating = Convert.ToInt32(ddlRating.SelectedValue);
                string comment = txtReviewComment.Text.Trim();

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        // Check if they already reviewed this specific item
                        string checkQuery = "SELECT COUNT(*) FROM Review WHERE ItemID = @ItemID AND UserID = @UserID";
                        using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                        {
                            cmdCheck.Parameters.AddWithValue("@ItemID", itemID);
                            cmdCheck.Parameters.AddWithValue("@UserID", currentUserID);
                            conn.Open();
                            int count = (int)cmdCheck.ExecuteScalar();

                            if (count > 0)
                            {
                                lblMessage.Text = "You have already left a review for this item!";
                                lblMessage.CssClass = "text-warning fw-bold d-block mb-3";
                                return;
                            }
                        }

                        // Save the Review
                        string insertQuery = "INSERT INTO Review (ItemID, UserID, Rating, Comment) VALUES (@ItemID, @UserID, @Rating, @Comment)";
                        using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                        {
                            cmdInsert.Parameters.AddWithValue("@ItemID", itemID);
                            cmdInsert.Parameters.AddWithValue("@UserID", currentUserID);
                            cmdInsert.Parameters.AddWithValue("@Rating", rating);
                            cmdInsert.Parameters.AddWithValue("@Comment", comment);
                            cmdInsert.ExecuteNonQuery();
                        }

                        lblMessage.Text = "Your review was successfully posted! Thank you.";
                        lblMessage.CssClass = "text-success fw-bold d-block mb-3";
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error submitting review: " + ex.Message;
                    lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                }
            }
        }
    }
}