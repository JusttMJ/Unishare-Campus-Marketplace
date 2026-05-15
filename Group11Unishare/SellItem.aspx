<%@ Page Title="Sell an Item" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SellItem.aspx.cs" Inherits="Group11Unishare.SellItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .color-picker-input {
            height: calc(3rem + 2px) !important;
            padding: 0.5rem !important;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container mt-4">
        <h2 class="fw-bold text-dark mb-1" style="color: #003366;">List an Item</h2>
        <p class="text-muted mb-4">A 10% platform fee applies to all listings. Please complete payment to publish.</p>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

        <div class="row g-4">
            <div class="col-lg-7">
                <div class="card shadow-sm border-0 rounded-3 mb-4">
                    <div class="card-header bg-white fw-bold text-uppercase text-muted py-3">
                        Item Details
                    </div>
                    <div class="card-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Item Name</label>
                            <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" Required="true"></asp:TextBox>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Category</label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Textbooks" Value="Textbooks"></asp:ListItem>
                                    <asp:ListItem Text="Electronics" Value="Electronics"></asp:ListItem>
                                    <asp:ListItem Text="Dorm Room" Value="Dorm Room"></asp:ListItem>
                                    <asp:ListItem Text="Clothing" Value="Clothing"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Condition</label>
                                <asp:DropDownList ID="ddlCondition" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Brand New" Value="New"></asp:ListItem>
                                    <asp:ListItem Text="Like New" Value="Like New"></asp:ListItem>
                                    <asp:ListItem Text="Good" Value="Good"></asp:ListItem>
                                    <asp:ListItem Text="Fair (Heavily Used)" Value="Fair"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" Required="true"></asp:TextBox>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-primary">Selling Price (ZAR)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light fw-bold">R</span>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control form-control-lg fw-bold" onkeyup="calculateDynamicFee()" placeholder="0.00" Required="true"></asp:TextBox>
                            </div>
                            <div class="form-text">Type your price to see the 10% listing fee.</div>
                        </div>

                        <div class="card mb-4 border-secondary-subtle bg-light">
                            <div class="card-body">
                                <label class="form-label fw-bold text-dark d-block border-bottom pb-2 mb-3">Variants (Colors & Stock)</label>
                                <div class="row align-items-end mb-3">
                                    <div class="col-md-5">
                                        <label class="form-label small fw-bold text-muted">Select Color</label>
                                        <input type="color" id="txtAddColor" class="form-control form-control-color w-100 color-picker-input" value="#000000" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label small fw-bold text-muted">Quantity</label>
                                        <input type="number" id="txtAddQty" class="form-control form-control-lg" min="1" value="1" />
                                    </div>
                                    <div class="col-md-3">
                                        <button type="button" class="btn btn-dark w-100 fw-bold" style="height: calc(3rem + 2px);" onclick="addVariant()">Add</button>
                                    </div>
                                </div>
                                
                                <div id="variantList" class="d-flex flex-wrap gap-2 mt-2"></div>
                                <asp:HiddenField ID="hfVariants" runat="server" />
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label fw-bold">Upload Product Image</label>
                            <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" accept=".jpg,.jpeg,.png,.gif" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card shadow-sm border-0 rounded-3 h-100 bg-light">
                    <div class="card-header bg-dark text-white fw-bold text-uppercase py-3">
                        <i class="bi bi-shield-lock-fill me-2 text-success"></i> Secure Payment
                    </div>
                    <div class="card-body p-4 d-flex flex-column">
                        
                        <div class="bg-white border rounded p-3 mb-4 text-center shadow-sm">
                            <span class="d-block text-muted fw-bold small text-uppercase">Platform Listing Fee (10%)</span>
                            <span id="feeDisplay" class="fs-2 fw-bold text-primary">R 0.00</span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small">Name on Card</label>
                            <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control" placeholder="John Doe"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small">Card Number</label>
                            <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control" placeholder="XXXX XXXX XXXX XXXX" MaxLength="16"></asp:TextBox>
                        </div>

                        <div class="row mb-4">
                            <div class="col-6">
                                <label class="form-label fw-bold small">Expiry (MM/YY)</label>
                                <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="12/25"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold small">CVV</label>
                                <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="123" MaxLength="3"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mt-auto">
                            <asp:Button ID="btnSubmitListing" runat="server" Text="Enter Price to Continue" 
                                CssClass="btn btn-primary w-100 fw-bold py-3 fs-5 shadow-sm" 
                                OnClick="btnSubmitListing_Click" OnClientClick="return validateForm();" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // --- 10% FEE CALCULATOR ---
        function calculateDynamicFee() {
            // Get the price and handle the comma-to-dot issue for JS math
            let priceInput = document.getElementById('<%= txtPrice.ClientID %>').value.replace(',', '.');
            let price = parseFloat(priceInput);

            // Validate it's a real number
            if (isNaN(price) || price <= 0) {
                document.getElementById('feeDisplay').innerText = "R 0.00";
                document.getElementById('<%= btnSubmitListing.ClientID %>').value = "Enter Price to Continue";
                return;
            }

            // Calculate exactly 10%
            let fee = price * 0.10;

            // Update the UI
            document.getElementById('feeDisplay').innerText = "R " + fee.toFixed(2);
            document.getElementById('<%= btnSubmitListing.ClientID %>').value = "Pay R" + fee.toFixed(2) + " & Publish";
        }

        // --- MULTI-VARIANT BUILDER ---
        let variantArray = [];

        function addVariant() {
            let color = document.getElementById('txtAddColor').value;
            let qty = parseInt(document.getElementById('txtAddQty').value);
            
            if (qty > 0) {
                let existing = variantArray.find(v => v.color === color);
                if(existing) {
                    existing.quantity += qty;
                } else {
                    variantArray.push({ color: color, quantity: qty });
                }
                updateVariantUI();
                document.getElementById('txtAddQty').value = 1; 
            }
        }

        function removeVariant(index) {
            variantArray.splice(index, 1);
            updateVariantUI();
        }

        function updateVariantUI() {
            let container = document.getElementById('variantList');
            container.innerHTML = '';
            
            variantArray.forEach((v, index) => {
                container.innerHTML += `
                    <span class="badge bg-white text-dark border p-2 d-flex align-items-center shadow-sm">
                        <div style="width: 15px; height: 15px; background-color: ${v.color}; border-radius: 50%; margin-right: 8px; border: 1px solid #ccc;"></div>
                        ${v.quantity} in stock
                        <span class="text-danger ms-2" style="cursor:pointer; font-weight:bold;" onclick="removeVariant(${index})">X</span>
                    </span>`;
            });
            
            document.getElementById('<%= hfVariants.ClientID %>').value = JSON.stringify(variantArray);
        }

        function validateForm() {
            // 1. Check variants
            if (variantArray.length === 0) {
                alert("Please add at least one color and stock quantity variant.");
                return false;
            }
            // 2. Check Simulated Payment Fields
            let cardName = document.getElementById('<%= txtCardName.ClientID %>').value;
            let cardNum = document.getElementById('<%= txtCardNumber.ClientID %>').value;
            if (cardName.trim() === "" || cardNum.trim() === "") {
                alert("Please complete the simulated payment details before publishing.");
                return false;
            }
            return true;
        }
    </script>
</asp:Content>