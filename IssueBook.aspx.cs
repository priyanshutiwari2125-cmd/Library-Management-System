using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class IssueBook : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtIssueDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtDueDate.Text = DateTime.Now.AddDays(14).ToString("yyyy-MM-dd");

                LoadStudentsDropdown();
                LoadBooksDropdown();
            }
        }

        private void LoadStudentsDropdown()
        {
            try
            {
                string query = "SELECT StudentID, EnrollmentNo + ' - ' + FullName AS StudentLabel FROM dbo.Students WHERE IsActive = 1 ORDER BY FullName";
                DataTable dt = DbHelper.ExecuteDataTable(query);

                ddlStudent.DataSource = dt;
                ddlStudent.DataTextField = "StudentLabel";
                ddlStudent.DataValueField = "StudentID";
                ddlStudent.DataBind();

                ddlStudent.Items.Insert(0, new ListItem("-- Select Student --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading students: " + ex.Message, "danger");
            }
        }

        private void LoadBooksDropdown()
        {
            try
            {
                string query = @"SELECT BookID, Title + ' (Available: ' + CAST(AvailableQuantity AS NVARCHAR) + ')' AS BookLabel 
                                 FROM dbo.Books 
                                 WHERE AvailableQuantity > 0 
                                 ORDER BY Title";

                DataTable dt = DbHelper.ExecuteDataTable(query);

                ddlBook.DataSource = dt;
                ddlBook.DataTextField = "BookLabel";
                ddlBook.DataValueField = "BookID";
                ddlBook.DataBind();

                ddlBook.Items.Insert(0, new ListItem("-- Select Book --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading books: " + ex.Message, "danger");
            }
        }

        protected void ddlStudent_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlStudent.SelectedValue))
            {
                int studentId = Convert.ToInt32(ddlStudent.SelectedValue);
                LoadStudentPreview(studentId);
            }
            else
            {
                ResetStudentPreview();
            }
        }

        private void LoadStudentPreview(int studentId)
        {
            try
            {
                string query = "SELECT * FROM dbo.Students WHERE StudentID = @StudentID";
                DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litStudentName.Text = row["FullName"].ToString();
                    litStudentEnrollment.Text = "Enrollment: " + row["EnrollmentNo"].ToString();
                    litStudentCourse.Text = row["Course"].ToString();
                    litStudentSemester.Text = row["Semester"].ToString();
                    litStudentMobile.Text = row["MobileNo"].ToString();

                    string photo = row["Photo"].ToString();
                    if (!string.IsNullOrEmpty(photo) && File.Exists(Server.MapPath("~/Uploads/Students/" + photo)))
                    {
                        imgStudentPreview.ImageUrl = "~/Uploads/Students/" + photo;
                    }
                    else
                    {
                        imgStudentPreview.ImageUrl = "https://via.placeholder.com/80x80/4f46e5/ffffff?text=User";
                    }

                    // Get active issue count
                    string countQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE StudentID = @StudentID AND Status IN ('Issued', 'Overdue')";
                    object count = DbHelper.ExecuteScalar(countQuery, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });
                    litStudentActiveCount.Text = count != null ? count.ToString() : "0";
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading student details: " + ex.Message, "danger");
            }
        }

        private void ResetStudentPreview()
        {
            litStudentName.Text = "Select a Student";
            litStudentEnrollment.Text = "No student selected";
            litStudentCourse.Text = "-";
            litStudentSemester.Text = "-";
            litStudentMobile.Text = "-";
            litStudentActiveCount.Text = "0";
            imgStudentPreview.ImageUrl = "https://via.placeholder.com/80x80/4f46e5/ffffff?text=User";
        }

        protected void ddlBook_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlBook.SelectedValue))
            {
                int bookId = Convert.ToInt32(ddlBook.SelectedValue);
                LoadBookPreview(bookId);
            }
            else
            {
                ResetBookPreview();
            }
        }

        private void LoadBookPreview(int bookId)
        {
            try
            {
                string query = @"SELECT b.*, c.CategoryName 
                                 FROM dbo.Books b 
                                 INNER JOIN dbo.Categories c ON b.CategoryID = c.CategoryID 
                                 WHERE b.BookID = @BookID";

                DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter[] { new SqlParameter("@BookID", bookId) });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litBookTitle.Text = row["Title"].ToString();
                    litBookISBN.Text = row["ISBN"].ToString();
                    litBookAuthor.Text = row["Author"].ToString();
                    litBookCategory.Text = row["CategoryName"].ToString();

                    int availQty = Convert.ToInt32(row["AvailableQuantity"]);
                    lblStockStatus.Text = availQty > 0 ? "In Stock (" + availQty + " Available)" : "Out of Stock";
                    lblStockStatus.CssClass = availQty > 0 ? "badge badge-status-available" : "badge badge-status-overdue";

                    string coverImg = row["CoverImage"].ToString();
                    if (!string.IsNullOrEmpty(coverImg) && File.Exists(Server.MapPath("~/Uploads/Books/" + coverImg)))
                    {
                        imgBookPreview.ImageUrl = "~/Uploads/Books/" + coverImg;
                    }
                    else
                    {
                        imgBookPreview.ImageUrl = "https://via.placeholder.com/120x160/4f46e5/ffffff?text=Book";
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading book details: " + ex.Message, "danger");
            }
        }

        private void ResetBookPreview()
        {
            litBookTitle.Text = "Select a Book";
            litBookISBN.Text = "No book selected";
            litBookAuthor.Text = "-";
            litBookCategory.Text = "-";
            lblStockStatus.Text = "Select Book";
            lblStockStatus.CssClass = "badge badge-status-available";
            imgBookPreview.ImageUrl = "https://via.placeholder.com/120x160/4f46e5/ffffff?text=Book";
        }

        protected void btnConfirmIssue_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlStudent.SelectedValue) || string.IsNullOrEmpty(ddlBook.SelectedValue))
            {
                ShowAlert("Please select both a student and a book.", "danger");
                return;
            }

            int studentId = Convert.ToInt32(ddlStudent.SelectedValue);
            int bookId = Convert.ToInt32(ddlBook.SelectedValue);

            DateTime issueDate = Convert.ToDateTime(txtIssueDate.Text);
            DateTime dueDate = Convert.ToDateTime(txtDueDate.Text);
            string notes = txtNotes.Text.Trim();

            if (dueDate <= issueDate)
            {
                ShowAlert("Due date must be after the issue date.", "warning");
                return;
            }

            try
            {
                // 1. Check stock availability
                string stockQuery = "SELECT AvailableQuantity FROM dbo.Books WHERE BookID = @BookID";
                object availObj = DbHelper.ExecuteScalar(stockQuery, new SqlParameter[] { new SqlParameter("@BookID", bookId) });

                if (availObj == null || Convert.ToInt32(availObj) <= 0)
                {
                    ShowAlert("Selected book is currently Out of Stock.", "danger");
                    return;
                }

                // 2. Check if student has already issued the exact same book and hasn't returned it
                string checkDuplicateQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE StudentID = @StudentID AND BookID = @BookID AND Status IN ('Issued', 'Overdue')";
                object dupCount = DbHelper.ExecuteScalar(checkDuplicateQuery, new SqlParameter[] { 
                    new SqlParameter("@StudentID", studentId),
                    new SqlParameter("@BookID", bookId)
                });

                if (dupCount != null && Convert.ToInt32(dupCount) > 0)
                {
                    ShowAlert("This student already has an active issue record for this book.", "warning");
                    return;
                }

                // 3. ADO.NET Transaction Execution
                using (SqlConnection conn = DbHelper.GetConnection())
                {
                    conn.Open();
                    SqlTransaction trans = conn.BeginTransaction();

                    try
                    {
                        // Insert Issue Record
                        string insertQuery = @"INSERT INTO dbo.IssueBooks (StudentID, BookID, IssueDate, DueDate, Status, Notes, FineAmount)
                                               VALUES (@StudentID, @BookID, @IssueDate, @DueDate, 'Issued', @Notes, 0.00)";

                        SqlCommand cmdInsert = new SqlCommand(insertQuery, conn, trans);
                        cmdInsert.Parameters.AddWithValue("@StudentID", studentId);
                        cmdInsert.Parameters.AddWithValue("@BookID", bookId);
                        cmdInsert.Parameters.AddWithValue("@IssueDate", issueDate);
                        cmdInsert.Parameters.AddWithValue("@DueDate", dueDate);
                        cmdInsert.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes);
                        cmdInsert.ExecuteNonQuery();

                        // Decrement Book Stock
                        string updateStockQuery = @"UPDATE dbo.Books 
                                                    SET AvailableQuantity = AvailableQuantity - 1,
                                                        Status = CASE WHEN (AvailableQuantity - 1) <= 0 THEN 'Out of Stock' ELSE 'Available' END
                                                    WHERE BookID = @BookID";

                        SqlCommand cmdUpdate = new SqlCommand(updateStockQuery, conn, trans);
                        cmdUpdate.Parameters.AddWithValue("@BookID", bookId);
                        cmdUpdate.ExecuteNonQuery();

                        trans.Commit();

                        ShowAlert("Book issued successfully to student!", "success");
                        
                        // Reset selections
                        ddlStudent.SelectedIndex = 0;
                        ddlBook.SelectedIndex = 0;
                        ResetStudentPreview();
                        ResetBookPreview();
                        LoadBooksDropdown(); // Refresh available books dropdown list
                    }
                    catch (Exception exTrans)
                    {
                        trans.Rollback();
                        ShowAlert("Transaction failed: " + exTrans.Message, "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error processing issue: " + ex.Message, "danger");
            }
        }

        private void ShowAlert(string message, string alertType)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.CssClass = "alert alert-" + alertType + " alert-dismissible fade show";
            pnlAlert.Visible = true;
        }
    }
}
