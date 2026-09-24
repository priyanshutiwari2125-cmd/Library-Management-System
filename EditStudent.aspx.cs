using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class EditStudent : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string idStr = Request.QueryString["id"];
                int studentId = 0;
                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out studentId))
                {
                    hfStudentID.Value = studentId.ToString();
                    LoadStudentDetails(studentId);
                }
                else
                {
                    Response.Redirect("~/Students.aspx");
                }
            }
        }

        private void LoadStudentDetails(int studentId)
        {
            try
            {
                string query = "SELECT * FROM dbo.Students WHERE StudentID = @StudentID";
                DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    txtEnrollmentNo.Text = row["EnrollmentNo"].ToString();
                    txtFullName.Text = row["FullName"].ToString();
                    ddlCourse.SelectedValue = row["Course"].ToString();
                    ddlSemester.SelectedValue = row["Semester"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                    txtMobileNo.Text = row["MobileNo"].ToString();
                    txtAddress.Text = row["Address"].ToString();

                    string photo = row["Photo"].ToString();
                    if (!string.IsNullOrEmpty(photo) && File.Exists(Server.MapPath("~/Uploads/Students/" + photo)))
                    {
                        imgCurrentPhoto.ImageUrl = "~/Uploads/Students/" + photo;
                    }
                    else
                    {
                        imgCurrentPhoto.ImageUrl = "https://via.placeholder.com/150x150/4f46e5/ffffff?text=User";
                    }
                }
                else
                {
                    Response.Redirect("~/Students.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading student details: " + ex.Message, "danger");
            }
        }

        protected void btnUpdateStudent_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(hfStudentID.Value);
            string enrollmentNo = txtEnrollmentNo.Text.Trim();
            string fullName = txtFullName.Text.Trim();
            string course = ddlCourse.SelectedValue;
            string semester = ddlSemester.SelectedValue;
            string email = txtEmail.Text.Trim();
            string mobileNo = txtMobileNo.Text.Trim();
            if (!mobileNo.StartsWith("+"))
            {
                mobileNo = "+91 " + mobileNo;
            }
            string address = txtAddress.Text.Trim();

            if (string.IsNullOrEmpty(enrollmentNo) || string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(course) || 
                string.IsNullOrEmpty(semester) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mobileNo))
            {
                ShowAlert("Please fill in all mandatory fields marked with *", "danger");
                return;
            }

            try
            {
                // Duplicate Enrollment Check excluding current student
                string checkQuery = "SELECT COUNT(*) FROM dbo.Students WHERE EnrollmentNo = @EnrollmentNo AND StudentID <> @StudentID";
                object existingCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { 
                    new SqlParameter("@EnrollmentNo", enrollmentNo),
                    new SqlParameter("@StudentID", studentId)
                });
                if (existingCount != null && Convert.ToInt32(existingCount) > 0)
                {
                    ShowAlert("Another student with Enrollment No '" + enrollmentNo + "' is already registered.", "danger");
                    return;
                }

                // Get Old Photo
                string getPhotoQuery = "SELECT Photo FROM dbo.Students WHERE StudentID = @StudentID";
                object oldPhotoObj = DbHelper.ExecuteScalar(getPhotoQuery, new SqlParameter[] { new SqlParameter("@StudentID", studentId) });
                string oldPhoto = oldPhotoObj != null ? oldPhotoObj.ToString() : "";

                string photoFileName = oldPhoto;
                if (fuPhoto.HasFile)
                {
                    string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp")
                    {
                        photoFileName = Guid.NewGuid().ToString() + ext;
                        string uploadDirectory = Server.MapPath("~/Uploads/Students/");
                        if (!Directory.Exists(uploadDirectory))
                        {
                            Directory.CreateDirectory(uploadDirectory);
                        }
                        fuPhoto.SaveAs(Path.Combine(uploadDirectory, photoFileName));

                        // Delete old photo if replaced
                        if (!string.IsNullOrEmpty(oldPhoto))
                        {
                            string oldFilePath = Path.Combine(uploadDirectory, oldPhoto);
                            if (File.Exists(oldFilePath)) File.Delete(oldFilePath);
                        }
                    }
                    else
                    {
                        ShowAlert("Only JPG, PNG, or WEBP image formats are supported.", "warning");
                        return;
                    }
                }

                // Update Database via ADO.NET Parameterized Query
                string updateQuery = @"UPDATE dbo.Students 
                                       SET EnrollmentNo = @EnrollmentNo, 
                                           FullName = @FullName, 
                                           Course = @Course, 
                                           Semester = @Semester, 
                                           Email = @Email, 
                                           MobileNo = @MobileNo, 
                                           Address = @Address, 
                                           Photo = @Photo
                                       WHERE StudentID = @StudentID";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@EnrollmentNo", enrollmentNo),
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@Course", course),
                    new SqlParameter("@Semester", semester),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@MobileNo", mobileNo),
                    new SqlParameter("@Address", string.IsNullOrEmpty(address) ? (object)DBNull.Value : address),
                    new SqlParameter("@Photo", string.IsNullOrEmpty(photoFileName) ? (object)DBNull.Value : photoFileName),
                    new SqlParameter("@StudentID", studentId)
                };

                DbHelper.ExecuteNonQuery(updateQuery, parameters);

                Response.Redirect("~/Students.aspx?status=updated", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowAlert("Database error updating student: " + ex.Message, "danger");
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
