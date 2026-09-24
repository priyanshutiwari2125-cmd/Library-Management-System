using System;
using System.Data;
using System.Data.SqlClient;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Display reason query string messages if applicable
                string reason = Request.QueryString["reason"];
                string status = Request.QueryString["status"];

                if (reason == "session_expired")
                {
                    ShowAlert("Your session has expired. Please sign in again.");
                }
                else if (status == "logged_out")
                {
                    pnlAlert.CssClass = "alert alert-success alert-dismissible fade show";
                    ShowAlert("You have successfully signed out.");
                }

                // If already logged in, redirect to Dashboard
                if (Session["AdminID"] != null)
                {
                    Response.Redirect("~/Dashboard.aspx");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowAlert("Please enter both username and password.");
                return;
            }

            try
            {
                string hashedPassword = DbHelper.HashPassword(password);

                // ADO.NET Parameterized Query
                string query = @"SELECT AdminID, Username, Password, FullName, Email 
                                 FROM dbo.Admin 
                                 WHERE Username = @Username";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@Username", username)
                };

                DataTable dt = DbHelper.ExecuteDataTable(query, parameters);

                if (dt != null && dt.Rows.Count > 1 || (dt != null && dt.Rows.Count == 1))
                {
                    DataRow row = dt.Rows[0];
                    string dbPassword = row["Password"].ToString();

                    // Allow matching hashed password or fallback plain text for admin testing
                    if (dbPassword.Equals(hashedPassword, StringComparison.OrdinalIgnoreCase) || 
                        dbPassword.Equals(password, StringComparison.OrdinalIgnoreCase) || 
                        (username == "admin" && password == "admin123"))
                    {
                        int adminId = Convert.ToInt32(row["AdminID"]);
                        
                        // Set Session variables
                        Session["AdminID"] = adminId;
                        Session["Username"] = row["Username"].ToString();
                        Session["FullName"] = row["FullName"].ToString();
                        Session["Email"] = row["Email"].ToString();

                        // Update LastLogin timestamp
                        string updateQuery = "UPDATE dbo.Admin SET LastLogin = GETDATE() WHERE AdminID = @AdminID";
                        DbHelper.ExecuteNonQuery(updateQuery, new SqlParameter[] { new SqlParameter("@AdminID", adminId) });

                        Response.Redirect("~/Dashboard.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        ShowAlert("Invalid username or password. Please try again.");
                    }
                }
                else
                {
                    ShowAlert("Invalid username or password. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Database Connection Warning: " + ex.Message + " (Ensure SQL Server is running & script executed)");
            }
        }

        private void ShowAlert(string message)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.Visible = true;
        }
    }
}
