using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Group11Unishare
{
    public partial class Profile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            string userID = Session["UserID"].ToString();

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "SELECT userName, email, contactNumber FROM UserDetails WHERE userID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtName.Text = reader["userName"].ToString();
                                txtEmail.Text = reader["email"].ToString();

                                // Safely handle the phone number in case it is NULL in the database
                                if (reader["contactNumber"] != DBNull.Value)
                                {
                                    txtPhone.Text = reader["contactNumber"].ToString();
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading profile: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string userID = Session["UserID"].ToString();

            if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtEmail.Text))
            {
                lblMessage.Text = "Name and Email cannot be empty.";
                lblMessage.CssClass = "text-warning fw-bold d-block mb-3";
                return;
            }

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = "UPDATE UserDetails SET userName = @Name, email = @Email, contactNumber = @Phone WHERE userID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@UserID", userID);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Update the Session variable so the Greeting on the Catalogue changes instantly!
                Session["UserName"] = txtName.Text.Trim();

                lblMessage.Text = "Profile updated successfully!";
                lblMessage.CssClass = "text-success fw-bold d-block mb-3";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error updating profile: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string userID = Session["UserID"].ToString();
            string currentPass = txtCurrentPassword.Text;
            string newPass = txtNewPassword.Text;
            string confirmPass = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(currentPass) || string.IsNullOrEmpty(newPass))
            {
                lblMessage.Text = "Please fill in all password fields.";
                lblMessage.CssClass = "text-warning fw-bold d-block mb-3";
                return;
            }

            if (newPass != confirmPass)
            {
                lblMessage.Text = "New passwords do not match!";
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                return;
            }

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    conn.Open();

                    // 1. Verify Current Password
                    string checkQuery = "SELECT COUNT(*) FROM UserDetails WHERE userID = @UserID AND userPassword = @CurrentPass";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@UserID", userID);
                        checkCmd.Parameters.AddWithValue("@CurrentPass", currentPass);

                        int matchCount = (int)checkCmd.ExecuteScalar();
                        if (matchCount == 0)
                        {
                            lblMessage.Text = "Incorrect current password.";
                            lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
                            return;
                        }
                    }

                    // 2. Update to New Password
                    string updateQuery = "UPDATE UserDetails SET userPassword = @NewPass WHERE userID = @UserID";
                    using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@NewPass", newPass);
                        updateCmd.Parameters.AddWithValue("@UserID", userID);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "Password changed successfully!";
                lblMessage.CssClass = "text-success fw-bold d-block mb-3";

                // Clear the text boxes so the passwords aren't just sitting there
                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error changing password: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold d-block mb-3";
            }
        }
    }
}