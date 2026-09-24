<%@ Page Title="Register Student" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddStudent.aspx.cs" Inherits="LibraryManagementSystem.AddStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-user-plus text-success me-2"></i> Register New Student</h4>
            <p class="text-muted small mb-0">Add student profile details to authorize library book issuing</p>
        </div>
        <div>
            <a href="Students.aspx" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Student Directory
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="card card-custom p-4">
        <div class="row g-4">
            <!-- Left Form Section -->
            <div class="col-12 col-lg-8">
                <div class="row g-3">
                    <div class="col-12 col-md-6">
                        <label for="txtEnrollmentNo" class="form-label fw-semibold small text-secondary">Enrollment / Roll No <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEnrollmentNo" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. ENR2024001" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtFullName" class="form-label fw-semibold small text-secondary">Full Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-custom" placeholder="Enter student full name" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="ddlCourse" class="form-label fw-semibold small text-secondary">Course / Program <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-select form-select-custom" required="required">
                            <asp:ListItem Value="">-- Select Course --</asp:ListItem>
                            <asp:ListItem Value="B.Tech CS">B.Tech Computer Science</asp:ListItem>
                            <asp:ListItem Value="B.Tech IT">B.Tech Information Technology</asp:ListItem>
                            <asp:ListItem Value="B.Tech ECE">B.Tech Electronics & Comm.</asp:ListItem>
                            <asp:ListItem Value="B.Tech Mech">B.Tech Mechanical Eng.</asp:ListItem>
                            <asp:ListItem Value="BCA">BCA (Bachelor of Comp. Apps)</asp:ListItem>
                            <asp:ListItem Value="MCA">MCA (Master of Comp. Apps)</asp:ListItem>
                            <asp:ListItem Value="BBA">BBA (Business Admin)</asp:ListItem>
                            <asp:ListItem Value="MBA">MBA (Master of Business Admin)</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="ddlSemester" class="form-label fw-semibold small text-secondary">Semester / Year <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlSemester" runat="server" CssClass="form-select form-select-custom" required="required">
                            <asp:ListItem Value="">-- Select Semester --</asp:ListItem>
                            <asp:ListItem Value="Semester 1">Semester 1</asp:ListItem>
                            <asp:ListItem Value="Semester 2">Semester 2</asp:ListItem>
                            <asp:ListItem Value="Semester 3">Semester 3</asp:ListItem>
                            <asp:ListItem Value="Semester 4">Semester 4</asp:ListItem>
                            <asp:ListItem Value="Semester 5">Semester 5</asp:ListItem>
                            <asp:ListItem Value="Semester 6">Semester 6</asp:ListItem>
                            <asp:ListItem Value="Semester 7">Semester 7</asp:ListItem>
                            <asp:ListItem Value="Semester 8">Semester 8</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtEmail" class="form-label fw-semibold small text-secondary">Email Address <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control form-control-custom" placeholder="student@university.edu" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtMobileNo" class="form-label fw-semibold small text-secondary">Mobile Number (+91) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtMobileNo" runat="server" CssClass="form-control form-control-custom" placeholder="+91 98765 43210" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12">
                        <label for="txtAddress" class="form-label fw-semibold small text-secondary">Campus / Residential Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control form-control-custom" placeholder="Enter student address"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Right File Upload & Preview Section -->
            <div class="col-12 col-lg-4 border-start border-light-subtle">
                <div class="text-center p-3">
                    <label class="form-label fw-semibold small text-secondary d-block mb-3">Student Photo</label>
                    
                    <div class="mb-3">
                        <img id="imgStudentPreview" src="https://via.placeholder.com/150x150/4f46e5/ffffff?text=Student+Photo" alt="Photo Preview" class="img-fluid rounded-circle shadow-sm border" style="width: 150px; height: 150px; object-fit: cover;" />
                    </div>

                    <div class="mb-3">
                        <asp:FileUpload ID="fuPhoto" runat="server" CssClass="form-control form-control-sm" onchange="previewUploadedImage(this, 'imgStudentPreview');" />
                        <small class="text-muted d-block mt-1">Allowed formats: JPG, PNG, WEBP (Max 5MB)</small>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="col-12 pt-3 border-top d-flex gap-2">
                <asp:Button ID="btnSaveStudent" runat="server" Text="Register Student" CssClass="btn btn-primary-custom px-4" OnClick="btnSaveStudent_Click" />
                <a href="Students.aspx" class="btn btn-light px-4">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
