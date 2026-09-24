# Setup script for LocalDB and LibraryDB database

$ErrorActionPreference = "Stop"

Write-Host "1. Checking SQL LocalDB..." -ForegroundColor Cyan
try {
    & sqllocaldb create MSSQLLocalDB 2>$null
    & sqllocaldb start MSSQLLocalDB 2>$null
    Write-Host "MSSQLLocalDB started successfully." -ForegroundColor Green
} catch {
    Write-Warning "Could not start sqllocaldb command directly: $_"
}

$connStrMaster = "Server=(localdb)\MSSQLLocalDB;Database=master;Integrated Security=True;Connect Timeout=15;"
$connMaster = New-Object System.Data.SqlClient.SqlConnection($connStrMaster)

try {
    $connMaster.Open()
    Write-Host "Connected to SQL Server LocalDB successfully!" -ForegroundColor Green
} catch {
    Write-Error "Failed to connect to (localdb)\MSSQLLocalDB. Please ensure Microsoft SQL Server LocalDB is installed. Error: $($_.Exception.Message)"
    exit 1
}

# Check if LibraryDB database exists, if not create it
$checkCmd = $connMaster.CreateCommand()
$checkCmd.CommandText = "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'LibraryDB') CREATE DATABASE [LibraryDB];"
$checkCmd.ExecuteNonQuery() | Out-Null
$connMaster.Close()

Write-Host "2. Running database schema and seed script..." -ForegroundColor Cyan
$sqlFile = Join-Path $PSScriptRoot "Database\LibraryDB.sql"
$sqlContent = Get-Content $sqlFile -Raw

# Split script by GO statements
$batches = [System.Text.RegularExpressions.Regex]::Split($sqlContent, "^\s*GO\s*$", [System.Text.RegularExpressions.RegexOptions]::Multiline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

$connStrDb = "Server=(localdb)\MSSQLLocalDB;Database=LibraryDB;Integrated Security=True;Connect Timeout=15;"
$connDb = New-Object System.Data.SqlClient.SqlConnection($connStrDb)
$connDb.Open()

foreach ($batch in $batches) {
    $trimmed = $batch.Trim()
    if ($trimmed -and !$trimmed.StartsWith("CREATE DATABASE") -and !$trimmed.StartsWith("USE ")) {
        try {
            $cmd = $connDb.CreateCommand()
            $cmd.CommandText = $trimmed
            $cmd.ExecuteNonQuery() | Out-Null
        } catch {
            Write-Warning "Warning executing batch: $($_.Exception.Message)"
        }
    }
}
$connDb.Close()

Write-Host "Database LibraryDB initialized successfully!" -ForegroundColor Green
