<%@ Page Title="Return Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ReturnBook.aspx.cs" Inherits="LibraryManagementSystem.ReturnBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-rotate-left text-info me-2"></i> Receive Returned Book</h4>
            <p class="text-muted small mb-0">Search active issues, calculate late fines automatically, and update library stock</p>
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

    <!-- Search & Active Issues Panel -->
    <div class="card card-custom p-4 mb-4">
        <h6 class="fw-bold text-dark mb-3"><i class="fa-solid fa-magnifying-glass text-primary me-2"></i> Active Book Issues Directory</h6>

        <div class="table-responsive">
            <asp:GridView ID="gvActiveIssues" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true"
                CssClass="table table-hover align-middle datatable w-100" DataKeyNames="IssueID" 
                OnRowCommand="gvActiveIssues_RowCommand">
                <Columns>
                    <asp:BoundField DataField="IssueID" HeaderText="# Issue ID" />

                    <asp:TemplateField HeaderText="Student">
                        <ItemTemplate>
                            <div class="fw-bold text-dark"><%# Eval("StudentName") %></div>
                            <small class="text-muted"><%# Eval("EnrollmentNo") %> (<%# Eval("Course") %>)</small>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Book Details">
                        <ItemTemplate>
                            <div class="fw-bold text-dark"><%# Eval("BookTitle") %></div>
                            <small class="text-muted">ISBN: <%# Eval("ISBN") %></small>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Issue / Due Date">
                        <ItemTemplate>
                            <div>Issue: <%# Convert.ToDateTime(Eval("IssueDate")).ToString("dd MMM yyyy") %></div>
                            <div class="small fw-semibold text-danger">Due: <%# Convert.ToDateTime(Eval("DueDate")).ToString("dd MMM yyyy") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Overdue Status">
                        <ItemTemplate>
                            <span class='<%# Convert.ToInt32(Eval("DaysOverdue")) > 0 ? "badge-status-overdue" : "badge-status-issued" %>'>
                                <%# Convert.ToInt32(Eval("DaysOverdue")) > 0 ? Eval("DaysOverdue") + " Days Late" : "On Time" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="text-end">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnSelectReturn" runat="server" CommandName="SelectReturn" CommandArgument='<%# Eval("IssueID") %>' 
                                CssClass="btn btn-sm btn-primary-custom">
                                <i class="fa-solid fa-box-check me-1"></i> Process Return
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center py-4 text-muted">
                        <i class="fa-solid fa-circle-check fs-2 mb-2 d-block text-success"></i>
                        No active book issues found. All books are currently returned.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

    <!-- Return Details & Calculation Modal/Panel -->
    <asp:Panel ID="pnlReturnProcess" runat="server" Visible="false" CssClass="card card-custom p-4 border-primary">
        <h5 class="fw-bold text-dark mb-3"><i class="fa-solid fa-calculator text-primary me-2"></i> Process Return & Fine Settlement</h5>
        <asp:HiddenField ID="hfSelectedIssueID" runat="server" />
        <asp:HiddenField ID="hfSelectedBookID" runat="server" />

        <div class="row g-3 mb-3">
            <div class="col-12 col-md-6">
                <div class="p-3 bg-light rounded border">
                    <small class="text-muted d-block">Student Info</small>
                    <h6 class="fw-bold text-dark mb-0"><asp:Literal ID="litRetStudentName" runat="server"></asp:Literal></h6>
                    <small class="text-secondary"><asp:Literal ID="litRetEnrollment" runat="server"></asp:Literal></small>
                </div>
            </div>
            <div class="col-12 col-md-6">
                <div class="p-3 bg-light rounded border">
                    <small class="text-muted d-block">Book Info</small>
                    <h6 class="fw-bold text-dark mb-0"><asp:Literal ID="litRetBookTitle" runat="server"></asp:Literal></h6>
                    <small class="text-secondary">ISBN: <asp:Literal ID="litRetISBN" runat="server"></asp:Literal></small>
                </div>
            </div>
        </div>

        <div class="row g-3">
            <div class="col-12 col-md-3">
                <label class="form-label small fw-semibold text-secondary">Issue Date</label>
                <asp:TextBox ID="txtRetIssueDate" runat="server" CssClass="form-control form-control-custom" ReadOnly="true"></asp:TextBox>
            </div>
            <div class="col-12 col-md-3">
                <label class="form-label small fw-semibold text-secondary">Due Date</label>
                <asp:TextBox ID="txtRetDueDate" runat="server" CssClass="form-control form-control-custom" ReadOnly="true"></asp:TextBox>
            </div>
            <div class="col-12 col-md-3">
                <label class="form-label small fw-semibold text-secondary">Overdue Late Days</label>
                <asp:TextBox ID="txtLateDays" runat="server" CssClass="form-control form-control-custom text-danger fw-bold" ReadOnly="true"></asp:TextBox>
            </div>
            <div class="col-12 col-md-3">
                <label class="form-label small fw-semibold text-secondary">Calculated Fine (₹2/day)</label>
                <div class="input-group">
                    <span class="input-group-text">₹</span>
                    <asp:TextBox ID="txtFineAmount" runat="server" CssClass="form-control form-control-custom fw-bold text-primary"></asp:TextBox>
                </div>
            </div>

            <div class="col-12">
                <label for="txtReturnNotes" class="form-label small fw-semibold text-secondary">Return Condition / Notes</label>
                <asp:TextBox ID="txtReturnNotes" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. Returned in good condition"></asp:TextBox>
            </div>

            <div class="col-12 pt-3 border-top d-flex gap-2">
                <asp:Button ID="btnConfirmReturnSubmit" runat="server" Text="Complete Book Return" CssClass="btn btn-success px-4 fw-semibold" OnClick="btnConfirmReturnSubmit_Click" />
                <asp:Button ID="btnCancelProcess" runat="server" Text="Cancel" CssClass="btn btn-light px-4" OnClick="btnCancelProcess_Click" CauseValidation="false" />
            </div>
        </div>
    </asp:Panel>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
