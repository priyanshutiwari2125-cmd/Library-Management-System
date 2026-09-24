using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace LibraryManagementSystem
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["AdminID"] != null)
                {
                    string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Administrator";
                    string email = Session["Email"] != null ? Session["Email"].ToString() : "admin@library.com";
                    
                    litAdminName.Text = Server.HtmlEncode(fullName);
                    litAdminEmail.Text = Server.HtmlEncode(email);
                    if (!string.IsNullOrEmpty(fullName))
                    {
                        litAdminInitial.Text = fullName.Substring(0, 1).ToUpper();
                    }
                }

                HighlightActiveMenu();
            }
        }

        private void HighlightActiveMenu()
        {
            string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();
            
            navDashboard.Attributes["class"] = "";
            navBooks.Attributes["class"] = "";
            navStudents.Attributes["class"] = "";
            navIssue.Attributes["class"] = "";
            navReturn.Attributes["class"] = "";
            navReports.Attributes["class"] = "";

            if (currentPage == "dashboard.aspx" || currentPage == "")
            {
                navDashboard.Attributes["class"] = "active";
            }
            else if (currentPage == "books.aspx" || currentPage == "addbook.aspx" || currentPage == "editbook.aspx")
            {
                navBooks.Attributes["class"] = "active";
            }
            else if (currentPage == "students.aspx" || currentPage == "addstudent.aspx" || currentPage == "editstudent.aspx")
            {
                navStudents.Attributes["class"] = "active";
            }
            else if (currentPage == "issuebook.aspx")
            {
                navIssue.Attributes["class"] = "active";
            }
            else if (currentPage == "returnbook.aspx")
            {
                navReturn.Attributes["class"] = "active";
            }
            else if (currentPage == "reports.aspx")
            {
                navReports.Attributes["class"] = "active";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx?status=logged_out", true);
        }
    }
}
