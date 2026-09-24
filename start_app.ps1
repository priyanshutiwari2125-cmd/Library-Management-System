# Library Management System Start Script

$projectDir = $PSScriptRoot
$iisExpress = "C:\Program Files\IIS Express\iisexpress.exe"
$port = 8080

# 1. Check if IIS Express executable exists
if (!(Test-Path $iisExpress)) {
    Write-Error "IIS Express is not found at $iisExpress"
    exit 1
}

# 2. Kill any existing IIS Express running on port 8080
Get-Process iisexpress -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# 3. Launch IIS Express pointing directly to the project folder
Write-Host "Starting IIS Express for $projectDir on port $port..."
Start-Process -FilePath $iisExpress -ArgumentList "/path:`"$projectDir`" /port:$port" -WindowStyle Hidden

# 4. Wait briefly for server startup
Start-Sleep -Seconds 2

# 5. Launch browser
$url = "http://localhost:$port/Login.aspx"
Write-Host "Opening $url in default browser..."
Start-Process $url

Write-Host "Library Management System started successfully at $url !"

