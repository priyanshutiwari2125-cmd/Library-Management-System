using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;
using LibraryManagementSystem.Code;

namespace LibraryManagementSystem
{
    public partial class AddBook : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
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

        protected void btnSaveBook_Click(object sender, EventArgs e)
        {
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

            int quantity = 1;
            int.TryParse(qtyStr, out quantity);
            if (quantity <= 0) quantity = 1;

            try
            {
                // Duplicate ISBN check
                string checkQuery = "SELECT COUNT(*) FROM dbo.Books WHERE ISBN = @ISBN";
                object existingCount = DbHelper.ExecuteScalar(checkQuery, new SqlParameter[] { new SqlParameter("@ISBN", isbn) });
                if (existingCount != null && Convert.ToInt32(existingCount) > 0)
                {
                    ShowAlert("A book with ISBN '" + isbn + "' is already registered in the system.", "danger");
                    return;
                }

                // Handle Image Upload
                string fileName = "";
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
                    }
                    else
                    {
                        ShowAlert("Only JPG, PNG, or WEBP image formats are supported.", "warning");
                        return;
                    }
                }

                // Insert into Database via ADO.NET Parameterized Command
                string insertQuery = @"INSERT INTO dbo.Books 
                                       (ISBN, Title, CategoryID, Author, Publisher, Edition, Quantity, AvailableQuantity, CoverImage, Status)
                                       VALUES 
                                       (@ISBN, @Title, @CategoryID, @Author, @Publisher, @Edition, @Quantity, @AvailableQuantity, @CoverImage, 'Available')";

                SqlParameter[] parameters = new SqlParameter[]
                {
                    new SqlParameter("@ISBN", isbn),
                    new SqlParameter("@Title", title),
                    new SqlParameter("@CategoryID", Convert.ToInt32(categoryVal)),
                    new SqlParameter("@Author", author),
                    new SqlParameter("@Publisher", string.IsNullOrEmpty(publisher) ? (object)DBNull.Value : publisher),
                    new SqlParameter("@Edition", string.IsNullOrEmpty(edition) ? (object)DBNull.Value : edition),
                    new SqlParameter("@Quantity", quantity),
                    new SqlParameter("@AvailableQuantity", quantity), // Initial available stock equals total quantity
                    new SqlParameter("@CoverImage", string.IsNullOrEmpty(fileName) ? (object)DBNull.Value : fileName)
                };

                DbHelper.ExecuteNonQuery(insertQuery, parameters);

                Response.Redirect("~/Books.aspx?status=added", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowAlert("Database error saving book: " + ex.Message, "danger");
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
