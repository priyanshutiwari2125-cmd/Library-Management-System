using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class Books : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoriesFilter();
                LoadBooksList();

                string status = Request.QueryString["status"];
                if (status == "added")
                {
                    ShowAlert("Book registered successfully!", "success");
                }
                else if (status == "updated")
                {
                    ShowAlert("Book record updated successfully!", "success");
                }
            }
        }

        private void LoadCategoriesFilter()
        {
            try
            {
                string query = "SELECT CategoryID, CategoryName FROM dbo.Categories WHERE IsActive = 1 ORDER BY CategoryName";
                DataTable dt = DbHelper.ExecuteDataTable(query);

                ddlCategoryFilter.DataSource = dt;
                ddlCategoryFilter.DataTextField = "CategoryName";
                ddlCategoryFilter.DataValueField = "CategoryID";
                ddlCategoryFilter.DataBind();

                ddlCategoryFilter.Items.Insert(0, new ListItem("-- All Categories --", "0"));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading categories: " + ex.Message, "danger");
            }
        }

        private void LoadBooksList()
        {
            try
            {
                string query = @"SELECT 
                                    b.BookID, 
                                    b.ISBN, 
                                    b.Title, 
                                    b.CategoryID, 
                                    c.CategoryName, 
                                    b.Author, 
                                    b.Publisher, 
                                    b.Edition, 
                                    b.Quantity, 
                                    b.AvailableQuantity, 
                                    b.CoverImage, 
                                    b.Status
                                 FROM dbo.Books b
                                 INNER JOIN dbo.Categories c ON b.CategoryID = c.CategoryID";

                int categoryId = Convert.ToInt32(ddlCategoryFilter.SelectedValue);
                SqlParameter[] parameters = null;

                if (categoryId > 0)
                {
                    query += " WHERE b.CategoryID = @CategoryID";
                    parameters = new SqlParameter[] { new SqlParameter("@CategoryID", categoryId) };
                }

                query += " ORDER BY b.BookID DESC";

                DataTable dt = DbHelper.ExecuteDataTable(query, parameters);
                gvBooks.DataSource = dt;
                gvBooks.DataBind();
                if (gvBooks.Rows.Count > 0)
                {
                    gvBooks.HeaderRow.TableSection = System.Web.UI.WebControls.TableRowSection.TableHeader;
                }

                litBookCount.Text = dt != null ? dt.Rows.Count.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading books: " + ex.Message, "danger");
            }
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadBooksList();
        }

        protected void gvBooks_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteBook")
            {
                int bookId = Convert.ToInt32(e.CommandArgument);
                DeleteBookRecord(bookId);
            }
        }

        protected void gvBooks_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // GridView RowDeleting handler required for command execution
        }

        private void DeleteBookRecord(int bookId)
        {
            try
            {
                // Check if book currently has active issue records
                string checkQuery = "SELECT COUNT(*) FROM dbo.IssueBooks WHERE BookID = @BookID AND Status IN ('Issued', 'Overdue')";
                object activeCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { new SqlParameter("@BookID", bookId) });

                if (activeCount != null && Convert.ToInt32(activeCount) > 0)
                {
                    ShowAlert("Cannot delete book: This book is currently issued to a student. Receive the return first.", "warning");
                    return;
                }

                // Delete image file if exists
                string getImageQuery = "SELECT CoverImage FROM dbo.Books WHERE BookID = @BookID";
                object coverObj = DbHelper.ExecuteScalar(getImageQuery, new SqlParameter[] { new SqlParameter("@BookID", bookId) });
                if (coverObj != null && !string.IsNullOrEmpty(coverObj.ToString()))
                {
                    string filePath = Server.MapPath("~/Uploads/Books/" + coverObj.ToString());
                    if (File.Exists(filePath))
                    {
                        File.Delete(filePath);
                    }
                }

                string deleteQuery = "DELETE FROM dbo.Books WHERE BookID = @BookID";
                DbHelper.ExecuteNonQuery(deleteQuery, new SqlParameter[] { new SqlParameter("@BookID", bookId) });

                ShowAlert("Book deleted successfully.", "success");
                LoadBooksList();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting book: " + ex.Message, "danger");
            }
        }

        protected string GetCoverImageUrl(object coverImgObj)
        {
            string fileName = coverImgObj != null ? coverImgObj.ToString() : "";
            if (!string.IsNullOrEmpty(fileName) && File.Exists(Server.MapPath("~/Uploads/Books/" + fileName)))
            {
                return ResolveUrl("~/Uploads/Books/" + fileName);
            }
            return "https://via.placeholder.com/120x160/4f46e5/ffffff?text=Book+Cover";
        }

        private void ShowAlert(string message, string alertType)
        {
            litAlertMessage.Text = Server.HtmlEncode(message);
            pnlAlert.CssClass = "alert alert-" + alertType + " alert-dismissible fade show";
            pnlAlert.Visible = true;
        }
    }
}
