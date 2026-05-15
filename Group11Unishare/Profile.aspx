<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Group11Unishare.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mt-4 mb-4 pb-2 border-bottom">
        <h2 class="text-primary mb-0"><i class="bi bi-person-gear me-2"></i>Account Settings</h2>
        <a href="Catalogue.aspx" class="btn btn-outline-primary fw-bold rounded-pill px-4 shadow-sm">
            ← Back to Catalogue
        </a>
    </div>

    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3"></asp:Label>

    <div class="row">
        <div class="col-md-7 mb-4">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-person-lines-fill text-primary me-2"></i> Personal Information
                </div>
                <div class="card-body p-4 bg-light">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Full Name / Username</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">University Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Contact Number (WhatsApp/Call)</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. 071 234 5678"></asp:TextBox>
                        <small class="text-muted">This helps buyers and sellers coordinate handovers.</small>
                    </div>
                    
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" 
                        CssClass="btn btn-primary fw-bold w-100 rounded-pill" OnClick="btnSaveProfile_Click" />
                </div>
            </div>
        </div>

        <div class="col-md-5 mb-4">
            <div class="card shadow-sm border-0 rounded-4 h-100">
                <div class="card-header bg-white border-bottom fw-bold fs-5 py-3">
                    <i class="bi bi-shield-lock-fill text-danger me-2"></i> Security
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-warning small mb-4">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> You must enter your current password to make security changes.
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Current Password</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnUpdatePassword" runat="server" Text="Update Password" 
                        CssClass="btn btn-danger fw-bold w-100 rounded-pill" OnClick="btnUpdatePassword_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>