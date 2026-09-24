<%@ Page Title="Reports & Analytics" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="LibraryManagementSystem.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        @media print {
            #sidebar, .navbar-custom, .nav-tabs, .btn-print-hide, .dataTables_filter, .dataTables_length, .dataTables_paginate {
                display: none !important;
            }
            #content {
                margin: 0 !important;
                padding: 0 !important;
            }
            .card {
                border: none !important;
                box-shadow: none !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4 btn-print-hide">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-indian-rupee-sign text-primary me-2"></i> Reports & Fine Analytics</h4>
            <p class="text-muted small mb-0">Generate comprehensive library inventory, transaction, and financial reports</p>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary" onclick="window.print();">
                <i class="fa-solid fa-print me-1"></i> Print Current Report
            </button>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show btn-print-hide" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Nav Tabs -->
    <ul class="nav nav-tabs mb-4 btn-print-hide" id="reportTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active fw-semibold" id="books-tab" data-bs-toggle="tab" data-bs-target="#books-report" type="button" role="tab"><i class="fa-solid fa-book me-2"></i> Books Inventory</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-semibold" id="students-tab" data-bs-toggle="tab" data-bs-target="#students-report" type="button" role="tab"><i class="fa-solid fa-user-graduate me-2"></i> Students Directory</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-semibold" id="issued-tab" data-bs-toggle="tab" data-bs-target="#issued-report" type="button" role="tab"><i class="fa-solid fa-hand-holding-hand me-2"></i> Issued Books</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-semibold" id="returned-tab" data-bs-toggle="tab" data-bs-target="#returned-report" type="button" role="tab"><i class="fa-solid fa-rotate-left me-2"></i> Returned Books</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-semibold text-danger" id="fines-tab" data-bs-toggle="tab" data-bs-target="#fines-report" type="button" role="tab"><i class="fa-solid fa-indian-rupee-sign me-2"></i> Fine Collections</button>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" id="reportTabsContent">
        <!-- 1. Books Report -->
        <div class="tab-pane fade show active" id="books-report" role="tabpanel">
            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3">Library Books Inventory Report</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvReportBooks" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true" CssClass="table table-bordered table-striped exportable-table w-100">
                        <Columns>
                            <asp:BoundField DataField="ISBN" HeaderText="ISBN" />
                            <asp:BoundField DataField="Title" HeaderText="Book Title" />
                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                            <asp:BoundField DataField="Author" HeaderText="Author" />
                            <asp:BoundField DataField="Publisher" HeaderText="Publisher" />
                            <asp:BoundField DataField="Quantity" HeaderText="Total Stock" />
                            <asp:BoundField DataField="AvailableQuantity" HeaderText="Available" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 2. Students Report -->
        <div class="tab-pane fade" id="students-report" role="tabpanel">
            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3">Registered Student Members Report</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvReportStudents" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true" CssClass="table table-bordered table-striped exportable-table w-100">
                        <Columns>
                            <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />
                            <asp:BoundField DataField="FullName" HeaderText="Student Name" />
                            <asp:BoundField DataField="Course" HeaderText="Course" />
                            <asp:BoundField DataField="Semester" HeaderText="Semester" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:BoundField DataField="MobileNo" HeaderText="Mobile No" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 3. Issued Books Report -->
        <div class="tab-pane fade" id="issued-report" role="tabpanel">
            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3">Currently Issued Books Report</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvReportIssued" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true" CssClass="table table-bordered table-striped exportable-table w-100">
                        <Columns>
                            <asp:BoundField DataField="IssueID" HeaderText="# Issue ID" />
                            <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                            <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />
                            <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            <asp:BoundField DataField="ISBN" HeaderText="ISBN" />
                            <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="Status" HeaderText="Status" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 4. Returned Books Report -->
        <div class="tab-pane fade" id="returned-report" role="tabpanel">
            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3">Returned Books Archive Report</h6>
                <div class="table-responsive">
                    <asp:GridView ID="gvReportReturned" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true" CssClass="table table-bordered table-striped exportable-table w-100">
                        <Columns>
                            <asp:BoundField DataField="IssueID" HeaderText="# Issue ID" />
                            <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                            <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            <asp:BoundField DataField="IssueDate" HeaderText="Issue Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="DueDate" HeaderText="Due Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="FineAmount" HeaderText="Fine (₹)" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Notes" HeaderText="Notes" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- 5. Fine Collections Report -->
        <div class="tab-pane fade" id="fines-report" role="tabpanel">
            <div class="card card-custom p-4">
                <div class="d-flex align-items-center justify-content-between mb-3 btn-print-hide">
                    <h6 class="fw-bold mb-0 text-danger"><i class="fa-solid fa-indian-rupee-sign me-2"></i> Fine Collection Details</h6>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-danger-subtle text-danger fs-6 px-3 py-2">
                            Total Collected Fines: ₹<asp:Literal ID="litReportTotalFines" runat="server">0.00</asp:Literal>
                        </span>
                    </div>
                </div>
                <div class="table-responsive">
                    <asp:GridView ID="gvReportFines" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true" CssClass="table table-bordered table-striped exportable-table w-100">
                        <Columns>
                            <asp:BoundField DataField="IssueID" HeaderText="# Issue ID" />
                            <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                            <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />
                            <asp:BoundField DataField="BookTitle" HeaderText="Book Title" />
                            <asp:BoundField DataField="ReturnDate" HeaderText="Return Date" DataFormatString="{0:dd MMM yyyy}" />
                            <asp:BoundField DataField="FineAmount" HeaderText="Fine Collected (₹)" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Notes" HeaderText="Remarks" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Enable DataTables with Export Buttons (Excel & PDF) on exportable tables
            if (window.jQuery && $.fn.DataTable) {
                $('.exportable-table').DataTable({
                    responsive: true,
                    dom: '<"d-flex justify-content-between align-items-center mb-3"Bf>rt<"d-flex justify-content-between align-items-center mt-3"ip>',
                    buttons: [
                        {
                            extend: 'excelHtml5',
                            text: '<i class="fa-solid fa-file-excel me-1 text-success"></i> Export Excel',
                            className: 'btn btn-sm btn-outline-success me-1'
                        },
                        {
                            extend: 'pdfHtml5',
                            text: '<i class="fa-solid fa-file-pdf me-1 text-danger"></i> Export PDF',
                            className: 'btn btn-sm btn-outline-danger me-1'
                        },
                        {
                            extend: 'print',
                            text: '<i class="fa-solid fa-print me-1"></i> Print Table',
                            className: 'btn btn-sm btn-outline-secondary'
                        }
                    ]
                });
            }
        });
    </script>
</asp:Content>
