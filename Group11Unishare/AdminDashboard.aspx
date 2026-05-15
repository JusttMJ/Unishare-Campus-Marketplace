<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="Group11Unishare.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4 pb-2 border-bottom">
        <h2 class="text-danger mb-0"><i class="bi bi-shield-lock me-2"></i>Admin Control Center</h2>
        <a href="Catalogue.aspx" class="btn btn-outline-danger fw-bold rounded-pill px-4 shadow-sm">
            Exit Admin Mode
        </a>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row mb-4">
        <div class="col-md-3 mb-3 mb-md-0">
            <div class="card shadow-sm border-0 bg-primary text-white rounded-4 h-100">
                <div class="card-body d-flex align-items-center">
                    <i class="bi bi-people-fill" style="font-size: 2.5rem; opacity: 0.5;"></i>
                    <div class="ms-3">
                        <h6 class="text-uppercase fw-bold mb-0" style="font-size: 0.75rem;">Total Users</h6>
                        <h3 class="mb-0 fw-bold"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3 mb-md-0">
            <div class="card shadow-sm border-0 bg-success text-white rounded-4 h-100">
                <div class="card-body d-flex align-items-center">
                    <i class="bi bi-box-seam" style="font-size: 2.5rem; opacity: 0.5;"></i>
                    <div class="ms-3">
                        <h6 class="text-uppercase fw-bold mb-0" style="font-size: 0.75rem;">Active Items</h6>
                        <h3 class="mb-0 fw-bold"><asp:Label ID="lblTotalItems" runat="server" Text="0"></asp:Label></h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3 mb-md-0">
            <div class="card shadow-sm border-0 bg-dark text-white rounded-4 h-100">
                <div class="card-body d-flex align-items-center">
                    <i class="bi bi-cash-stack" style="font-size: 2.5rem; opacity: 0.5;"></i>
                    <div class="ms-3">
                        <h6 class="text-uppercase fw-bold mb-0" style="font-size: 0.75rem;">Gross Volume</h6>
                        <h3 class="mb-0 fw-bold fs-5"><asp:Label ID="lblTotalSales" runat="server" Text="R 0.00"></asp:Label></h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm border-0 bg-warning text-dark rounded-4 h-100">
                <div class="card-body d-flex align-items-center">
                    <i class="bi bi-bank" style="font-size: 2.5rem; opacity: 0.5;"></i>
                    <div class="ms-3">
                        <h6 class="text-uppercase fw-bold mb-0" style="font-size: 0.75rem;">Platform Earnings (10%)</h6>
                        <h3 class="mb-0 fw-bold fs-5"><asp:Label ID="lblPlatformRevenue" runat="server" Text="R 0.00"></asp:Label></h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-bar-chart-fill text-warning me-2"></i> Monetization: Platform Revenue by Category
                </div>
                <div class="card-body">
                    <canvas id="revenueChart" height="80"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-md-6 mb-3 mb-md-0">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-trophy text-warning me-2"></i> Top Sellers
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Student Name</th>
                                <th class="text-center">Items Sold</th>
                                <th class="text-end">Revenue Generated</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTopSellers" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold"><i class="bi bi-person-circle text-secondary me-2"></i><%# Eval("userName") %></td>
                                        <td class="text-center"><span class="badge bg-primary rounded-pill"><%# Eval("TotalItemsSold") %></span></td>
                                        <td class="text-end text-success fw-bold">R <%# Eval("TotalRevenue", "{0:0.00}") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-graph-up-arrow text-success me-2"></i> Trending Products
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Item Name</th>
                                <th class="text-center">Quantity Sold</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptTopProducts" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold"><%# Eval("itemName") %></td>
                                        <td class="text-center"><span class="badge bg-success rounded-pill"><%# Eval("TimesSold") %></span></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm border-0 rounded-4">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-tools text-danger me-2"></i> Marketplace Moderation (Active Items)
                </div>
                <div class="card-body p-0 table-responsive" style="max-height: 400px; overflow-y: auto;">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th>Item ID</th>
                                <th>Name</th>
                                <th>Price</th>
                                <th>Seller</th>
                                <th>Date Listed</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAdminItems" runat="server" OnItemCommand="rptAdminItems_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td>#<%# Eval("itemID") %></td>
                                        <td class="fw-bold"><%# Eval("itemName") %></td>
                                        <td>R <%# Eval("price", "{0:0.00}") %></td>
                                        <td><%# Eval("SellerName") %></td>
                                        <td><%# Convert.ToDateTime(Eval("dateListed")).ToString("dd MMM yyyy") %></td>
                                        <td class="text-end">
                                            <asp:Button ID="btnDelete" runat="server" Text="Remove" CommandName="Delete" CommandArgument='<%# Eval("itemID") %>' CssClass="btn btn-sm btn-danger fw-bold" OnClientClick="return confirm('Are you sure you want to remove this listing?');" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="row mb-4">
        <div class="col-12">
            <div class="card shadow-sm border-0 rounded-4 border-start border-success border-4">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3 d-flex justify-content-between align-items-center">
                    <div><i class="bi bi-tags-fill text-success me-2"></i> Discount & Promo Codes</div>
                </div>
                
                <div class="card-body bg-light border-bottom">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-4">
                            <asp:TextBox ID="txtPromoCode" runat="server" CssClass="form-control text-uppercase" placeholder="e.g. EXAMPREP20"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <asp:TextBox ID="txtPromoPercent" runat="server" CssClass="form-control" TextMode="Number" min="1" max="100" placeholder="Discount %"></asp:TextBox>
                                <span class="input-group-text bg-white fw-bold">%</span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <asp:Button ID="btnAddPromo" runat="server" Text="Generate Code" CssClass="btn btn-success w-100 fw-bold shadow-sm" OnClick="btnAddPromo_Click" />
                        </div>
                    </div>
                </div>

                <div class="card-body p-0 table-responsive" style="max-height: 300px; overflow-y: auto;">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th>Promo Code</th>
                                <th>Discount</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptPromotions" runat="server" OnItemCommand="rptPromotions_ItemCommand">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-success fs-5"><%# Eval("PromoCode") %></td>
                                        <td class="fw-bold"><%# Eval("DiscountPercent") %>% OFF</td>
                                        <td>
                                            <span class='badge rounded-pill <%# Convert.ToBoolean(Eval("IsActive")) ? "bg-success" : "bg-danger" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Disabled" %>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <asp:Button ID="btnToggle" runat="server" 
                                                Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Deactivate" : "Activate" %>' 
                                                CommandName="ToggleStatus" 
                                                CommandArgument='<%# Eval("PromoID") %>' 
                                                CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "btn btn-sm btn-outline-danger fw-bold" : "btn btn-sm btn-outline-success fw-bold" %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-12 mb-4">
            <div class="card shadow-sm border-0 rounded-4 border-start border-dark border-4">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-journal-code text-dark me-2"></i> System Audit Log
                </div>
                <div class="card-body p-0 table-responsive" style="max-height: 350px; overflow-y: auto;">
                    <table class="table table-hover table-sm mb-0 align-middle text-muted">
                        <thead class="table-light sticky-top">
                            <tr>
                                <th>Log ID</th>
                                <th>Action Taken</th>
                                <th>Record Ref</th>
                                <th>Timestamp</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAuditLog" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="small">#<%# Eval("AuditLogID") %></td>
                                        <td class="fw-bold text-dark"><%# Eval("Auditdescription") %></td>
                                        <td><span class="badge bg-secondary">Ref #<%# Eval("recordID") %></span></td>
                                        <td class="small"><i class="bi bi-clock me-1"></i><%# Convert.ToDateTime(Eval("actionDate")).ToString("dd MMM yyyy, HH:mm:ss") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const ctx = document.getElementById('revenueChart').getContext('2d');
            
            // These variables grab the data generated by your C# backend!
            const chartLabels = [<%= ChartLabels %>];
            const chartData = [<%= ChartData %>];

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: chartLabels,
                    datasets: [{
                        label: 'Platform Earnings (ZAR)',
                        data: chartData,
                        backgroundColor: 'rgba(255, 193, 7, 0.7)',  // Warning/Gold color for revenue
                        borderColor: 'rgba(211, 158, 0, 1)',
                        borderWidth: 1,
                        borderRadius: 5
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    return 'R ' + context.parsed.y.toFixed(2);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (value) { return 'R ' + value; }
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>