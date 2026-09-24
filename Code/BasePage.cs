using System;
using System.Web.UI;

namespace LibraryManagementSystem.Code
{
    public class BasePage : Page
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            
            // Check session authentication for all inheriting pages
            if (Session["AdminID"] == null || Session["Username"] == null)
            {
                Response.Redirect("~/Login.aspx?reason=session_expired", true);
            }
        }
    }
}
