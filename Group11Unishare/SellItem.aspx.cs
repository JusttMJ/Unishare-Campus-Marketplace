using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace Group11Unishare
{
    public class VariantItem
    {
        public string color { get; set; }
        public int quantity { get; set; }
    }

    public partial class SellItem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnSubmitListing_Click(object sender, EventArgs e)
        {
            // 1. VALIDATE FAKE PAYMENT FIELDS
            if (string.IsNullOrWhiteSpace(txtCardName.Text) || string.IsNullOrWhiteSpace(txtCardNumber.Text))
            {
                lblMessage.Text = "Payment Error: Please complete your card details to pay the 10% fee.";
                lblMessage.CssClass = "alert alert-danger d-block fw-bold";
                return;
            }

            // 2. VALIDATE VARIANTS
            string variantsJson = hfVariants.Value;
            if (string.IsNullOrEmpty(variantsJson) || variantsJson == "[]")
            {
                lblMessage.Text = "You must add at least one color variant and quantity.";
                lblMessage.CssClass = "alert alert-warning d-block fw-bold";
                return;
            }

            // 3. PREPARE THE DATA
            string sellerID = Session["UserID"].ToString();
            string itemName = txtItemName.Text.Trim();
            string category = ddlCategory.SelectedValue;
            string condition = ddlCondition.SelectedValue;
            string description = txtDescription.Text.Trim();
            decimal price;

            // DECIMAL FIX: Safely handles both "600,00" and "600.00"
            string priceInput = txtPrice.Text.Trim().Replace(",", ".");
            if (!decimal.TryParse(priceInput, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out price))
            {
                lblMessage.Text = "Invalid price format. Please enter a valid number (e.g., 600.00).";
                lblMessage.CssClass = "alert alert-warning d-block fw-bold";
                return;
            }

            // Calculate the 10% fee for the backend (just in case you need to log it to a revenue table later!)
            decimal platformFee = price * 0.10m;

            JavaScriptSerializer js = new JavaScriptSerializer();
            List<VariantItem> variantsList = js.Deserialize<List<VariantItem>>(variantsJson);

            // 4. FILE UPLOAD LOGIC
            string imagePath = "Images/default.png";

            if (fuImage.HasFile)
            {
                try
                {
                    string extension = Path.GetExtension(fuImage.FileName).ToLower();
                    if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                    {
                        string uniqueFileName = Guid.NewGuid().ToString() + extension;
                        string saveDirectory = Server.MapPath("~/Images/");

                        if (!Directory.Exists(saveDirectory)) Directory.CreateDirectory(saveDirectory);

                        string fullSavePath = Path.Combine(saveDirectory, uniqueFileName);
                        fuImage.SaveAs(fullSavePath);

                        // Matches DB expected format exactly
                        imagePath = "Images/" + uniqueFileName;
                    }
                    else
                    {
                        lblMessage.Text = "Only JPG, PNG, and GIF images are allowed.";
                        lblMessage.CssClass = "alert alert-warning d-block fw-bold";
                        return;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error uploading image: " + ex.Message;
                    lblMessage.CssClass = "alert alert-danger d-block fw-bold";
                    return;
                }
            }

            // 5. DATABASE INSERTION
            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    conn.Open();

                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            // Insert Main Item
                            string insertItemQuery = @"
                                INSERT INTO Item (itemName, itemDescription, price, condition, category, imagePath, sellerID, avalibiltyStatus, dateListed) 
                                VALUES (@Name, @Desc, @Price, @Condition, @Category, @ImagePath, @SellerID, 'Available', GETDATE());
                                SELECT SCOPE_IDENTITY();";

                            int newItemID;

                            using (SqlCommand cmdItem = new SqlCommand(insertItemQuery, conn, transaction))
                            {
                                cmdItem.Parameters.AddWithValue("@Name", itemName);
                                cmdItem.Parameters.AddWithValue("@Desc", description);
                                cmdItem.Parameters.AddWithValue("@Price", price);
                                cmdItem.Parameters.AddWithValue("@Condition", condition);
                                cmdItem.Parameters.AddWithValue("@Category", category);
                                cmdItem.Parameters.AddWithValue("@ImagePath", imagePath);
                                cmdItem.Parameters.AddWithValue("@SellerID", sellerID);

                                newItemID = Convert.ToInt32(cmdItem.ExecuteScalar());
                            }

                            // Insert ALL variants from the Javascript array
                            foreach (VariantItem variant in variantsList)
                            {
                                string insertVariationQuery = "INSERT INTO ItemVariation (ItemID, Color, Quantity) VALUES (@ItemID, @Color, @Quantity)";
                                using (SqlCommand cmdVar = new SqlCommand(insertVariationQuery, conn, transaction))
                                {
                                    cmdVar.Parameters.AddWithValue("@ItemID", newItemID);
                                    cmdVar.Parameters.AddWithValue("@Color", variant.color);
                                    cmdVar.Parameters.AddWithValue("@Quantity", variant.quantity);
                                    cmdVar.ExecuteNonQuery();
                                }
                            }

                            transaction.Commit();

                            // Redirect to catalogue
                            Response.Redirect("Catalogue.aspx");
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            lblMessage.Text = "Database Error: " + ex.Message;
                            lblMessage.CssClass = "alert alert-danger d-block fw-bold";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Connection Error: " + ex.Message;
                lblMessage.CssClass = "alert alert-danger d-block fw-bold";
            }
        }
    }
}