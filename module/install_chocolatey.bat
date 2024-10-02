@powershell -NoProfile -ExecutionPolicy Bypass -Command "if ((Get-Command -Name choco.exe -ErrorAction SilentlyContinue) -eq $null) { exit 1 } else { exit 0 }"

if %errorlevel%==1 (
    echo Installing Chocolatey...
    start /wait cmd /c "@powershell -NoProfile -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy Bypass -Scope Process; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))\""
    start cmd /c refreshenv
    echo Chocolatey installed and environment variables refreshed.
) else (
    echo Chocolatey is already installed.
)