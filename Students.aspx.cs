using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class Students : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudentsList();

                string status = Request.QueryString["status"];
                if (status == "added")
                {
                    ShowAlert("Student registered successfully!", "success");
                }
                else if (status == "updated")
                {
                    ShowAlert("Student details updated successfully!", "success");
                }
            }
        }

        private void LoadStudentsList()
        {
            try
            {
                string query = @"SELECT 
                                    StudentID, 
                                    EnrollmentNo, 
                                    FullName, 
                                    Course, 
                                    Semester, 
                                    Email, 
                                    MobileNo, 
                                    Address, 
                                    Photo, 
                                    IsActive, 
                                    CreatedDate
                                 FROM dbo.Students 
                                 WHERE IsActive = 1
                                 ORDER BY StudentID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query);
                gvStudents.DataSource = dt;
                gvStudents.DataBind();
                if (gvStudents.Rows.Count > 0)
                {
                    gvStudents.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading students: " + ex.Message, "danger");
            }
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteStudent")
            {
                int studentId = Convert.ToInt32(e.CommandArgument);
                DeleteStudentRecord(studentId);
            }
        }

        protected void gvStudents_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // GridView RowDeleting requirement
        }

        private void DeleteStudentRecord(int studentId)
        {
            try
            {
                // Check active issues
                string checkQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE StudentID = @StudentID AND Status IN ('Issued', 'Overdue')";
                object activeCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });

                if (activeCount != null && Convert.ToInt32(activeCount) > 0)
                {
                    ShowAlert("Cannot delete student: This student has unreturned books. Return all books first.", "warning");
                    return;
                }

                // Delete photo file if exists
                string getPhotoQuery = "SELECT Photo FROM dbo.Students WHERE StudentID = @StudentID";
                object photoObj = DbHelper.ExecuteScalar(getPhotoQuery, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });
                if (photoObj != null && !string.IsNullOrEmpty(photoObj.ToString()))
                {
                    string filePath = Server.MapPath("~/Uploads/Students/" + photoObj.ToString());
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                // Delete record
                string deleteQuery = "DELETE FROM dbo.Students WHERE StudentID = @StudentID";
                DbHelper.ExecuteNonQuery(deleteQuery, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });

                ShowAlert("Student record deleted successfully.", "success");
                LoadStudentsList();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting student: " + ex.Message, "danger");
            }
        }

        protected int GetActiveIssuesCount(object studentIdObj)
        {
            try
            {
                int studentId = Convert.ToInt32(studentIdObj);
                string query = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE StudentID = @StudentID AND Status IN ('Issued', 'Overdue')";
                object count = DbHelper.ExecuteScalar(query, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });
                return count != null ? Convert.ToInt32(count) : 0;
            }
            catch
            {
                return 0;
            }
        }

        protected string GetStudentPhotoUrl(object photoObj)
        {
            string fileName = photoObj != null ? photoObj.ToString() : "";
            if (!string.IsNullOrEmpty(fileName) && File.Exists(Server.MapPath("~/Uploads/Students/" + fileName)))
            {
                return ResolveUrl("~/Uploads/Students/" + fileName);
            }
            return "https://via.placeholder.com/80x80/4f46e5/ffffff?text=User";
        }

        private void ShowAlert(string message, string alertType)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.CssClass = "alert alert-" + alertType + " alert-dismissible fade show";
            pnlAlert.Visible = true;
        }
    }
}
