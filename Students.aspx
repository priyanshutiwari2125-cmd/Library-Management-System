<%@ Page Title="Student Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="LibraryManagementSystem.Students" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-user-graduate text-success me-2"></i> Student Directory</h4>
            <p class="text-muted small mb-0">Manage registered student library members and contact records</p>
        </div>
        <div>
            <a href="AddStudent.aspx" class="btn btn-primary-custom">
                <i class="fa-solid fa-user-plus me-1"></i> Register New Student
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Students Data Table -->
    <div class="card card-custom p-4">
        <div class="table-responsive">
            <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true"
                CssClass="table table-hover align-middle datatable w-100" DataKeyNames="StudentID" 
                OnRowCommand="gvStudents_RowCommand" OnRowDeleting="gvStudents_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="Photo">
                        <ItemTemplate>
                            <img src='<%# GetStudentPhotoUrl(Eval("Photo")) %>' alt="Student Photo" class="student-avatar-thumb" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />

                    <asp:TemplateField HeaderText="Student Name">
                        <ItemTemplate>
                            <div class="fw-bold text-dark"><%# Eval("FullName") %></div>
                            <small class="text-muted"><%# Eval("Email") %></small>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Course" HeaderText="Course" />
                    <asp:BoundField DataField="Semester" HeaderText="Semester" />
                    <asp:BoundField DataField="MobileNo" HeaderText="Mobile No" />

                    <asp:TemplateField HeaderText="Active Issues">
                        <ItemTemplate>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-1">
                                <%# GetActiveIssuesCount(Eval("StudentID")) %> Books
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end">
                        <ItemTemplate>
                            <a href='<%# "EditStudent.aspx?id=" + Eval("StudentID") %>' class="btn btn-sm btn-outline-primary me-1" title="Edit Student">
                                <i class="fa-solid fa-user-pen"></i>
                            </a>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteStudent" CommandArgument='<%# Eval("StudentID") %>' 
                                CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Are you sure you want to delete this student record?');" title="Delete Student">
                                <i class="fa-solid fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center py-4 text-muted">
                        <i class="fa-solid fa-users-slash fs-2 mb-2 d-block text-secondary"></i>
                        No registered students found. Click <strong>Register New Student</strong> to add one.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
