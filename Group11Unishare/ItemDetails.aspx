<%@ Page Title="Item Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemDetails.aspx.cs" Inherits="Group11Unishare.ItemDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .product-gallery {
            background-color: #ffffff;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            border: 1px solid rgba(0,0,0,0.05);
            text-align: center;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 400px;
        }
        .product-gallery img {
            max-width: 100%;
            max-height: 450px;
            object-fit: contain;
            border-radius: 12px;
        }
        .seller-badge {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
        }
        .action-box {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.03);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="mb-4">
        <a href="Catalogue.aspx" class="text-decoration-none fw-bold" style="color: #64748b; transition: color 0.2s;" onmouseover="this.style.color='#0f172a'" onmouseout="this.style.color='#64748b'">
            <i class="bi bi-arrow-left me-2"></i>Back to Catalogue
        </a>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-4 rounded-3"></asp:Label>

    <div class="row g-5" id="ProductContainer" runat="server">
        
        <div class="col-lg-6">
            <div class="product-gallery position-relative">
                <asp:Label ID="lblConditionBadge" runat="server" CssClass="position-absolute top-0 start-0 m-4 badge rounded-pill bg-dark fs-6 shadow-sm px-3 py-2"></asp:Label>
                <asp:Image ID="imgProduct" runat="server" AlternateText="Product Image" />
            </div>
        </div>

        <div class="col-lg-6 d-flex flex-column">
            
            <div class="mb-2">
                <asp:Label ID="lblCategory" runat="server" CssClass="badge bg-light text-primary border border-primary-subtle rounded-pill px-3 py-2 mb-3" style="font-size: 0.8rem;"></asp:Label>
            </div>
            
            <h1 class="fw-bold text-dark mb-3" style="font-size: 2.5rem; letter-spacing: -1px;"><asp:Label ID="lblItemName" runat="server"></asp:Label></h1>
            <h2 class="fw-bold mb-4" style="color: #003366; font-size: 2rem;">R <asp:Label ID="lblPrice" runat="server"></asp:Label></h2>

            <div class="seller-badge d-flex justify-content-between align-items-center mb-4">
                <div>
                    <span class="d-block small text-muted text-uppercase fw-bold mb-1" style="letter-spacing: 1px; font-size: 0.7rem;">Seller</span>
                    <span class="fw-bold text-dark fs-5"><i class="bi bi-person-circle me-2 text-muted"></i><asp:Label ID="lblSellerName" runat="server"></asp:Label></span>
                </div>
                <div class="text-end border-start ps-4">
                    <span class="d-block small text-muted text-uppercase fw-bold mb-1" style="letter-spacing: 1px; font-size: 0.7rem;">Rating</span>
                    <span class="text-warning fw-bold fs-5"><i class="bi bi-star-fill me-1"></i><asp:Label ID="lblRating" runat="server"></asp:Label></span>
                    <span class="text-muted small ms-1"><asp:Label ID="lblReviewCount" runat="server"></asp:Label></span>
                </div>
            </div>

            <h5 class="fw-bold text-dark mb-3 fs-6 text-uppercase" style="letter-spacing: 1px;">Description</h5>
            <p class="text-secondary mb-5" style="line-height: 1.8; font-size: 1.05rem;">
                <asp:Label ID="lblDescription" runat="server"></asp:Label>
            </p>

            <div class="action-box mt-auto">
                <div class="mb-4">
                    <label class="small text-muted fw-bold mb-2 text-uppercase" style="letter-spacing: 1px; font-size: 0.75rem;">Select Variant</label>
                    <asp:DropDownList ID="ddlColors" runat="server" CssClass="form-select form-select-lg border-secondary-subtle shadow-sm fw-medium"></asp:DropDownList>
                </div>

                <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" 
                    CssClass="btn btn-primary w-100 fw-bold rounded-pill py-3 fs-5 shadow-sm" 
                    OnClick="btnAddToCart_Click" />
                
                <asp:Label ID="lblOwnItem" runat="server" 
                    CssClass="btn btn-light text-secondary border w-100 fw-bold rounded-pill py-3 fs-5 disabled" 
                    Visible="false">
                    This is your listing
                </asp:Label>
            </div>

        </div>
    </div>
</asp:Content>