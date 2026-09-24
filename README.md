# 📚 Library Management System

> ### 🔗 **Live Demo**: [https://library-system-live.loca.lt/Login.aspx](https://library-system-live.loca.lt/Login.aspx)
> **Login**: `admin` &nbsp;|&nbsp; **Password**: `admin123`

[![Live Demo](https://img.shields.io/badge/Live_Demo-Visit_App-0078D4?style=for-the-badge&logo=googlechrome&logoColor=white)](https://library-system-live.loca.lt/Login.aspx)
[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github)](https://github.com/priyanshutiwari2125-cmd/Library-Management-System)
[![ASP.NET](https://img.shields.io/badge/.NET_Framework-4.8-512BD4?style=for-the-badge&logo=dotnet)](https://dotnet.microsoft.com/)
[![SQL Server](https://img.shields.io/badge/Database-SQL_Server_LocalDB-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)

A complete, production-quality, responsive **Library Management System** built with **ASP.NET Web Forms (.NET Framework 4.8)**, **C#**, **ADO.NET**, **SQL Server**, **Bootstrap 5**, **Font Awesome 6**, **DataTables**, and **Chart.js**.

---



## 🌟 Key Features

### 1. 🔐 Secure Authentication & Session Guard
- Admin Login with SHA-256 password hashing.
- Session-based authorization via `BasePage.cs` to prevent unauthorized URL access.
- Logout functionality with session termination.

### 2. 📊 Interactive Dashboard (`Dashboard.aspx`)
- Summary KPI Cards: Total Books, Registered Students, Currently Issued Books, Overdue Count, Returned Books, Total Fines.
- Quick Action shortcuts to key operations.
- Interactive Chart.js charts: Monthly Issue/Return trend & Category distribution.
- Recently issued books log with real-time status badges.

### 3. 📚 Book Inventory Management (`Books.aspx`, `AddBook.aspx`, `EditBook.aspx`)
- Full CRUD operations with ADO.NET parameterized queries.
- Cover Image File Upload saved in `Uploads/Books/`.
- ISBN duplicate prevention check.
- Filter books dynamically by category.
- Instant search and pagination powered by DataTables.
- Automatic stock status toggling (`Available` / `Out of Stock`).

### 4. 🎓 Student Directory (`Students.aspx`, `AddStudent.aspx`, `EditStudent.aspx`)
- Full Student CRUD operations.
- Enrollment Number duplicate check.
- Student photo file upload saved in `Uploads/Students/`.
- Display active issued books count per student.

### 5. 🤝 Book Issue Module (`IssueBook.aspx`)
- Real-time preview card for selected Student & Book.
- Automatic stock check (`AvailableQuantity > 0`).
- Prevents double-issuing the same book to the same student.
- ADO.NET SQL Transaction ensures atomic stock decrement and issue creation.

### 6. 🔄 Book Return & Fine Settlement (`ReturnBook.aspx`)
- Search active issued books.
- Automatic overdue day calculation (`CurrentDate - DueDate`).
- Automatic fine computation ($2.00 / day overdue).
- Stock quantity auto-increment and status restoration on return.

### 7. 📈 Multi-Tab Reports & Export (`Reports.aspx`)
- Tabbed reports for Books, Students, Issued Books, Returned Archive, and Fine Collection.
- Client-side & DataTables export to **Excel** (CSV/HTML5) and **PDF** (PDFMake).
- Print view layout with custom `@media print` CSS.

---

## 📁 Project Folder Structure

```
WAD/
├── Code/
│   ├── DbHelper.cs              # ADO.NET parameterized query helper & password hashing
│   └── BasePage.cs              # Base page inheriting Page with session check
├── CSS/
│   └── style.css                # Custom Bootstrap 5 design system & dashboard glassmorphism
├── JS/
│   └── main.js                  # DataTables init, notifications, file preview, sidebar toggle
├── Database/
│   └── LibraryDB.sql            # Complete SQL Server creation script with seed data
├── Uploads/
│   ├── Books/                   # Uploaded book cover images
│   └── Students/                # Uploaded student photos
├── Site.Master                  # Master Page with responsive sidebar & top navbar
├── Site.Master.cs
├── Login.aspx                   # Admin Login screen
├── Login.aspx.cs
├── Dashboard.aspx               # Main Dashboard with metrics & Chart.js
├── Dashboard.aspx.cs
├── Books.aspx                   # Book inventory table view
├── Books.aspx.cs
├── AddBook.aspx                 # Add Book form
├── AddBook.aspx.cs
├── EditBook.aspx                # Edit Book form
├── EditBook.aspx.cs
├── Students.aspx                # Student directory table view
├── Students.aspx.cs
├── AddStudent.aspx              # Add Student form
├── AddStudent.aspx.cs
├── EditStudent.aspx             # Edit Student form
├── EditStudent.aspx.cs
├── IssueBook.aspx               # Issue Book form & transaction
├── IssueBook.aspx.cs
├── ReturnBook.aspx              # Return Book & fine calculation form
├── ReturnBook.aspx.cs
├── Reports.aspx                 # Multi-tab exportable report dashboard
├── Reports.aspx.cs
├── Web.config                   # Connection string & server configuration
├── LibraryManagementSystem.csproj # Visual Studio C# Project File
├── LibraryManagementSystem.sln    # Visual Studio Solution File
└── README.md                    # System documentation & setup guide
```

---

## 🛠️ Step-by-Step Setup & Execution Guide

### Step 1: Database Setup (SQL Server / SSMS)
1. Open **SQL Server Management Studio (SSMS)** or SQL Server Command Line.
2. Connect to your local SQL Server instance (e.g., `(localdb)\MSSQLLocalDB` or `localhost`).
3. Open the file `Database/LibraryDB.sql`.
4. Execute the script (`F5`).
5. This creates the database `LibraryDB`, all required tables (`Admin`, `Categories`, `Books`, `Students`, `IssueBooks`), constraints, views, and initial seed data.

### Step 2: Configure Connection String
Open `Web.config` and update the connection string if needed to point to your SQL Server instance:
```xml
<connectionStrings>
  <add name="LibraryDBConnectionString" 
       connectionString="Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=LibraryDB;Integrated Security=True;MultipleActiveResultSets=True;" 
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

### Step 3: Run the Application
#### Option A: Visual Studio
1. Open `LibraryManagementSystem.sln` or `LibraryManagementSystem.csproj` in Visual Studio 2019/2022.
2. Ensure `.NET Framework 4.8` SDK is installed.
3. Set `Login.aspx` or `Dashboard.aspx` as the Start Page (`Right click file -> Set As Start Page`).
4. Press `F5` to run with IIS Express.

#### Option B: IIS / Web Server
1. Create a new Web Application in IIS pointing to the project folder.
2. Ensure the IIS Application Pool is set to `.NET CLR Version v4.0.30319`.

---

## 🔑 Default Login Credentials

| Role | Username | Password |
| :--- | :--- | :--- |
| **Administrator** | `admin` | `admin123` |

---

## 🛡️ Security Features
- **SQL Injection Prevention**: Every database query uses ADO.NET `SqlCommand` with explicit `SqlParameter` objects.
- **XSS Prevention**: Server-side output encoding via `Server.HtmlEncode()`.
- **Session Protection**: Direct access to protected pages without logging in automatically redirects to `Login.aspx?reason=session_expired`.
