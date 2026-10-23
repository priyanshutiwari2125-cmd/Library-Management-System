# One-click startup script: Builds project, starts LocalDB, launches IIS Express & Cloudflare Tunnel

$projectDir = $PSScriptRoot
$iisExpress = "C:\Program Files\IIS Express\iisexpress.exe"
$port = 8080
$cloudflared = Join-Path $projectDir "tools\cloudflared.exe"

# 1. Check for cloudflared
if (!(Test-Path $cloudflared)) {
    Write-Host "Downloading cloudflared.exe..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path (Join-Path $projectDir "tools") | Out-Null
    (New-Object System.Net.WebClient).DownloadFile("https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe", $cloudflared)
}

# 2. Check and compile project if needed
$dllPath = Join-Path $projectDir "bin\LibraryManagementSystem.dll"
$msbuildPaths = @(
    "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\amd64\MSBuild.exe",
    "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\amd64\MSBuild.exe",
    "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
)

$msbuild = $msbuildPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (!(Test-Path $dllPath) -and $msbuild) {
    Write-Host "Compiling LibraryManagementSystem..." -ForegroundColor Cyan
    & $msbuild (Join-Path $projectDir "LibraryManagementSystem.csproj") /p:Configuration=Release /v:m
}

# 3. Check and start LocalDB
Write-Host "Starting SQL LocalDB..." -ForegroundColor Cyan
& sqllocaldb start MSSQLLocalDB 2>$null

# 4. Restart IIS Express
Write-Host "Starting IIS Express on port $port..." -ForegroundColor Cyan
Get-Process iisexpress -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Process -FilePath $iisExpress -ArgumentList "/path:`"$projectDir`" /port:$port" -WindowStyle Hidden

Start-Sleep -Seconds 2

# 5. Launch Cloudflare Tunnel
Write-Host "Starting Cloudflare Live Tunnel..." -ForegroundColor Green
Write-Host "Keep this window open to keep the live link active." -ForegroundColor Yellow
& $cloudflared tunnel --url "http://localhost:$port" --http-host-header "localhost:$port"
