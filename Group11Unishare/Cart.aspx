<%@ Page Title="My Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Group11Unishare.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mt-4 mb-4 pb-2 border-bottom">
        <h2 class="text-primary"><i class="bi bi-cart3 me-2"></i>My Shopping Cart</h2>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row">
        <!-- Left Side: Cart Items -->
        <div class="col-lg-8">
            <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
                <ItemTemplate>
                    <div class="card shadow-sm mb-3 border-0">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="card-title fw-bold mb-1"><%# Eval("itemName") %></h5>
                                <h6 class="text-primary fw-bold mb-0">R <%# Eval("price", "{0:0.00}") %></h6>
                            </div>
                            
                            <!-- Remove Button uses the cartID to delete the specific row -->
                            <asp:Button ID="btnRemove" runat="server" Text="Remove" 
                                CssClass="btn btn-sm btn-outline-danger" 
                                CommandName="Remove" 
                                CommandArgument='<%# Eval("cartID") %>' />
                        </div>
                    </div>
                </ItemTemplate>
                
                <FooterTemplate>
                    <asp:Label ID="lblEmptyCart" runat="server" Visible="false" CssClass="text-muted fst-italic">
                        Your cart is currently empty. Go to the catalogue to find some great deals!
                    </asp:Label>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- Right Side: Order Summary -->
        <div class="col-lg-4">
            <div class="card shadow border-0 bg-light">
                <div class="card-body">
                    <h5 class="card-title fw-bold border-bottom pb-2 mb-3">Order Summary</h5>
                    
                    <div class="d-flex justify-content-between mb-3">
                        <span class="fw-bold">Total Due:</span>
                        <span class="text-primary fw-bold fs-5">
                            <asp:Label ID="lblTotal" runat="server" Text="R 0.00"></asp:Label>
                        </span>
                    </div>

                    <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" 
                        CssClass="btn btn-success w-100 fw-bold btn-lg" OnClick="btnCheckout_Click" />
                </div>
            </div>
            
            <div class="mt-3 text-center">
                <a href="Catalogue.aspx" class="text-decoration-none">← Continue Shopping</a>
            </div>
        </div>
    </div>
</asp:Content>