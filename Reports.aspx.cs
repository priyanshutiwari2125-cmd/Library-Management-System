using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class Reports : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBooksReport();
                LoadStudentsReport();
                LoadIssuedBooksReport();
                LoadReturnedBooksReport();
                LoadFinesReport();
            }
        }

        private void LoadBooksReport()
        {
            try
            {
                string query = @"SELECT 
                                    b.ISBN, 
                                    b.Title, 
                                    c.CategoryName, 
                                    b.Author, 
                                    b.Publisher, 
                                    b.Quantity, 
                                    b.AvailableQuantity, 
                                    b.Status
                                 FROM dbo.Books b
                                 INNER JOIN dbo.Categories c ON b.CategoryID = c.CategoryID
                                 ORDER BY b.Title";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvReportBooks.DataSource = dt;
                gvReportBooks.DataBind();
                if (gvReportBooks.Rows.Count > 0)
                {
                    gvReportBooks.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading books report: " + ex.Message);
            }
        }

        private void LoadStudentsReport()
        {
            try
            {
                string query = @"SELECT 
                                    EnrollmentNo, 
                                    FullName, 
                                    Course, 
                                    Semester, 
                                    Email, 
                                    MobileNo
                                 FROM dbo.Students
                                 WHERE IsActive = 1
                                 ORDER BY FullName";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvReportStudents.DataSource = dt;
                gvReportStudents.DataBind();
                if (gvReportStudents.Rows.Count > 0)
                {
                    gvReportStudents.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading students report: " + ex.Message);
            }
        }

        private void LoadIssuedBooksReport()
        {
            try
            {
                string query = @"SELECT 
                                    ib.IssueID, 
                                    s.FullName AS StudentName, 
                                    s.EnrollmentNo, 
                                    b.Title AS BookTitle, 
                                    b.ISBN, 
                                    ib.IssueDate, 
                                    ib.DueDate, 
                                    ib.Status
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 WHERE ib.Status IN ('Issued', 'Overdue')
                                 ORDER BY ib.IssueID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvReportIssued.DataSource = dt;
                gvReportIssued.DataBind();
                if (gvReportIssued.Rows.Count > 0)
                {
                    gvReportIssued.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading issued books report: " + ex.Message);
            }
        }

        private void LoadReturnedBooksReport()
        {
            try
            {
                string query = @"SELECT 
                                    ib.IssueID, 
                                    s.FullName AS StudentName, 
                                    b.Title AS BookTitle, 
                                    ib.IssueDate, 
                                    ib.DueDate, 
                                    ib.ReturnDate, 
                                    ib.FineAmount, 
                                    ib.Notes
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 WHERE ib.Status = 'Returned'
                                 ORDER BY ib.IssueID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvReportReturned.DataSource = dt;
                gvReportReturned.DataBind();
                if (gvReportReturned.Rows.Count > 0)
                {
                    gvReportReturned.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading returned books report: " + ex.Message);
            }
        }

        private void LoadFinesReport()
        {
            try
            {
                string query = @"SELECT 
                                    ib.IssueID, 
                                    s.FullName AS StudentName, 
                                    s.EnrollmentNo, 
                                    b.Title AS BookTitle, 
                                    ib.ReturnDate, 
                                    ib.FineAmount, 
                                    ib.Notes
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 WHERE ib.FineAmount > 0
                                 ORDER BY ib.IssueID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvReportFines.DataSource = dt;
                gvReportFines.DataBind();
                if (gvReportFines.Rows.Count > 0)
                {
                    gvReportFines.HeaderRow.TableSection = TableRowSection.TableHeader;
                }

                string sumQuery = "SELECT ISNULL(SUM(FineAmount), 0.00) FROM dbo.IssueBooks WHERE FineAmount > 0";
                object totalFines = DbHelper.ExecuteScalar(sumQuery);
                litReportTotalFines.Text = Convert.ToDecimal(totalFines).ToString("N2");
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading fine report: " + ex.Message);
            }
        }

        private void ShowAlert(string message)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.Visible = true;
        }
    }
}
