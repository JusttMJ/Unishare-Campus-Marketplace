using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        // Public properties to hold the data for the Javascript Chart
        public string ChartLabels { get; set; } = "";
        public string ChartData { get; set; } = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                VerifyAdminAccess();
            }
        }

        private void VerifyAdminAccess()
        {
            string userID = Session["UserID"].ToString();
            bool isAdmin = false;

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "SELECT isAdmin FROM UserDetails WHERE userID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            isAdmin = Convert.ToBoolean(result);
                        }
                    }
                }

                if (!isAdmin)
                {
                    Response.Redirect("Catalogue.aspx");
                }
                else
                {
                    LoadDashboardStats();
                    LoadChartData(); // Loads data for the graph
                    LoadLeaderboards();
                    LoadAdminItems();
                    LoadPromotions();
                    LoadAuditLogs();
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Security Verification Error: " + ex.Message;
            }
        }

        // UPDATED: Calculates the exactly 10% Platform Revenue by Category!
        private void LoadChartData()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // Takes 10% of the price of all items ever listed to track platform monetization
                    string query = @"
                        SELECT category, ISNULL(SUM(price * 0.10), 0) AS PlatformRevenue
                        FROM Item
                        GROUP BY category";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            StringBuilder labels = new StringBuilder();
                            StringBuilder data = new StringBuilder();

                            while (reader.Read())
                            {
                                // Format it as 'Category', 'Category' for javascript array
                                labels.Append($"'{reader["category"].ToString()}',");

                                // Replace comma with dot for valid JS numbering
                                data.Append($"{Convert.ToDecimal(reader["PlatformRevenue"]).ToString("0.00", System.Globalization.CultureInfo.InvariantCulture)},");
                            }

                            // Remove trailing commas
                            ChartLabels = labels.ToString().TrimEnd(',');
                            ChartData = data.ToString().TrimEnd(',');
                        }
                    }
                }
            }
            catch { /* Fail silently, chart will just be blank */ }
        }

        private void LoadDashboardStats()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    conn.Open();

                    SqlCommand cmdUsers = new SqlCommand("SELECT COUNT(*) FROM UserDetails", conn);
                    lblTotalUsers.Text = cmdUsers.ExecuteScalar().ToString();

                    SqlCommand cmdItems = new SqlCommand("SELECT COUNT(*) FROM Item WHERE avalibiltyStatus = 'Available'", conn);
                    lblTotalItems.Text = cmdItems.ExecuteScalar().ToString();

                    SqlCommand cmdSales = new SqlCommand("SELECT ISNULL(SUM(totalAmount), 0) FROM OrderRecord", conn);
                    decimal totalSales = Convert.ToDecimal(cmdSales.ExecuteScalar());
                    lblTotalSales.Text = "R " + totalSales.ToString("0.00");

                    // NEW: Calculate the exact Total Platform Revenue (10% of all listed items)
                    SqlCommand cmdPlatformRev = new SqlCommand("SELECT ISNULL(SUM(price * 0.10), 0) FROM Item", conn);
                    decimal totalPlatformRev = Convert.ToDecimal(cmdPlatformRev.ExecuteScalar());
                    lblPlatformRevenue.Text = "R " + totalPlatformRev.ToString("0.00");
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading stats: " + ex.Message;
            }
        }

        private void LoadLeaderboards()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string sellersQuery = @"
                        SELECT TOP 5 u.userName, COUNT(oi.orderItemID) AS TotalItemsSold, SUM(oi.priceAtPurchase) AS TotalRevenue
                        FROM OrderItem oi
                        INNER JOIN UserDetails u ON oi.sellerID = u.userID
                        GROUP BY u.userName
                        ORDER BY TotalItemsSold DESC, TotalRevenue DESC";

                    string productsQuery = @"
                        SELECT TOP 5 i.itemName, COUNT(oi.orderItemID) AS TimesSold
                        FROM OrderItem oi
                        INNER JOIN Item i ON oi.itemID = i.itemID
                        GROUP BY i.itemName
                        ORDER BY TimesSold DESC";

                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(sellersQuery, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dtSellers = new DataTable();
                            sda.Fill(dtSellers);
                            rptTopSellers.DataSource = dtSellers;
                            rptTopSellers.DataBind();
                        }
                    }

                    using (SqlCommand cmd = new SqlCommand(productsQuery, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dtProducts = new DataTable();
                            sda.Fill(dtProducts);
                            rptTopProducts.DataSource = dtProducts;
                            rptTopProducts.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading leaderboards: " + ex.Message;
            }
        }

        private void LoadAdminItems()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = @"
                        SELECT i.itemID, i.itemName, i.price, i.dateListed, u.userName AS SellerName 
                        FROM Item i
                        INNER JOIN UserDetails u ON i.sellerID = u.userID
                        WHERE i.avalibiltyStatus = 'Available'
                        ORDER BY i.dateListed DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptAdminItems.DataSource = dt;
                            rptAdminItems.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading items: " + ex.Message;
            }
        }

        private void LoadPromotions()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "SELECT PromoID, PromoCode, DiscountPercent, IsActive FROM Promotion ORDER BY DateCreated DESC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptPromotions.DataSource = dt;
                            rptPromotions.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading promotions: " + ex.Message;
            }
        }

        private void LoadAuditLogs()
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "SELECT AuditLogID, recordID, Auditdescription, actionDate FROM Audit_Log ORDER BY actionDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            rptAuditLog.DataSource = dt;
                            rptAuditLog.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text += " | Error loading audit logs: " + ex.Message;
            }
        }

        private void LogAdminAction(string description, string recordId)
        {
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = @"INSERT INTO Audit_Log (recordID, Auditdescription, actionDate, userID) 
                                     VALUES (@RecordID, @Description, GETDATE(), @UserID)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@RecordID", recordId);
                        cmd.Parameters.AddWithValue("@Description", description);
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch { }
        }

        protected void rptAdminItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Delete")
            {
                string itemID = e.CommandArgument.ToString();

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        conn.Open();

                        string deleteCart = "DELETE FROM Cart WHERE itemID = @ItemID";
                        using (SqlCommand cmd = new SqlCommand(deleteCart, conn))
                        {
                            cmd.Parameters.AddWithValue("@ItemID", itemID);
                            cmd.ExecuteNonQuery();
                        }

                        // Soft Delete
                        string updateItem = "UPDATE Item SET avalibiltyStatus = 'Removed' WHERE itemID = @ItemID";
                        using (SqlCommand cmd = new SqlCommand(updateItem, conn))
                        {
                            cmd.Parameters.AddWithValue("@ItemID", itemID);
                            cmd.ExecuteNonQuery();
                        }
                    }

                    string adminName = Session["UserName"].ToString();
                    LogAdminAction($"Admin '{adminName}' removed Item #{itemID} from the marketplace.", itemID);

                    lblMessage.Text = "Item successfully removed.";
                    lblMessage.CssClass = "text-success fw-bold d-block mb-3";

                    LoadDashboardStats();
                    LoadAdminItems();
                    LoadAuditLogs();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error removing item: " + ex.Message;
                    lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                }
            }
        }

        protected void btnAddPromo_Click(object sender, EventArgs e)
        {
            string code = txtPromoCode.Text.Trim().ToUpper();
            string percentText = txtPromoPercent.Text.Trim();

            if (string.IsNullOrEmpty(code) || string.IsNullOrEmpty(percentText))
            {
                lblMessage.Text = "Please provide both a code and a percentage.";
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                return;
            }

            try
            {
                int percent = Convert.ToInt32(percentText);

                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "INSERT INTO Promotion (PromoCode, DiscountPercent, IsActive) VALUES (@Code, @Percent, 1); SELECT SCOPE_IDENTITY();";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Code", code);
                        cmd.Parameters.AddWithValue("@Percent", percent);

                        conn.Open();
                        string newPromoID = cmd.ExecuteScalar().ToString();

                        string adminName = Session["UserName"].ToString();
                        LogAdminAction($"Admin '{adminName}' generated Promo Code '{code}' ({percent}% off).", newPromoID);
                    }
                }

                txtPromoCode.Text = "";
                txtPromoPercent.Text = "";
                lblMessage.Text = $"Promo code {code} successfully created!";
                lblMessage.CssClass = "text-success fw-bold d-block mb-3";

                LoadPromotions();
                LoadAuditLogs();
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627)
                {
                    lblMessage.Text = "This promo code already exists in the system.";
                }
                else
                {
                    lblMessage.Text = "Database Error: " + ex.Message;
                }
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
            }
        }

        protected void rptPromotions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ToggleStatus")
            {
                string promoID = e.CommandArgument.ToString();

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        string query = "UPDATE Promotion SET IsActive = IsActive ^ 1 WHERE PromoID = @PromoID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@PromoID", promoID);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    string adminName = Session["UserName"].ToString();
                    LogAdminAction($"Admin '{adminName}' changed the active status of Promo ID {promoID}.", promoID);

                    LoadPromotions();
                    LoadAuditLogs();
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error updating promotion: " + ex.Message;
                    lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                }
            }
        }
    }
}