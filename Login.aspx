<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LibraryManagementSystem.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login - Library Management System</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <!-- Font Awesome 6 CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet" />

    <!-- Custom CSS -->
    <link href="~/CSS/style.css" rel="stylesheet" type="text/css" />

    <style>
        body.login-bg {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #312e81 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.96);
            backdrop-filter: blur(16px);
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 440px;
            padding: 2.5rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .login-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.85rem;
            color: #fff;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.4);
        }
    </style>
</head>
<body class="login-bg">
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="text-center mb-4">
                <div class="login-icon mb-3">
                    <i class="fa-solid fa-book-open-reader"></i>
                </div>
                <h3 class="fw-bold text-dark mb-1">LibraryOS</h3>
                <p class="text-muted small">Sign in to access your administrative dashboard</p>
            </div>

            <!-- Error/Info Alert Panel -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i>
                <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </asp:Panel>

            <div class="mb-3">
                <label for="txtUsername" class="form-label fw-semibold small text-secondary">Username</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-user"></i></span>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control bg-light border-start-0" placeholder="Enter your username" required="required" autocomplete="off"></asp:TextBox>
                </div>
            </div>

            <div class="mb-4">
                <label for="txtPassword" class="form-label fw-semibold small text-secondary">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-lock"></i></span>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control bg-light border-start-0" placeholder="Enter your password" required="required"></asp:TextBox>
                </div>
            </div>

            <div class="d-grid mb-3">
                <asp:Button ID="btnLogin" runat="server" Text="Sign In to System" CssClass="btn btn-primary-custom py-2 fw-semibold" OnClick="btnLogin_Click" />
            </div>

            <div class="text-center mt-4 pt-3 border-top">
                <small class="text-muted">Default Credentials: <strong>admin</strong> / <strong>admin123</strong></small>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
