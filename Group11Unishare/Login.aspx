<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Group11Unishare.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6 col-lg-5">
            <div class="card shadow border-0 rounded-4 mb-5">
                <div class="card-header bg-primary text-white text-center py-4 rounded-top-4">
                    <h3 class="mb-0 fw-bold"><i class="bi bi-box-arrow-in-right me-2"></i>Welcome Back</h3>
                </div>
                <div class="card-body p-4 p-md-5 bg-white">
                    <p class="text-muted mb-4 text-center">Sign in to your Unishare account to access the campus marketplace.</p>

                    <div class="mb-4">
                        <label for="txtEmail" class="form-label fw-bold">Student Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="e.g. 202612345@ufh.ac.za"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4">
                        <div class="d-flex justify-content-between">
                            <label for="txtPassword" class="form-label fw-bold">Password</label>
                            <a href="#" class="small text-decoration-none">Forgot password?</a>
                        </div>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4 d-flex justify-content-center">
                        <div class="g-recaptcha" data-sitekey="6LeMXOksAAAAAPK-VUcxz9fhpO7Pjuz2GHwRTFad"></div>
                    </div>

                    <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold d-block mb-3 text-center"></asp:Label>

                    <div class="d-grid gap-2 mb-4">
                        <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary btn-lg fw-bold shadow-sm rounded-pill" OnClick="btnLogin_Click" />
                    </div>

                    <div class="text-center mt-4 pt-3 border-top">
                        <p class="text-muted mb-0">Don't have an account yet?</p>
                        <a href="Register.aspx" class="text-primary fw-bold text-decoration-none">Create a Student Profile</a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>