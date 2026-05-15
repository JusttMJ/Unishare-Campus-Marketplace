<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Group11Unishare.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero-wrapper {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            border-radius: 30px;
            padding: 100px 40px;
            color: white;
            margin-top: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
        }
        .glass-panel {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 50px;
        }
        .feature-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 35px;
            height: 100%;
            transition: all 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            border-color: #38bdf8;
            box-shadow: 0 20px 30px rgba(0,0,0,0.05);
        }
        .accent-text { color: #38bdf8; }
        .btn-modern {
            padding: 15px 40px;
            font-weight: 700;
            border-radius: 100px;
            transition: all 0.3s;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="hero-wrapper text-center">
        <div class="glass-panel mx-auto" style="max-width: 1000px;">
            <h1 class="display-2 fw-bold mb-3">South Africa's <span class="accent-text">Student</span> Hub.</h1>
            <p class="lead mb-5 opacity-75 fs-4 mx-auto" style="max-width: 800px;">
                Built by the University of Fort Hare, designed for <span class="fw-bold">every student</span> in South Africa. 
                The ultimate marketplace for textbooks, tech, and academic essentials.
            </p>
            
            <div class="d-flex justify-content-center gap-3">
                <a href="Catalogue.aspx" class="btn btn-primary btn-modern shadow-lg">Browse All Items</a>
                <a href="Register.aspx" class="btn btn-outline-light btn-modern">Join the Movement</a>
            </div>
        </div>
    </div>

    <div class="container py-5">
        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-geo-alt accent-text d-block mb-3" style="font-size: 3rem;"></i>
                    <h4 class="fw-bold">National Reach</h4>
                    <p class="text-muted">Whether you are at UCT, Wits, UFH, or UKZN, Unishare connects students across the country.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-shield-check accent-text d-block mb-3" style="font-size: 3rem;"></i>
                    <h4 class="fw-bold">Student Verified</h4>
                    <p class="text-muted">A marketplace built for students, by students. Secure, peer-to-peer trading you can trust.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-wallet2 accent-text d-block mb-3" style="font-size: 3rem;"></i>
                    <h4 class="fw-bold">Save & Earn</h4>
                    <p class="text-muted">Sell your resources at 10% platform fee and help keep higher education affordable for everyone.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center pb-5 opacity-50">
        <p class="small fw-bold text-uppercase" style="letter-spacing: 2px;">
            Proudly Pioneered by University of Fort Hare Students
        </p>
    </div>

</asp:Content>