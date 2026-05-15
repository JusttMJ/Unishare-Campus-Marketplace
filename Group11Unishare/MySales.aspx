<%@ Page Title="My Sales" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MySales.aspx.cs" Inherits="Group11Unishare.MySales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4 pb-2 border-bottom">
        <h2 class="text-success mb-0"><i class="bi bi-shop me-2"></i>Seller Dashboard</h2>
        <a href="Catalogue.aspx" class="btn btn-outline-success fw-bold rounded-pill px-4 shadow-sm">
            ← Back to Catalogue
        </a>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row">
        <asp:Repeater ID="rptSales" runat="server" OnItemCommand="rptSales_ItemCommand">
            <ItemTemplate>
                <div class="col-12 mb-3">
                    <div class="card shadow-sm border-0 rounded-4 border-start border-success border-4">
                        <div class="card-body d-flex flex-column flex-md-row justify-content-between align-items-center p-4">
                            
                            <div class="mb-3 mb-md-0">
                                <h5 class="card-title fw-bold text-dark mb-1"><%# Eval("itemName") %></h5>
                                <p class="text-primary small mb-1 fw-bold">
                                    <i class="bi bi-person-badge me-1"></i> Buyer: <%# Eval("BuyerName") %>
                                </p>
                                <p class="text-muted small mb-0">
                                    <i class="bi bi-clock-history me-1"></i> Sold on: <%# Convert.ToDateTime(Eval("orderDate")).ToString("dd MMM yyyy, HH:mm") %>
                                </p>
                            </div>

                            <div class="text-md-end border-start-md ps-md-4">
                                <h5 class="text-success fw-bold mb-1">Earned: R <%# Eval("priceAtPurchase", "{0:0.00}") %></h5>
                                <span class="badge bg-dark rounded-pill mb-1">Order #<%# Eval("orderID") %></span>
                                
                                <p class='<%# Eval("fulfillmentMethod").ToString().Contains("Delivery") ? "small text-danger mb-0 fw-bold mt-2" : "small text-info mb-0 fw-bold mt-2" %>'>
                                    <i class="bi bi-truck me-1"></i> <%# Eval("fulfillmentMethod") %>
                                </p>

                                <p class="small text-dark mb-0 fw-bold mt-1 bg-light p-2 rounded border">
                                    <i class="bi bi-geo-alt-fill me-1 text-danger"></i> <%# Eval("deliveryAddress") %>
                                </p>
                                
                                <p class="small text-secondary mb-0 fw-bold mt-2 border-bottom pb-2">
                                    Payment: <%# Eval("paymentStatus") %>
                                </p>

                                <div class="mt-2 text-start text-md-end">
                                    <label class="small fw-bold text-muted d-block mb-1">Update Order Status:</label>
                                    <div class="input-group input-group-sm mb-0 justify-content-md-end">
                                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm" style="max-width: 180px;">
                                            <asp:ListItem Text="Order Placed" Value="Order Placed"></asp:ListItem>
                                            <asp:ListItem Text="Confirmed" Value="Confirmed"></asp:ListItem>
                                            <asp:ListItem Text="Ready for Collection" Value="Ready for Collection"></asp:ListItem>
                                            <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Button ID="btnUpdateStatus" runat="server" Text="Save" 
                                            CssClass="btn btn-outline-primary fw-bold" 
                                            CommandName="UpdateStatus" 
                                            CommandArgument='<%# Eval("orderID") %>' />
                                    </div>
                                    <small class="text-primary fw-bold d-block mt-1">Current: <%# Eval("orderStatus") %></small>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </ItemTemplate>
            
            <FooterTemplate>
                <asp:Label ID="lblNoSales" runat="server" Visible="false" CssClass="alert alert-success d-block text-center fw-bold shadow-sm rounded-4 w-100">
                    <i class="bi bi-shop-window me-2"></i> You haven't sold any items yet. Keep listing!
                </asp:Label>
            </FooterTemplate>
        </asp:Repeater>
    </div>

</asp:Content>