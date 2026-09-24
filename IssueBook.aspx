<%@ Page Title="Issue Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IssueBook.aspx.cs" Inherits="LibraryManagementSystem.IssueBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-hand-holding-hand text-warning me-2"></i> Issue Book to Student</h4>
            <p class="text-muted small mb-0">Select student and available book to generate a library issue record</p>
        </div>
        <div>
            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Dashboard
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="row g-4">
        <!-- Left Form Column -->
        <div class="col-12 col-lg-7">
            <div class="card card-custom p-4">
                <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-clipboard-list text-primary me-2"></i> Issue Details</h6>

                <div class="row g-3">
                    <div class="col-12">
                        <label for="ddlStudent" class="form-label fw-semibold small text-secondary">Select Student <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-select form-select-custom" AutoPostBack="true" OnSelectedIndexChanged="ddlStudent_SelectedIndexChanged" required="required">
                        </asp:DropDownList>
                    </div>

                    <div class="col-12">
                        <label for="ddlBook" class="form-label fw-semibold small text-secondary">Select Book <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlBook" runat="server" CssClass="form-select form-select-custom" AutoPostBack="true" OnSelectedIndexChanged="ddlBook_SelectedIndexChanged" required="required">
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtIssueDate" class="form-label fw-semibold small text-secondary">Issue Date <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtIssueDate" runat="server" TextMode="Date" CssClass="form-control form-control-custom" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtDueDate" class="form-label fw-semibold small text-secondary">Due Return Date <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtDueDate" runat="server" TextMode="Date" CssClass="form-control form-control-custom" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12">
                        <label for="txtNotes" class="form-label fw-semibold small text-secondary">Additional Remarks / Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control form-control-custom" placeholder="Optional notes..."></asp:TextBox>
                    </div>

                    <div class="col-12 pt-3 border-top d-flex gap-2">
                        <asp:Button ID="btnConfirmIssue" runat="server" Text="Confirm & Issue Book" CssClass="btn btn-primary-custom px-4" OnClick="btnConfirmIssue_Click" />
                        <a href="Dashboard.aspx" class="btn btn-light px-4">Cancel</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Summary Preview Card Column -->
        <div class="col-12 col-lg-5">
            <!-- Student Preview Card -->
            <asp:Panel ID="pnlStudentInfo" runat="server" CssClass="card card-custom p-4 mb-3">
                <div class="d-flex align-items-center gap-3">
                    <asp:Image ID="imgStudentPreview" runat="server" CssClass="student-avatar-thumb" Style="width: 56px; height: 56px;" ImageUrl="https://via.placeholder.com/80x80/4f46e5/ffffff?text=User" />
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><asp:Literal ID="litStudentName" runat="server">Select a Student</asp:Literal></h6>
                        <small class="text-muted"><asp:Literal ID="litStudentEnrollment" runat="server">No student selected</asp:Literal></small>
                    </div>
                </div>
                <hr class="my-3 border-light-subtle" />
                <div class="row g-2 small">
                    <div class="col-6">Course: <strong><asp:Literal ID="litStudentCourse" runat="server">-</asp:Literal></strong></div>
                    <div class="col-6">Semester: <strong><asp:Literal ID="litStudentSemester" runat="server">-</asp:Literal></strong></div>
                    <div class="col-12">Mobile: <strong><asp:Literal ID="litStudentMobile" runat="server">-</asp:Literal></strong></div>
                    <div class="col-12">Active Issued Books: <span class="badge bg-primary-subtle text-primary"><asp:Literal ID="litStudentActiveCount" runat="server">0</asp:Literal> Books</span></div>
                </div>
            </asp:Panel>

            <!-- Book Preview Card -->
            <asp:Panel ID="pnlBookInfo" runat="server" CssClass="card card-custom p-4">
                <div class="d-flex align-items-center gap-3">
                    <asp:Image ID="imgBookPreview" runat="server" CssClass="img-thumb-custom" Style="width: 50px; height: 65px;" ImageUrl="https://via.placeholder.com/120x160/4f46e5/ffffff?text=Book" />
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><asp:Literal ID="litBookTitle" runat="server">Select a Book</asp:Literal></h6>
                        <small class="text-muted">ISBN: <asp:Literal ID="litBookISBN" runat="server">No book selected</asp:Literal></small>
                    </div>
                </div>
                <hr class="my-3 border-light-subtle" />
                <div class="row g-2 small">
                    <div class="col-12">Author: <strong><asp:Literal ID="litBookAuthor" runat="server">-</asp:Literal></strong></div>
                    <div class="col-12">Category: <strong><asp:Literal ID="litBookCategory" runat="server">-</asp:Literal></strong></div>
                    <div class="col-12">Stock Status: 
                        <asp:Label ID="lblStockStatus" runat="server" CssClass="badge badge-status-available" Text="Select Book"></asp:Label>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
