using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Group11Unishare
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                // Set default discount to 0%
                ViewState["DiscountPercent"] = 0;
                CalculateTotals();
            }
        }

        protected void PaymentMethod_Changed(object sender, EventArgs e)
        {
            pnlCardDetails.Visible = rdoCard.Checked;
            pnlVoucherDetails.Visible = rdoVoucher.Checked;
        }

        protected void UpdateTotals_Changed(object sender, EventArgs e)
        {
            CalculateTotals();
        }

        // NEW: Handles the Promo Code Button
        protected void btnApplyPromo_Click(object sender, EventArgs e)
        {
            string code = txtPromoInput.Text.Trim().ToUpper();
            lblPromoFeedback.Text = "";

            if (string.IsNullOrEmpty(code))
            {
                lblPromoFeedback.Text = "Please enter a code.";
                lblPromoFeedback.CssClass = "small fw-bold text-danger d-block mt-2";
                return;
            }

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    // Check if code exists AND is active
                    string query = "SELECT DiscountPercent FROM Promotion WHERE PromoCode = @Code AND IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Code", code);
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            // Success! Save the discount percentage and recalculate
                            int discountPercent = Convert.ToInt32(result);
                            ViewState["DiscountPercent"] = discountPercent;

                            lblPromoFeedback.Text = $"Success! {discountPercent}% discount applied.";
                            lblPromoFeedback.CssClass = "small fw-bold text-success d-block mt-2";

                            CalculateTotals(); // Recalculate with the new discount
                        }
                        else
                        {
                            lblPromoFeedback.Text = "Invalid or expired promo code.";
                            lblPromoFeedback.CssClass = "small fw-bold text-danger d-block mt-2";
                            ViewState["DiscountPercent"] = 0; // Reset
                            CalculateTotals();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblPromoFeedback.Text = "Error verifying code: " + ex.Message;
                lblPromoFeedback.CssClass = "small fw-bold text-danger d-block mt-2";
            }
        }

        private void CalculateTotals()
        {
            string userID = Session["UserID"].ToString();
            decimal subtotal = 0;

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    string query = @"
                        SELECT ISNULL(SUM(i.price), 0) 
                        FROM Cart c
                        INNER JOIN Item i ON c.itemID = i.itemID
                        WHERE c.userID = @UserID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        conn.Open();
                        subtotal = Convert.ToDecimal(cmd.ExecuteScalar());
                    }
                }

                // THE NEW PROMO MATH
                decimal discountPercent = Convert.ToDecimal(ViewState["DiscountPercent"]);
                CheckoutTotals totals = PricingCalculator.CalculateTotals(subtotal, discountPercent, rdoDelivery.Checked);
                decimal discountAmount = totals.DiscountAmount;

                // Update UI Labels
                lblSubtotal.Text = "R " + totals.Subtotal.ToString("0.00");

                if (discountAmount > 0)
                {
                    divDiscount.Visible = true;
                    lblDiscountAmount.Text = "R " + discountAmount.ToString("0.00");
                }
                else
                {
                    divDiscount.Visible = false;
                }

                lblDeliveryFee.Text = "R " + totals.DeliveryFee.ToString("0.00");
                lblTotal.Text = "R " + totals.Total.ToString("0.00");

                // Save total to ViewState so we can use it during the final payment insertion
                ViewState["OrderTotal"] = totals.Total;
            }
            catch (Exception ex)
            {
                lblError.Text = "Error calculating totals: " + ex.Message;
            }
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            lblError.Text = "";
            string userID = Session["UserID"].ToString();
            decimal totalAmount = Convert.ToDecimal(ViewState["OrderTotal"]);
            decimal discountPercent = Convert.ToDecimal(ViewState["DiscountPercent"]);

            if (totalAmount == 0 && Convert.ToDecimal(ViewState["DiscountPercent"]) == 0) // Allows R0 totals IF they used a 100% off promo
            {
                lblError.Text = "Your cart is empty!";
                return;
            }

            string fulfillment = rdoDelivery.Checked ? "Dorm / Res Delivery" : "Campus Meetup";
            string address = txtDeliveryLocation.Text.Trim();

            string paymentMethod = "Online Card";
            if (rdoCash.Checked) paymentMethod = "Cash at Handover";
            if (rdoVoucher.Checked) paymentMethod = "Campus Voucher";

            if (string.IsNullOrEmpty(address))
            {
                lblError.Text = "Please provide a delivery or meetup location.";
                return;
            }

            try
            {
                using (SqlConnection conn = DatabaseHelper.GetConnection())
                {
                    conn.Open();

                    using (SqlTransaction transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            string insertOrder = @"
                                INSERT INTO OrderRecord (buyerID, orderDate, fulfillmentMethod, deliveryAddress, paymentStatus, orderStatus, totalAmount) 
                                VALUES (@BuyerID, GETDATE(), @Fulfillment, @Address, @PayStatus, 'Order Placed', @Total);
                                SELECT SCOPE_IDENTITY();";

                            int newOrderID;
                            using (SqlCommand cmd = new SqlCommand(insertOrder, conn, transaction))
                            {
                                cmd.Parameters.AddWithValue("@BuyerID", userID);
                                cmd.Parameters.AddWithValue("@Fulfillment", fulfillment);
                                cmd.Parameters.AddWithValue("@Address", address);
                                cmd.Parameters.AddWithValue("@PayStatus", rdoCash.Checked ? "Pending (Cash)" : "Paid");
                                cmd.Parameters.AddWithValue("@Total", totalAmount);

                                newOrderID = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            string getCartItems = @"
                                SELECT c.itemID, c.selectedColor, i.price, i.sellerID
                                FROM Cart c
                                INNER JOIN Item i ON c.itemID = i.itemID
                                WHERE c.userID = @UserID";

                            using (SqlCommand cartCmd = new SqlCommand(getCartItems, conn, transaction))
                            {
                                cartCmd.Parameters.AddWithValue("@UserID", userID);

                                using (SqlDataReader reader = cartCmd.ExecuteReader())
                                {
                                    DataTable dtCart = new DataTable();
                                    dtCart.Load(reader);

                                    foreach (DataRow row in dtCart.Rows)
                                    {
                                        string itemID = row["itemID"].ToString();
                                        string sellerID = row["sellerID"].ToString();
                                        decimal originalPrice = Convert.ToDecimal(row["price"]);
                                        string selectedColor = row["selectedColor"].ToString();

                                        // Apply the same discount math to the individual order item!
                                        decimal finalItemPrice = PricingCalculator.CalculateDiscountedPrice(originalPrice, discountPercent);

                                        string insertOrderItem = "INSERT INTO OrderItem (orderID, itemID, priceAtPurchase, sellerID, selectedColor) VALUES (@OrderID, @ItemID, @Price, @SellerID, @Color)";
                                        using (SqlCommand cmdInsert = new SqlCommand(insertOrderItem, conn, transaction))
                                        {
                                            cmdInsert.Parameters.AddWithValue("@OrderID", newOrderID);
                                            cmdInsert.Parameters.AddWithValue("@ItemID", itemID);
                                            cmdInsert.Parameters.AddWithValue("@Price", finalItemPrice);
                                            cmdInsert.Parameters.AddWithValue("@SellerID", sellerID);
                                            cmdInsert.Parameters.AddWithValue("@Color", selectedColor);
                                            cmdInsert.ExecuteNonQuery();
                                        }

                                        string updateInventory = "UPDATE ItemVariation SET Quantity = Quantity - 1 WHERE ItemID = @ItemID AND Color = @Color AND Quantity > 0";
                                        using (SqlCommand cmdInv = new SqlCommand(updateInventory, conn, transaction))
                                        {
                                            cmdInv.Parameters.AddWithValue("@ItemID", itemID);
                                            cmdInv.Parameters.AddWithValue("@Color", selectedColor);
                                            cmdInv.ExecuteNonQuery();
                                        }
                                    }
                                }
                            }

                            string emptyCart = "DELETE FROM Cart WHERE userID = @UserID";
                            using (SqlCommand cmdEmpty = new SqlCommand(emptyCart, conn, transaction))
                            {
                                cmdEmpty.Parameters.AddWithValue("@UserID", userID);
                                cmdEmpty.ExecuteNonQuery();
                            }

                            transaction.Commit();

                            pnlCheckout.Visible = false;
                            pnlSuccess.Visible = true;
                            lblOrderNumber.Text = "#" + newOrderID.ToString();

                            if (rdoCash.Checked)
                            {
                                lblPaymentReminder.Text = "Reminder: You have selected Cash. Please bring exact change to the meetup.";
                            }
                            else
                            {
                                lblPaymentReminder.Text = "Your digital payment was processed successfully. The seller has been notified!";
                            }
                        }
                        catch (Exception innerEx)
                        {
                            transaction.Rollback();
                            lblError.Text = "Transaction failed and was rolled back: " + innerEx.Message;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Database connection error: " + ex.Message;
            }
        }
    }
}
