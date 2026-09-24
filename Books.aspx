<%@ Page Title="Book Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Books.aspx.cs" Inherits="LibraryManagementSystem.Books" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h4 class="fw-bold text-dark mb-1"><i class="fa-solid fa-book text-primary me-2"></i> Book Directory</h4>
            <p class="text-muted small mb-0">Manage library book inventory, search, filter, and track stock levels</p>
        </div>
        <div>
            <a href="AddBook.aspx" class="btn btn-primary-custom">
                <i class="fa-solid fa-plus me-1"></i> Add New Book
            </a>
        </div>
    </div>

    <!-- Alert Notifications -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Filter & Options Card -->
    <div class="card card-custom p-3 mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-12 col-md-4">
                <label for="ddlCategoryFilter" class="form-label small fw-semibold text-secondary mb-1">Filter by Category</label>
                <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="form-select form-select-custom" AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="col-12 col-md-4 ms-auto text-md-end">
                <span class="text-muted small">Total Registered Titles: <strong class="text-dark"><asp:Literal ID="litBookCount" runat="server">0</asp:Literal></strong></span>
            </div>
        </div>
    </div>

    <!-- Books Data Table -->
    <div class="card card-custom p-4">
        <div class="table-responsive">
            <asp:GridView ID="gvBooks" runat="server" AutoGenerateColumns="False" UseAccessibleHeader="true"
                CssClass="table table-hover align-middle datatable w-100" DataKeyNames="BookID" 
                OnRowCommand="gvBooks_RowCommand" OnRowDeleting="gvBooks_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="Cover">
                        <ItemTemplate>
                            <img src='<%# GetCoverImageUrl(Eval("CoverImage")) %>' alt="Cover" class="img-thumb-custom" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="ISBN" HeaderText="ISBN" />
                    
                    <asp:TemplateField HeaderText="Book Details">
                        <ItemTemplate>
                            <div class="fw-bold text-dark"><%# Eval("Title") %></div>
                            <small class="text-muted"><i class="fa-solid fa-pen-nib me-1"></i> <%# Eval("Author") %></small>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                    <asp:BoundField DataField="Publisher" HeaderText="Publisher" />
                    <asp:BoundField DataField="Edition" HeaderText="Edition" />

                    <asp:TemplateField HeaderText="Stock / Avail">
                        <ItemTemplate>
                            <span class="fw-bold text-dark"><%# Eval("AvailableQuantity") %></span> / <span class="text-muted"><%# Eval("Quantity") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# Convert.ToInt32(Eval("AvailableQuantity")) > 0 ? "badge-status-available" : "badge-status-overdue" %>'>
                                <%# Convert.ToInt32(Eval("AvailableQuantity")) > 0 ? "Available" : "Out of Stock" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end">
                        <ItemTemplate>
                            <a href='<%# "EditBook.aspx?id=" + Eval("BookID") %>' class="btn btn-sm btn-outline-primary me-1" title="Edit Book">
                                <i class="fa-solid fa-pen"></i>
                            </a>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteBook" CommandArgument='<%# Eval("BookID") %>' 
                                CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Are you sure you want to delete this book record?');" title="Delete Book">
                                <i class="fa-solid fa-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center py-4 text-muted">
                        <i class="fa-solid fa-book-open fs-2 mb-2 d-block text-secondary"></i>
                        No book records found. Click <strong>Add New Book</strong> to get started.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
