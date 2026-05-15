<%@ Page Title="My Purchases" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyPurchases.aspx.cs" Inherits="Group11Unishare.MyPurchases" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4 pb-2 border-bottom">
        <h2 class="text-primary mb-0"><i class="bi bi-bag-check me-2"></i>My Purchases</h2>
        <a href="Catalogue.aspx" class="btn btn-outline-primary fw-bold rounded-pill px-4 shadow-sm">
            ← Back to Catalogue
        </a>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row">
        <asp:Repeater ID="rptPurchases" runat="server" OnItemCommand="rptPurchases_ItemCommand">
            <ItemTemplate>
                <div class="col-12 mb-4">
                    <div class='<%# Eval("orderStatus").ToString() == "Cancelled" ? "card shadow-sm border-0 rounded-4 border-start border-danger border-4 opacity-75" : "card shadow-sm border-0 rounded-4 border-start border-primary border-4" %>'>
                        <div class="card-body p-4">
                            
                            <div class="d-flex flex-column flex-md-row justify-content-between align-items-center mb-3">
                                <div class="mb-3 mb-md-0 w-100">
                                    <h5 class="card-title fw-bold text-dark mb-1"><%# Eval("itemName") %></h5>
                                    <p class="text-secondary small mb-1 fw-bold">
                                        <i class="bi bi-shop me-1"></i> Seller: <%# Eval("SellerName") %>
                                    </p>
                                    <p class="text-muted small mb-2">
                                        <i class="bi bi-calendar-event me-1"></i> Ordered: <%# Convert.ToDateTime(Eval("orderDate")).ToString("dd MMM yyyy") %>
                                    </p>
                                    <span class="badge text-white shadow-sm" style='<%# "background-color: " + Eval("selectedColor") + "; text-shadow: 1px 1px 2px #000;" %>'>
                                        Color Selected
                                    </span>
                                </div>

                                <div class="text-md-end border-start-md ps-md-4 w-100 text-md-right">
                                    <h5 class="text-primary fw-bold mb-1">Total: R <%# Eval("totalAmount", "{0:0.00}") %></h5>
                                    <span class="badge bg-dark rounded-pill mb-2">Order #<%# Eval("orderID") %></span>
                                    
                                    <p class="small text-dark mb-1 fw-bold">
                                        Status: <span class='<%# Eval("orderStatus").ToString() == "Cancelled" ? "text-danger" : "text-success" %>'><%# Eval("orderStatus") %></span>
                                    </p>
                                    <p class="small text-secondary mb-2 fw-bold">
                                        Payment: <%# Eval("paymentStatus") %>
                                    </p>

                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel Order" 
                                        CssClass="btn btn-outline-danger btn-sm fw-bold rounded-pill px-3 shadow-sm" 
                                        CommandName="CancelOrder" 
                                        CommandArgument='<%# Eval("orderID") %>' 
                                        Visible='<%# Eval("orderStatus").ToString() != "Cancelled" && Eval("orderStatus").ToString() != "Completed" %>'
                                        OnClientClick="return confirm('Are you sure you want to cancel this order? This will refund your payment and return the item to the marketplace.');" />
                                </div>
                            </div>

                            <asp:Panel ID="pnlReview" runat="server" Visible='<%# Eval("orderStatus").ToString() != "Cancelled" %>' CssClass="bg-light p-3 rounded-3 mt-3 border">
                                <p class="small fw-bold text-muted mb-2"><i class="bi bi-star-fill text-warning me-1"></i>Rate this Item</p>
                                <div class="row align-items-center">
                                    <div class="col-md-3 mb-2 mb-md-0">
                                        <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select form-select-sm border-warning">
                                            <asp:ListItem Text="5 Stars - Excellent" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="4 Stars - Good" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="3 Stars - Average" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="2 Stars - Poor" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="1 Star - Terrible" Value="1"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div class="col-md-6 mb-2 mb-md-0">
                                        <asp:TextBox ID="txtReviewComment" runat="server" CssClass="form-control form-control-sm" placeholder="Leave a review (optional)..."></asp:TextBox>
                                    </div>
                                    <div class="col-md-3 text-md-end">
                                        <asp:Button ID="btnSubmitReview" runat="server" Text="Post Review" 
                                            CssClass="btn btn-sm btn-warning fw-bold text-dark w-100 shadow-sm" 
                                            CommandName="SubmitReview" 
                                            CommandArgument='<%# Eval("itemID") %>' />
                                    </div>
                                </div>
                            </asp:Panel>

                        </div>
                    </div>
                </div>
            </ItemTemplate>
            
            <FooterTemplate>
                <asp:Label ID="lblNoPurchases" runat="server" Visible="false" CssClass="alert alert-primary d-block text-center fw-bold shadow-sm rounded-4 w-100">
                    <i class="bi bi-cart-x me-2"></i> You haven't made any purchases yet. Let's go shopping!
                </asp:Label>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>