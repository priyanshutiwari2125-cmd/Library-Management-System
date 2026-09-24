using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class EditBook : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                
                string idStr = Request.QueryString["id"];
                int bookId = 0;
                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out bookId))
                {
                    hfBookID.Value = bookId.ToString();
                    LoadBookDetails(bookId);
                }
                else
                {
                    Response.Redirect("~/Books.aspx");
                }
            }
        }

        private void LoadCategories()
        {
            try
            {
                string query = "SELECT CategoryID, CategoryName FROM dbo.Categories WHERE IsActive = 1 ORDER BY CategoryName";
                DataTable dt = DbHelper.ExecuteDataTable(query);

                ddlCategory.DataSource = dt;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();

                ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading categories: " + ex.Message, "danger");
            }
        }

        private void LoadBookDetails(int bookId)
        {
            try
            {
                string query = "SELECT * FROM dbo.Books WHERE BookID = @BookID";
                DataTable dt = DbHelper.ExecuteDataTable(query, new SqlParameter[] { new SqlParameter("@BookID", bookId) });

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    txtISBN.Text = row["ISBN"].ToString();
                    txtTitle.Text = row["Title"].ToString();
                    ddlCategory.SelectedValue = row["CategoryID"].ToString();
                    txtAuthor.Text = row["Author"].ToString();
                    txtPublisher.Text = row["Publisher"].ToString();
                    txtEdition.Text = row["Edition"].ToString();
                    txtQuantity.Text = row["Quantity"].ToString();
                    litCurrentAvailable.Text = row["AvailableQuantity"].ToString();

                    string coverImg = row["CoverImage"].ToString();
                    if (!string.IsNullOrEmpty(coverImg) && File.Exists(Server.MapPath("~/Uploads/Books/" + coverImg)))
                    {
                        imgCurrentCover.ImageUrl = "~/Uploads/Books/" + coverImg;
                    }
                    else
                    {
                        imgCurrentCover.ImageUrl = "https://via.placeholder.com/160x220/4f46e5/ffffff?text=Book+Cover";
                    }
                }
                else
                {
                    Response.Redirect("~/Books.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading book details: " + ex.Message, "danger");
            }
        }

        protected void btnUpdateBook_Click(object sender, EventArgs e)
        {
            int bookId = Convert.ToInt32(hfBookID.Value);
            string isbn = txtISBN.Text.Trim();
            string title = txtTitle.Text.Trim();
            string categoryVal = ddlCategory.SelectedValue;
            string author = txtAuthor.Text.Trim();
            string publisher = txtPublisher.Text.Trim();
            string edition = txtEdition.Text.Trim();
            string qtyStr = txtQuantity.Text.Trim();

            if (string.IsNullOrEmpty(isbn) || string.IsNullOrEmpty(title) || string.IsNullOrEmpty(categoryVal) || string.IsNullOrEmpty(author) || string.IsNullOrEmpty(qtyStr))
            {
                ShowAlert("Please fill in all mandatory fields marked with *", "danger");
                return;
            }

            int newQuantity = Convert.ToInt32(qtyStr);

            try
            {
                // Duplicate ISBN Check (Excluding Current Book)
                string checkQuery = "SELECT COUNT(*) FROM dbo.Books WHERE ISBN = @ISBN AND BookID <> @BookID";
                object existingCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { 
                    new SqlParameter("@ISBN", isbn),
                    new SqlParameter("@BookID", bookId)
                });
                if (existingCount != null && Convert.ToInt32(existingCount) > 0)
                {
                    ShowAlert("Another book with ISBN '" + isbn + "' is already registered.", "danger");
                    return;
                }

                // Fetch current stock stats
                string getOldQuery = "SELECT Quantity, AvailableQuantity, CoverImage FROM dbo.Books WHERE BookID = @BookID";
                DataTable dtOld = DbHelper.ExecuteDataTable(getOldQuery, new SqlParameter[] { new SqlParameter("@BookID", bookId) });
                int oldQuantity = Convert.ToInt32(dtOld.Rows[0]["Quantity"]);
                int oldAvailable = Convert.ToInt32(dtOld.Rows[0]["AvailableQuantity"]);
                string oldImage = dtOld.Rows[0]["CoverImage"].ToString();

                int qtyDiff = newQuantity - oldQuantity;
                int newAvailable = oldAvailable + qtyDiff;
                if (newAvailable < 0) newAvailable = 0;

                // File Upload handling
                string fileName = oldImage;
                if (fuCoverImage.HasFile)
                {
                    string ext = Path.GetExtension(fuCoverImage.FileName).ToLower();
                    if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".webp")
                    {
                        fileName = Guid.NewGuid().ToString() + ext;
                        string uploadDirectory = Server.MapPath("~/Uploads/Books/");
                        if (!Directory.Exists(uploadDirectory))
                        {
                            Directory.CreateDirectory(uploadDirectory);
                        }
                        fuCoverImage.SaveAs(Path.Combine(uploadDirectory, fileName));

                        // Delete old cover image if replaced
                        if (!string.IsNullOrEmpty(oldImage))
                        {
                            string oldFilePath = Path.Combine(uploadDirectory, oldImage);
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
                string updateQuery = @"UPDATE dbo.Books 
                                       SET ISBN = @ISBN, 
                                           Title = @Title, 
                                           CategoryID = @CategoryID, 
                                           Author = @Author, 
                                           Publisher = @Publisher, 
                                           Edition = @Edition, 
                                           Quantity = @Quantity, 
                                           AvailableQuantity = @AvailableQuantity, 
                                           CoverImage = @CoverImage,
                                           Status = CASE WHEN @AvailableQuantity > 0 THEN 'Available' ELSE 'Out of Stock' END
                                       WHERE BookID = @BookID";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ISBN", isbn),
                    new SqlParameter("@Title", title),
                    new SqlParameter("@CategoryID", Convert.ToInt32(categoryVal)),
                    new SqlParameter("@Author", author),
                    new SqlParameter("@Publisher", string.IsNullOrEmpty(publisher) ? (object)DBNull.Value : publisher),
                    new SqlParameter("@Edition", string.IsNullOrEmpty(edition) ? (object)DBNull.Value : edition),
                    new SqlParameter("@Quantity", newQuantity),
                    new SqlParameter("@AvailableQuantity", newAvailable),
                    new SqlParameter("@CoverImage", string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName),
                    new SqlParameter("@BookID", bookId)
                };

                DbHelper.ExecuteNonQuery(updateQuery, parameters);

                Response.Redirect("~/Books.aspx?status=updated", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowAlert("Database error updating book: " + ex.Message, "danger");
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
