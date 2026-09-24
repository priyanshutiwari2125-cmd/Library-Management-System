using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class ReturnBook : BasePage
    {
        private const decimal FINE_RATE_PER_DAY = 2.00m; // 2.00 fine per overdue day

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadActiveIssues();
            }
        }

        private void LoadActiveIssues()
        {
            try
            {
                string query = @"SELECT 
                                    ib.IssueID, 
                                    ib.StudentID, 
                                    s.FullName AS StudentName, 
                                    s.EnrollmentNo, 
                                    s.Course, 
                                    ib.BookID, 
                                    b.Title AS BookTitle, 
                                    b.ISBN, 
                                    ib.IssueDate, 
                                    ib.DueDate, 
                                    CASE 
                                        WHEN DATEDIFF(DAY, ib.DueDate, GETDATE()) > 0 THEN DATEDIFF(DAY, ib.DueDate, GETDATE()) 
                                        ELSE 0 
                                    END AS DaysOverdue
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 WHERE ib.Status IN ('Issued', 'Overdue')
                                 ORDER BY ib.IssueID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvActiveIssues.DataSource = dt;
                gvActiveIssues.DataBind();
                if (gvActiveIssues.Rows.Count > 0)
                {
                    gvActiveIssues.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading active issues: " + ex.Message, "danger");
            }
        }

        protected void gvActiveIssues_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SelectReturn")
            {
                int issueId = Convert.ToInt32(e.CommandArgument);
                LoadIssueForReturn(issueId);
            }
        }

        private void LoadIssueForReturn(int issueId)
        {
            try
            {
                string query = @"SELECT 
                                    ib.IssueID, 
                                    ib.StudentID, 
                                    s.FullName AS StudentName, 
                                    s.EnrollmentNo, 
                                    ib.BookID, 
                                    b.Title AS BookTitle, 
                                    b.ISBN, 
                                    ib.IssueDate, 
                                    ib.DueDate
                                 FROM dbo.IssueBooks ib
                                 INNER JOIN dbo.Students s ON ib.StudentID = s.StudentID
                                 INNER JOIN dbo.Books b ON ib.BookID = b.BookID
                                 WHERE ib.IssueID = @IssueID";

                DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter[] { new SqlParameter("@IssueID", issueId) });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hfSelectedIssueID.Value = row["IssueID"].ToString();
                    hfSelectedBookID.Value = row["BookID"].ToString();

                    litRetStudentName.Text = row["StudentName"].ToString();
                    litRetEnrollment.Text = "Enrollment: " + row["EnrollmentNo"].ToString();
                    litRetBookTitle.Text = row["BookTitle"].ToString();
                    litRetISBN.Text = row["ISBN"].ToString();

                    DateTime issueDate = Convert.ToDateTime(row["IssueDate"]);
                    DateTime dueDate = Convert.ToDateTime(row["DueDate"]);
                    DateTime today = DateTime.Today;

                    txtRetIssueDate.Text = issueDate.ToString("yyyy-MM-dd");
                    txtRetDueDate.Text = dueDate.ToString("yyyy-MM-dd");

                    int lateDays = 0;
                    if (today > dueDate)
                    {
                        lateDays = (today - dueDate.Date).Days;
                    }

                    txtLateDays.Text = lateDays.ToString();
                    decimal fineAmount = lateDays * FINE_RATE_PER_DAY;
                    txtFineAmount.Text = fineAmount.ToString("F2");

                    txtReturnNotes.Text = lateDays > 0 ? "Returned " + lateDays + " days overdue." : "Returned on time.";

                    pnlReturnProcess.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading issue details: " + ex.Message, "danger");
            }
        }

        protected void btnConfirmReturnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfSelectedIssueID.Value) || string.IsNullOrEmpty(hfSelectedBookID.Value))
            {
                ShowAlert("Invalid selection for return processing.", "danger");
                return;
            }

            int issueId = Convert.ToInt32(hfSelectedIssueID.Value);
            int bookId = Convert.ToInt32(hfSelectedBookID.Value);

            decimal fineAmount = 0.00m;
            decimal.TryParse(txtFineAmount.Text.Trim(), out fineAmount);

            string notes = txtReturnNotes.Text.Trim();

            try
            {
                // ADO.NET Transaction Execution for Return
                using (SqlConnection conn = DbHelper.GetConnection())
                {
                    conn.Open();
                    SqlTransaction trans = conn.BeginTransaction();

                    try
                    {
                        // 1. Update IssueBooks Record
                        string updateIssueQuery = @"UPDATE dbo.IssueBooks 
                                                    SET ReturnDate = GETDATE(), 
                                                        FineAmount = @FineAmount, 
                                                        Status = 'Returned', 
                                                        Notes = @Notes 
                                                    WHERE IssueID = @IssueID";

                        SqlCommand cmdIssue = new SqlCommand(updateIssueQuery, conn, trans);
                        cmdIssue.Parameters.AddWithValue("@FineAmount", fineAmount);
                        cmdIssue.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes);
                        cmdIssue.Parameters.AddWithValue("@IssueID", issueId);
                        cmdIssue.ExecuteNonQuery();

                        // 2. Increment Book Available Stock & Restore Status
                        string updateBookQuery = @"UPDATE dbo.Books 
                                                   SET AvailableQuantity = AvailableQuantity + 1, 
                                                       Status = 'Available' 
                                                   WHERE BookID = @BookID";

                        SqlCommand cmdBook = new SqlCommand(updateBookQuery, conn, trans);
                        cmdBook.Parameters.AddWithValue("@BookID", bookId);
                        cmdBook.ExecuteNonQuery();

                        trans.Commit();

                        ShowAlert("Book returned successfully! Stock quantity restored.", "success");
                        pnlReturnProcess.Visible = false;
                        LoadActiveIssues(); // Refresh list
                    }
                    catch (Exception exTrans)
                    {
                        trans.Rollback();
                        ShowAlert("Return transaction failed: " + exTrans.Message, "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error processing return: " + ex.Message, "danger");
            }
        }

        protected void btnCancelProcess_Click(object sender, EventArgs e)
        {
            pnlReturnProcess.Visible = false;
        }

        private void ShowAlert(string message, string alertType)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.CssClass = "alert alert-" + alertType + " alert-dismissible fade show";
            pnlAlert.Visible = true;
        }
    }
}
