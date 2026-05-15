using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Group11Unishare
{
    public partial class Cart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else if (!IsPostBack)
            {
                lblMessage.Text = "";
                LoadCart();
            }
        }

        private void LoadCart()
        {
            string userID = Session["UserID"].ToString();
            decimal totalDue = 0;

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // Grab the cart details by joining Cart and Item tables
                    string query = @"
                        SELECT c.cartID, i.itemID, i.itemName, i.price 
                        FROM Cart c
                        INNER JOIN Item i ON c.itemID = i.itemID
                        WHERE c.userID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            // Calculate Total Price
                            foreach (DataRow row in dt.Rows)
                            {
                                totalDue += Convert.ToDecimal(row["price"]);
                            }

                            // Bind data to screen
                            rptCart.DataSource = dt;
                            rptCart.DataBind();

                            lblTotal.Text = "R " + totalDue.ToString("0.00");

                            // If cart is empty, hide the checkout button!
                            if (dt.Rows.Count == 0)
                            {
                                btnCheckout.Visible = false;
                                lblMessage.Text = "Your cart is empty.";
                            }
                            else
                            {
                                btnCheckout.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading cart: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            // Handles removing a single item from the cart
            if (e.CommandName == "Remove")
            {
                string cartID = e.CommandArgument.ToString();

                try
                {
                    using (SqlConnection conn = DatabaseHelper.GetConnection())
                    {
                        string query = "DELETE FROM Cart WHERE cartID = @CartID";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@CartID", cartID);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                    LoadCart(); // Refresh the page to show the updated total
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error removing item: " + ex.Message;
                    lblMessage.CssClass = "text-danger fw-bold";
                }
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Simply route them to the new checkout pipeline!
            Response.Redirect("Checkout.aspx");
        }
    }
}