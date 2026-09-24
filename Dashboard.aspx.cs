using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class Dashboard : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["FullName"] != null)
                {
                    litAdminNameHeader.Text = Server.HtmlEncode(Session["FullName"].ToString());
                }

                LoadDashboardMetrics();
                LoadRecentIssues();
                LoadCategoryChartData();
            }
        }

        private void LoadDashboardMetrics()
        {
            try
            {
                // Total Books and Available Quantity
                string bookQuery = "SELECT ISNULL(SUM(Quantity), 0) AS TotalQty, ISNULL(SUM(AvailableQuantity), 0) AS AvailQty FROM dbo.Books";
                DataTable dtBooks = DbHelper.ExecuteDataTable(bookQuery);
                if (dtBooks.Rows.Count > 0)
                {
                    litTotalBooks.Text = dtBooks.Rows[0]["TotalQty"].ToString();
                    litAvailableBooks.Text = dtBooks.Rows[0]["AvailQty"].ToString();
                }

                // Total Registered Active Students
                string studentQuery = "SELECT COUNT(*) FROM dbo.Students WHERE IsActive = 1";
                object totalStudents = DbHelper.ExecuteScalar(studentQuery);
                litTotalStudents.Text = totalStudents != null ? totalStudents.ToString() : "0";

                // Issued & Overdue Books Count
                string issueQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE Status = 'Issued' OR Status = 'Overdue'";
                object totalIssued = DbHelper.ExecuteScalar(issueQuery);
                litTotalIssued.Text = totalIssued != null ? totalIssued.ToString() : "0";

                string overdueQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE Status = 'Overdue' OR (Status = 'Issued' AND DueDate < GETDATE())";
                object totalOverdue = DbHelper.ExecuteScalar(overdueQuery);
                litTotalOverdue.Text = totalOverdue != null ? totalOverdue.ToString() : "0";

                // Returned Books & Total Fines
                string returnQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE Status = 'Returned'";
                object totalReturned = DbHelper.ExecuteScalar(returnQuery);
                litTotalReturned.Text = totalReturned != null ? totalReturned.ToString() : "0";

                string fineQuery = "SELECT ISNULL(SUM(FineAmount), 0.00) FROM dbo.IssueBooks";
                object totalFines = DbHelper.ExecuteScalar(fineQuery);
                litTotalFines.Text = Convert.ToDecimal(totalFines).ToString("N2");

                litChartIssuedCount.Text = totalIssued != null ? totalIssued.ToString() : "5";
                litChartReturnedCount.Text = totalReturned != null ? totalReturned.ToString() : "3";
            }
            catch (Exception)
            {
                // Set safe default fallbacks if database tables are empty
                litTotalBooks.Text = "0";
                litAvailableBooks.Text = "0";
                litTotalStudents.Text = "0";
                litTotalIssued.Text = "0";
                litTotalOverdue.Text = "0";
                litTotalReturned.Text = "0";
                litTotalFines.Text = "0.00";
            }
        }

        private void LoadRecentIssues()
        {
            try
            {
                string query = @"SELECT TOP 5 
                                    ib.IssueID, 
                                    s.FullName AS StudentName, 
                                    s.EnrollmentNo, 
                                    s.Course, 
                                    b.Title AS BookTitle, 
                                    ib.IssueDate, 
                                    ib.DueDate, 
                                    ib.Status
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 ORDER BY ib.IssueID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    rptRecentIssues.DataSource = dt;
                    rptRecentIssues.DataBind();
                    pnlNoRecent.Visible = false;
                }
                else
                {
                    pnlNoRecent.Visible = true;
                }
            }
            catch (Exception)
            {
                pnlNoRecent.Visible = true;
            }
        }

        private void LoadCategoryChartData()
        {
            try
            {
                string query = @"SELECT c.CategoryName, COUNT(b.BookID) AS BookCount 
                                 FROM dbo.Categories c
                                 LEFT JOIN dbo.Books b ON c.CategoryID = b.CategoryID
                                 GROUP BY c.CategoryName";

                DataTable dt = DbHelper.ExecuteDataTable(query);

                if (dt != null && dt.Rows.Count > 0)
                {
                    StringBuilder sbLabels = new StringBuilder();
                    StringBuilder sbData = new StringBuilder();

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        string catName = dt.Rows[i]["CategoryName"].ToString();
                        int count = Convert.ToInt32(dt.Rows[i]["BookCount"]);

                        sbLabels.Append("'" + catName + "'");
                        sbData.Append(count);

                        if (i < dt.Rows.Count - 1)
                        {
                            sbLabels.Append(", ");
                            sbData.Append(", ");
                        }
                    }

                    litCategoryLabels.Text = sbLabels.ToString();
                    litCategoryData.Text = sbData.ToString();
                }
            }
            catch (Exception)
            {
                // Defaults
            }
        }

        protected string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "Issued":
                    return "badge-status-issued";
                case "Overdue":
                    return "badge-status-overdue";
                case "Returned":
                    return "badge-status-returned";
                default:
                    return "badge-status-available";
            }
        }
    }
}
