<%@ Page Title="Add New Book" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddBook.aspx.cs" Inherits="LibraryManagementSystem.AddBook" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-book-medical text-primary me-2"></i> Register New Book</h4>
            <p class="text-muted small mb-0">Fill out book details to add a title to the library catalog</p>
        </div>
        <div>
            <a href="Books.aspx" class="btn btn-outline-secondary">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Books Directory
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="card card-custom p-4">
        <div class="row g-4">
            <!-- Left Form Section -->
            <div class="col-12 col-lg-8">
                <div class="row g-3">
                    <div class="col-12 col-md-6">
                        <label for="txtISBN" class="form-label fw-semibold small text-secondary">ISBN Number <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtISBN" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. 978-0131103627" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="ddlCategory" class="form-label fw-semibold small text-secondary">Category <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-select-custom" required="required">
                        </asp:DropDownList>
                    </div>

                    <div class="col-12">
                        <label for="txtTitle" class="form-label fw-semibold small text-secondary">Book Title <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control form-control-custom" placeholder="Enter complete book title" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtAuthor" class="form-label fw-semibold small text-secondary">Author(s) <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtAuthor" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. Robert C. Martin" required="required"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtPublisher" class="form-label fw-semibold small text-secondary">Publisher</label>
                        <asp:TextBox ID="txtPublisher" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. Prentice Hall"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtEdition" class="form-label fw-semibold small text-secondary">Edition</label>
                        <asp:TextBox ID="txtEdition" runat="server" CssClass="form-control form-control-custom" placeholder="e.g. 2nd Edition"></asp:TextBox>
                    </div>

                    <div class="col-12 col-md-6">
                        <label for="txtQuantity" class="form-label fw-semibold small text-secondary">Quantity / Stock <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" CssClass="form-control form-control-custom" placeholder="1" min="1" max="1000" required="required"></asp:TextBox>
                    </div>
                </div>
            </div>

            <!-- Right File Upload & Preview Section -->
            <div class="col-12 col-lg-4 border-start border-light-subtle">
                <div class="text-center p-3">
                    <label class="form-label fw-semibold small text-secondary d-block mb-3">Book Cover Image</label>
                    
                    <div class="mb-3">
                        <img id="imgPreview" src="https://via.placeholder.com/160x220/4f46e5/ffffff?text=Book+Cover" alt="Cover Preview" class="img-fluid rounded shadow-sm border" style="max-height: 220px;" />
                    </div>

                    <div class="mb-3">
                        <asp:FileUpload ID="fuCoverImage" runat="server" CssClass="form-control form-control-sm" onchange="previewUploadedImage(this, 'imgPreview');" />
                        <small class="text-muted d-block mt-1">Allowed formats: JPG, PNG, WEBP (Max 5MB)</small>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="col-12 pt-3 border-top d-flex gap-2">
                <asp:Button ID="btnSaveBook" runat="server" Text="Save Book Record" CssClass="btn btn-primary-custom px-4" OnClick="btnSaveBook_Click" />
                <a href="Books.aspx" class="btn btn-light px-4">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
