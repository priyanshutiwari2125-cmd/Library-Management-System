<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LibraryManagementSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Header Title -->
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1">Library Overview & Analytics</h4>
            <p class="text-muted small mb-0">Welcome back, <asp:Literal ID="litAdminNameHeader" runat="server">Administrator</asp:Literal>! Here is what's happening today.</p>
        </div>
        <div>
            <a href="IssueBook.aspx" class="btn btn-primary-custom">
                <i class="fa-solid fa-plus me-1"></i> Quick Issue Book
            </a>
        </div>
    </div>

    <!-- Metric Cards Grid -->
    <div class="row g-4 mb-4">
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card bg-grad-primary">
                <div class="stat-icon"><i class="fa-solid fa-book"></i></div>
                <div class="small text-white-50 text-uppercase fw-bold tracking-wider mb-1">Total Books</div>
                <div class="fs-2 fw-extrabold mb-1"><asp:Literal ID="litTotalBooks" runat="server">0</asp:Literal></div>
                <div class="small"><i class="fa-solid fa-box-archive me-1"></i> Stock Available: <strong class="text-white"><asp:Literal ID="litAvailableBooks" runat="server">0</asp:Literal></strong></div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card bg-grad-success">
                <div class="stat-icon"><i class="fa-solid fa-user-graduate"></i></div>
                <div class="small text-white-50 text-uppercase fw-bold tracking-wider mb-1">Registered Students</div>
                <div class="fs-2 fw-extrabold mb-1"><asp:Literal ID="litTotalStudents" runat="server">0</asp:Literal></div>
                <div class="small"><i class="fa-solid fa-circle-check me-1"></i> Active Borrowers</div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card bg-grad-warning">
                <div class="stat-icon"><i class="fa-solid fa-hand-holding-hand"></i></div>
                <div class="small text-white-50 text-uppercase fw-bold tracking-wider mb-1">Currently Issued</div>
                <div class="fs-2 fw-extrabold mb-1"><asp:Literal ID="litTotalIssued" runat="server">0</asp:Literal></div>
                <div class="small"><i class="fa-solid fa-clock-history me-1"></i> Overdue Count: <strong class="text-white"><asp:Literal ID="litTotalOverdue" runat="server">0</asp:Literal></strong></div>
            </div>
        </div>

        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card bg-grad-info">
                <div class="stat-icon"><i class="fa-solid fa-rotate-left"></i></div>
                <div class="small text-white-50 text-uppercase fw-bold tracking-wider mb-1">Returned Books</div>
                <div class="fs-2 fw-extrabold mb-1"><asp:Literal ID="litTotalReturned" runat="server">0</asp:Literal></div>
                <div class="small"><i class="fa-solid fa-indian-rupee-sign me-1"></i> Total Fines: <strong class="text-white">₹<asp:Literal ID="litTotalFines" runat="server">0.00</asp:Literal></strong></div>
            </div>
        </div>
    </div>

    <!-- Quick Action Cards Grid -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <a href="AddBook.aspx" class="card card-custom h-100 text-decoration-none text-dark p-3 text-center d-block">
                <div class="avatar-circle mx-auto mb-2 text-primary bg-primary-subtle rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                    <i class="fa-solid fa-book-medical fs-4"></i>
                </div>
                <h6 class="fw-bold mb-1">Add New Book</h6>
                <small class="text-muted">Register book inventory</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="AddStudent.aspx" class="card card-custom h-100 text-decoration-none text-dark p-3 text-center d-block">
                <div class="avatar-circle mx-auto mb-2 text-success bg-success-subtle rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                    <i class="fa-solid fa-user-plus fs-4"></i>
                </div>
                <h6 class="fw-bold mb-1">Add Student</h6>
                <small class="text-muted">Enroll new member</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="IssueBook.aspx" class="card card-custom h-100 text-decoration-none text-dark p-3 text-center d-block">
                <div class="avatar-circle mx-auto mb-2 text-warning bg-warning-subtle rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                    <i class="fa-solid fa-handshake fs-4"></i>
                </div>
                <h6 class="fw-bold mb-1">Issue Book</h6>
                <small class="text-muted">Lend book to student</small>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="ReturnBook.aspx" class="card card-custom h-100 text-decoration-none text-dark p-3 text-center d-block">
                <div class="avatar-circle mx-auto mb-2 text-info bg-info-subtle rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                    <i class="fa-solid fa-box-check fs-4"></i>
                </div>
                <h6 class="fw-bold mb-1">Return Book</h6>
                <small class="text-muted">Receive returned book</small>
            </a>
        </div>
    </div>

    <!-- Charts & Analytics Row -->
    <div class="row g-4 mb-4">
        <div class="col-12 col-lg-8">
            <div class="card card-custom p-4 h-100">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h6 class="fw-bold mb-0"><i class="fa-solid fa-chart-line text-primary me-2"></i> Monthly Issue & Return Activity</h6>
                    <span class="badge bg-light text-dark border">Real-time Data</span>
                </div>
                <div style="height: 280px; position: relative;">
                    <canvas id="issueTrendChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-12 col-lg-4">
            <div class="card card-custom p-4 h-100">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <h6 class="fw-bold mb-0"><i class="fa-solid fa-chart-pie text-success me-2"></i> Books Category Distribution</h6>
                </div>
                <div style="height: 280px; position: relative;" class="d-flex align-items-center justify-content-center">
                    <canvas id="categoryPieChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Recently Issued Books Table -->
    <div class="card card-custom p-4">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div>
                <h6 class="fw-bold mb-1"><i class="fa-solid fa-clock-rotate-left me-2 text-warning"></i> Recently Issued Books</h6>
                <small class="text-muted">Latest transactions processed in the system</small>
            </div>
            <a href="Reports.aspx" class="btn btn-sm btn-outline-secondary">View All Activity</a>
        </div>

        <div class="table-responsive">
            <asp:Repeater ID="rptRecentIssues" runat="server">
                <HeaderTemplate>
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th># Issue ID</th>
                                <th>Student Name</th>
                                <th>Enrollment No</th>
                                <th>Book Title</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="fw-semibold">#<%# Eval("IssueID") %></td>
                        <td>
                            <div class="fw-bold"><%# Eval("StudentName") %></div>
                            <small class="text-muted"><%# Eval("Course") %></small>
                        </td>
                        <td><span class="badge bg-light text-dark border"><%# Eval("EnrollmentNo") %></span></td>
                        <td><%# Eval("BookTitle") %></td>
                        <td><%# Convert.ToDateTime(Eval("IssueDate")).ToString("dd MMM yyyy") %></td>
                        <td><%# Convert.ToDateTime(Eval("DueDate")).ToString("dd MMM yyyy") %></td>
                        <td>
                            <span class='<%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoRecent" runat="server" Visible="false" CssClass="text-center py-4 text-muted">
                <i class="fa-solid fa-inbox fs-2 mb-2 d-block"></i> No recent book issue records found.
            </asp:Panel>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Render Issue Trend Chart
            const ctxTrend = document.getElementById('issueTrendChart');
            if (ctxTrend) {
                new Chart(ctxTrend, {
                    type: 'bar',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                        datasets: [
                            {
                                label: 'Issued Books',
                                data: [12, 19, 15, 25, 22, 30, <asp:Literal ID="litChartIssuedCount" runat="server">14</asp:Literal>],
                                backgroundColor: 'rgba(79, 70, 229, 0.85)',
                                borderRadius: 6
                            },
                            {
                                label: 'Returned Books',
                                data: [8, 14, 12, 20, 18, 24, <asp:Literal ID="litChartReturnedCount" runat="server">10</asp:Literal>],
                                backgroundColor: 'rgba(16, 185, 129, 0.85)',
                                borderRadius: 6
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'top' }
                        },
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                });
            }

            // Render Category Pie Chart
            const ctxCategory = document.getElementById('categoryPieChart');
            if (ctxCategory) {
                new Chart(ctxCategory, {
                    type: 'doughnut',
                    data: {
                        labels: [<asp:Literal ID="litCategoryLabels" runat="server">'CS', 'IT', 'ECE', 'Mechanical', 'Management'</asp:Literal>],
                        datasets: [{
                            data: [<asp:Literal ID="litCategoryData" runat="server">5, 3, 2, 4, 1</asp:Literal>],
                            backgroundColor: [
                                '#4f46e5', '#10b981', '#f59e0b', '#06b6d4', '#ec4899', '#8b5cf6'
                            ],
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>
