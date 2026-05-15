using System;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Web.UI;

namespace Group11Unishare
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If they are already logged in, push them straight to the catalogue
            if (!IsPostBack && Session["UserID"] != null)
            {
                Response.Redirect("Catalogue.aspx");
            }
        }

        // Google reCAPTCHA Validation Method
        private bool ValidateReCaptcha()
        {
            string captchaResponse = Request.Form["g-recaptcha-response"];

            if (string.IsNullOrEmpty(captchaResponse))
            {
                return false;
            }

            bool isValid = false;

            // IMPORTANT: Paste your actual Secret Key here
            string secretKey = "6LeMXOksAAAAAIzerGkJ1wlT33MNRIas5JsrTX2y";

            string apiUrl = $"https://www.google.com/recaptcha/api/siteverify?secret={secretKey}&response={captchaResponse}";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(apiUrl);

            try
            {
                using (WebResponse wResponse = req.GetResponse())
                {
                    using (StreamReader readStream = new StreamReader(wResponse.GetResponseStream()))
                    {
                        string jsonResponse = readStream.ReadToEnd();

                        if (jsonResponse.Contains("\"success\": true"))
                        {
                            isValid = true;
                        }
                    }
                }
            }
            catch
            {
                // Fail secure: If Google goes down, assume it's a bot
                return false;
            }

            return isValid;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // 1. SECURITY CHECK: Verify reCAPTCHA first!
            if (!ValidateReCaptcha())
            {
                lblMessage.Text = "Security Check Failed: Please verify that you are not a robot.";
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3 text-center";
                return;
            }

            // 2. Gather User Input
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email and password.";
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3 text-center";
                return;
            }

            try
            {
                // 3. Authenticate against the Database
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // FIXED: Changed 'password' to 'userPassword' to match your database exactly
                    string query = "SELECT userID, userName, isAdmin FROM UserDetails WHERE email = @Email AND userPassword = @Password";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Password", password);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Login Success! Set Session Variables
                                Session["UserID"] = reader["userID"].ToString();
                                Session["UserName"] = reader["userName"].ToString();

                                bool isAdmin = Convert.ToBoolean(reader["isAdmin"]);
                                Session["IsAdmin"] = isAdmin;

                                // 4. Route the user based on their Role
                                if (isAdmin)
                                {
                                    Response.Redirect("AdminDashboard.aspx");
                                }
                                else
                                {
                                    Response.Redirect("Catalogue.aspx");
                                }
                            }
                            else
                            {
                                lblMessage.Text = "Invalid email or password. Please try again.";
                                lblMessage.CssClass = "text-danger fw-bold d-block mb-3 text-center";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "A system error occurred: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3 text-center";
            }
        }
    }
}