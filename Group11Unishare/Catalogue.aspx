<%@ Page Title="Catalogue" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Catalogue.aspx.cs" Inherits="Group11Unishare.Catalogue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .product-card { 
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            border: 1px solid rgba(0,0,0,0.05) !important;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02) !important;
        }
        .product-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 15px 30px rgba(0,0,0,0.08) !important; 
            border-color: #38bdf8 !important;
        }
        .img-container { 
            height: 240px; 
            overflow: hidden; 
            background: #ffffff; 
            display:flex; 
            align-items:center; 
            justify-content:center;
            padding: 15px;
        }
        .img-container img { 
            max-width: 100%; 
            max-height: 100%; 
            object-fit: contain; 
        }
        .filter-pill { transition: all 0.2s; font-weight: 500; }
        .filter-pill:hover { transform: scale(1.05); }

        .custom-hover-link { transition: color 0.2s ease; cursor: pointer; }
        .custom-hover-link:hover { color: #38bdf8 !important; }

        /* Style for the colorful dropdown */
        .variant-dropdown {
            transition: background-color 0.3s ease;
            font-weight: bold !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex flex-wrap justify-content-between align-items-end mb-4 pb-3 border-bottom border-secondary-subtle gap-3 mt-3">
        <div>
            <h2 class="mb-1 fw-bold text-dark">Explore Campus Market</h2>
            <p class="text-muted mb-0 small">South Africa's student hub. Find textbooks, tech, and essentials.</p>
        </div>

        <div class="input-group shadow-sm rounded-pill overflow-hidden border bg-white p-1" style="max-width: 450px;">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-0 shadow-none px-4" placeholder="Search items..."></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary rounded-pill fw-bold px-4" OnClick="btnSearch_Click" />
        </div>
    </div>

    <div class="w-100 d-flex gap-2 flex-wrap mb-5">
        <asp:Button ID="btnCatAll" runat="server" Text="All Items" CssClass="btn btn-dark rounded-pill px-4 filter-pill shadow-sm" OnClick="FilterCategory_Click" CommandArgument="" />
        <asp:Button ID="btnCatTextbooks" runat="server" Text="Textbooks" CssClass="btn btn-outline-secondary bg-white rounded-pill px-4 filter-pill shadow-sm" OnClick="FilterCategory_Click" CommandArgument="Textbooks" />
        <asp:Button ID="btnCatElectronics" runat="server" Text="Electronics" CssClass="btn btn-outline-secondary bg-white rounded-pill px-4 filter-pill shadow-sm" OnClick="FilterCategory_Click" CommandArgument="Electronics" />
        <asp:Button ID="btnCatDorm" runat="server" Text="Dorm Room" CssClass="btn btn-outline-secondary bg-white rounded-pill px-4 filter-pill shadow-sm" OnClick="FilterCategory_Click" CommandArgument="Dorm Room" />
        <asp:Button ID="btnCatClothing" runat="server" Text="Clothing" CssClass="btn btn-outline-secondary bg-white rounded-pill px-4 filter-pill shadow-sm" OnClick="FilterCategory_Click" CommandArgument="Clothing" />
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row g-4">
        <asp:Repeater ID="rptCatalogue" runat="server" OnItemCommand="rptCatalogue_ItemCommand" OnItemDataBound="rptCatalogue_ItemDataBound">
            <ItemTemplate>
                <div class="col-md-6 col-lg-4 col-xl-3">
                    <div class="card product-card h-100 bg-white rounded-4 overflow-hidden border-0">
                        
                        <a href='ItemDetails.aspx?id=<%# Eval("itemID") %>' class="img-container position-relative border-bottom border-light d-block text-decoration-none">
                            <span class="position-absolute top-0 start-0 m-3 badge rounded-pill bg-dark bg-opacity-75 shadow-sm">
                                <%# Eval("condition") %>
                            </span>
                            <img src='<%# Eval("imagePath") %>' alt='<%# Eval("itemName") %>' />
                        </a>
                        
                        <div class="card-body d-flex flex-column p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <a href='ItemDetails.aspx?id=<%# Eval("itemID") %>' class="text-decoration-none flex-grow-1">
                                    <h5 class="card-title fw-bold text-dark mb-0 fs-6 custom-hover-link"><%# Eval("itemName") %></h5>
                                </a>
                                <span class="badge bg-light text-primary border border-primary-subtle rounded-pill ms-2" style="font-size: 0.7rem;"><%# Eval("category") %></span>
                            </div>
                            
                            <p class="text-secondary small mb-3 fw-semibold d-flex justify-content-between align-items-center border-bottom pb-2">
                                <span><i class="bi bi-person-circle me-1 text-muted"></i> <%# Eval("SellerName") %></span>
                                <span class="text-warning fw-bold">
                                    <i class="bi bi-star-fill"></i> <%# Convert.ToDecimal(Eval("AvgRating")).ToString("0.0") %> 
                                    <span class="text-muted small fw-normal">(<%# Eval("ReviewCount") %>)</span>
                                </span>
                            </p>
                            
                            <p class="card-text text-muted small flex-grow-1" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                <%# Eval("itemDescription") %>
                            </p>
                            
                            <h4 class="fw-bold text-dark mt-3 mb-0">R <%# Eval("price", "{0:0.00}") %></h4>
                        </div>
                        
                        <div class="card-footer bg-white border-0 px-4 pb-4 pt-0">
                            <div class="mb-3">
                                <label class="small text-muted fw-bold mb-1" style="font-size: 0.7rem; text-transform: uppercase;">Select Variant</label>
                                <asp:DropDownList ID="ddlColors" runat="server" CssClass="form-select form-select-sm border-secondary-subtle shadow-sm variant-dropdown"></asp:DropDownList>
                            </div>

                            <% if (Session["UserID"] == null) { %>
                                <a href="Login.aspx" class="btn btn-outline-primary w-100 fw-bold rounded-pill py-2">Sign in to Purchase</a>
                            <% } else { %>
                                <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" 
                                    CssClass="btn btn-primary w-100 fw-bold rounded-pill py-2 shadow-sm" 
                                    CommandName="AddToCart" CommandArgument='<%# Eval("itemID") %>' 
                                    Visible='<%# Eval("sellerID").ToString() != Session["UserID"].ToString() %>' />
                                
                                <asp:Label ID="lblOwnItem" runat="server" 
                                    CssClass="btn btn-light text-secondary border w-100 fw-bold rounded-pill py-2 disabled" 
                                    Visible='<%# Eval("sellerID").ToString() == Session["UserID"].ToString() %>'>
                                    Your Listing
                                </asp:Label>
                            <% } %>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            <FooterTemplate>
                <asp:Label ID="lblNoItems" runat="server" Visible="false" CssClass="alert alert-light border border-dashed d-block text-center fw-bold shadow-sm rounded-4 w-100 py-5 text-muted">
                    <i class="bi bi-search fs-2 d-block mb-2 text-primary"></i> No items found.
                </asp:Label>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>