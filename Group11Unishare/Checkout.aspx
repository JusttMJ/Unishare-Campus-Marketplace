<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Group11Unishare.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlCheckout" runat="server">
        <div class="row mt-4">
            <div class="col-md-7 mb-4">
                <div class="card shadow-sm border-0 rounded-4 mb-4">
                    <div class="card-header bg-primary text-white py-3 fw-bold fs-5">
                        <i class="bi bi-truck me-2"></i>Fulfillment Details
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Select Fulfillment Method:</label>
                            <div class="form-check">
                                <asp:RadioButton ID="rdoMeetup" runat="server" GroupName="Fulfillment" CssClass="form-check-input" Checked="true" AutoPostBack="true" OnCheckedChanged="UpdateTotals_Changed" />
                                <label class="form-check-label">Campus Meetup (Free)</label>
                            </div>
                            <div class="form-check">
                                <asp:RadioButton ID="rdoDelivery" runat="server" GroupName="Fulfillment" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="UpdateTotals_Changed" />
                                <label class="form-check-label">Dorm / Res Delivery (+ R 50.00)</label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Location Details:</label>
                            <asp:TextBox ID="txtDeliveryLocation" runat="server" CssClass="form-control" placeholder="e.g. Student Center or Res Block B"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-dark text-white py-3 fw-bold fs-5">
                        <i class="bi bi-credit-card me-2"></i>Payment Method
                    </div>
                    <div class="card-body">
                        <div class="mb-4 border-bottom pb-3">
                            <div class="form-check form-check-inline">
                                <asp:RadioButton ID="rdoCard" runat="server" GroupName="Payment" CssClass="form-check-input" Checked="true" AutoPostBack="true" OnCheckedChanged="PaymentMethod_Changed" />
                                <label class="form-check-label fw-bold"><i class="bi bi-credit-card-2-front text-primary me-1"></i> Online Card</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <asp:RadioButton ID="rdoCash" runat="server" GroupName="Payment" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="PaymentMethod_Changed" />
                                <label class="form-check-label fw-bold"><i class="bi bi-cash-stack text-success me-1"></i> Cash on Meetup</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <asp:RadioButton ID="rdoVoucher" runat="server" GroupName="Payment" CssClass="form-check-input" AutoPostBack="true" OnCheckedChanged="PaymentMethod_Changed" />
                                <label class="form-check-label fw-bold"><i class="bi bi-ticket-perforated text-warning me-1"></i> Campus Voucher</label>
                            </div>
                        </div>

                        <asp:Panel ID="pnlCardDetails" runat="server">
                            <h6 class="fw-bold mb-3">Card Details (Simulated)</h6>
                            <div class="mb-3">
                                <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control mb-2" placeholder="Name on Card"></asp:TextBox>
                                <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control mb-2" placeholder="Card Number" MaxLength="16"></asp:TextBox>
                                <div class="row">
                                    <div class="col-6"><asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox></div>
                                    <div class="col-6"><asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="CVV" MaxLength="3"></asp:TextBox></div>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="pnlVoucherDetails" runat="server" Visible="false">
                            <h6 class="fw-bold mb-3">Voucher Details</h6>
                            <asp:TextBox ID="txtVoucherCode" runat="server" CssClass="form-control" placeholder="Enter 12-digit Voucher Code"></asp:TextBox>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card shadow border-0 rounded-4 border-top border-success border-4 sticky-top" style="top: 20px;">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Order Summary</h4>
                        
                        <div class="d-flex justify-content-between mb-2 text-muted">
                            <span>Subtotal</span>
                            <span class="fw-bold text-dark"><asp:Label ID="lblSubtotal" runat="server"></asp:Label></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-2 text-success fw-bold" id="divDiscount" runat="server" visible="false">
                            <span>Promo Discount</span>
                            <span>- <asp:Label ID="lblDiscountAmount" runat="server"></asp:Label></span>
                        </div>

                        <div class="d-flex justify-content-between mb-3 text-muted border-bottom pb-3">
                            <span>Delivery Fee</span>
                            <span class="fw-bold text-dark"><asp:Label ID="lblDeliveryFee" runat="server"></asp:Label></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-4">
                            <span class="fs-5 fw-bold">Total</span>
                            <span class="fs-4 fw-bold text-success"><asp:Label ID="lblTotal" runat="server"></asp:Label></span>
                        </div>

                        <div class="mb-4 p-3 bg-light rounded-3 border">
                            <label class="small fw-bold text-muted mb-2"><i class="bi bi-tag-fill me-1"></i>Have a Promo Code?</label>
                            <div class="input-group">
                                <asp:TextBox ID="txtPromoInput" runat="server" CssClass="form-control text-uppercase" placeholder="Enter Code"></asp:TextBox>
                                <asp:Button ID="btnApplyPromo" runat="server" Text="Apply" CssClass="btn btn-dark fw-bold" OnClick="btnApplyPromo_Click" />
                            </div>
                            <asp:Label ID="lblPromoFeedback" runat="server" CssClass="small fw-bold d-block mt-2"></asp:Label>
                        </div>

                        <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold d-block mb-3 text-center"></asp:Label>

                        <div class="d-grid">
                            <asp:Button ID="btnPay" runat="server" Text="Confirm & Pay" CssClass="btn btn-success btn-lg fw-bold shadow-sm" OnClick="btnPay_Click" />
                        </div>
                        <div class="text-center mt-3">
                            <a href="Cart.aspx" class="text-muted small text-decoration-none">← Return to Cart</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="text-center py-5">
        <div class="card shadow-sm border-0 rounded-4 max-w-md mx-auto p-5" style="max-width: 500px;">
            <i class="bi bi-check-circle-fill text-success mb-3" style="font-size: 5rem;"></i>
            <h2 class="fw-bold mb-3">Payment Successful!</h2>
            <p class="text-muted mb-4">Thank you for your purchase. Your order has been placed successfully.</p>
            
            <div class="bg-light rounded-3 p-3 mb-4 text-start border">
                <p class="mb-1 fw-bold text-secondary small">ORDER NUMBER</p>
                <h4 class="text-dark fw-bold mb-0"><asp:Label ID="lblOrderNumber" runat="server"></asp:Label></h4>
            </div>

            <p class="small text-muted mb-4 fw-bold"><asp:Label ID="lblPaymentReminder" runat="server"></asp:Label></p>

            <a href="MyPurchases.aspx" class="btn btn-primary fw-bold px-4 rounded-pill shadow-sm">View My Purchases</a>
        </div>
    </asp:Panel>

</asp:Content>