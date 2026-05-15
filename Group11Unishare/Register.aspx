<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Group11Unishare.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow border-0 mb-5">
                <div class="card-header bg-dark text-white text-center py-3">
                    <h3 class="mb-0">Create Your Profile</h3>
                </div>
                <div class="card-body p-4 bg-white">
                    <p class="text-muted mb-4 text-center">Join the Unishare community to access affordable academic resources across South Africa.</p>

                    <div class="mb-3">
                        <label for="txtFullName" class="form-label fw-bold">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="e.g. Mulanga Mukhumeni"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label for="txtEmail" class="form-label fw-bold">Student Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="e.g. 202612345@ufh.ac.za"></asp:TextBox>
                        <small class="text-muted">Please use your official university email domain.</small>
                    </div>

                    <div class="mb-3">
                        <label for="ddlUniversity" class="form-label fw-bold">University</label>
                        <asp:DropDownList ID="ddlUniversity" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlUniversity_SelectedIndexChanged">
                            <asp:ListItem Text="-- Select your university --" Value="" />
                        </asp:DropDownList>
                    </div>

                    <div class="mb-3">
                        <label for="ddlCampus" class="form-label fw-bold">Primary Campus Location</label>
                        <asp:DropDownList ID="ddlCampus" runat="server" CssClass="form-select" Enabled="false">
                            <asp:ListItem Text="-- Select a university first --" Value="" />
                        </asp:DropDownList>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="txtPassword" class="form-label fw-bold">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="txtConfirmPassword" class="form-label fw-bold">Confirm Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="ddlRole" class="form-label fw-bold">Account Type</label>
                        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
                            <asp:ListItem Text="-- Select your role --" Value="" />
                        </asp:DropDownList>
                    </div>

                    <div class="mb-4 form-check">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label" for="chkTerms">
                            I agree to the <a href="#" class="text-decoration-none">Terms and Conditions</a>
                        </label>
                    </div>

                    <div class="mb-3 d-flex justify-content-center">
                        <div class="g-recaptcha" data-sitekey="6LeMXOksAAAAAPK-VUcxz9fhpO7Pjuz2GHwRTFad"></div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mb-3">
                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary px-4" OnClick="btnClear_Click" CausesValidation="false" />
                        <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary px-4" OnClick="btnRegister_Click" />
                    </div>

                    <div class="text-center mt-3">
                        <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold"></asp:Label>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>