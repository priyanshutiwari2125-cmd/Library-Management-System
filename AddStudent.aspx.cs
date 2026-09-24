using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class AddStudent : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSaveStudent_Click(object sender, EventArgs e)
        {
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
                // Duplicate Enrollment No Check
                string checkQuery = "SELECT COUNT(*) FROM dbo.Students WHERE EnrollmentNo = @EnrollmentNo";
                object existingCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { new SqlParameter("@EnrollmentNo", enrollmentNo) });
                if (existingCount != null && Convert.ToInt32(existingCount) > 0)
                {
                    ShowAlert("A student with Enrollment No '" + enrollmentNo + "' is already registered.", "danger");
                    return;
                }

                // Handle Photo Upload
                string photoFileName = "";
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
                    }
                    else
                    {
                        ShowAlert("Only JPG, PNG, or WEBP image formats are supported.", "warning");
                        return;
                    }
                }

                // Insert Student Record via ADO.NET Parameterized Query
                string insertQuery = @"INSERT INTO dbo.Students 
                                       (EnrollmentNo, FullName, Course, Semester, Email, MobileNo, Address, Photo, IsActive)
                                       VALUES 
                                       (@EnrollmentNo, @FullName, @Course, @Semester, @Email, @MobileNo, @Address, @Photo, 1)";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@EnrollmentNo", enrollmentNo),
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@Course", course),
                    new SqlParameter("@Semester", semester),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@MobileNo", mobileNo),
                    new SqlParameter("@Address", string.IsNullOrEmpty(address) ? (object)DBNull.Value : address),
                    new SqlParameter("@Photo", string.IsNullOrEmpty(photoFileName) ? (object)DBNull.Value : photoFileName)
                };

                DbHelper.ExecuteNonQuery(insertQuery, parameters);

                Response.Redirect("~/Students.aspx?status=added", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowAlert("Database error saving student: " + ex.Message, "danger");
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
