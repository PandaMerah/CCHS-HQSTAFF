@echo off

:: Check if running as Administrator
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Variable Declaration
set installPrinters=0
set installOffice=0
set installTPP=0
set addHQWifi=0
set runTimeSync=0
set runChocolatey=0
set installApps=0
set SSID=CCHS
set HEXSTR=125cchsHQ2023
set XML_OUTPUT_PATH=%TEMP%\%SSID%-wireless-profile-generated.xml
set printer1_ip=192.168.1.150
set printer1_name=Konica Minolta C226i Printer
set printer2_ip=192.168.1.180
set printer2_name=Sharp MX-3140n Printer

:: Start script
echo Customization of the installation script
cd "%USERPROFILE%\Downloads\CCHS-HQSTAFF-main"

:: User Customization: Choose module to run
choice /M "Add HQ WiFi?"
if %errorlevel%==1 (
    set addHQWifi=1
)
choice /M "Sync Time and Set Timezone to Malaysia?"
if %errorlevel%==1 (
    set runTimeSync=1
)
choice /M "Install Apps (e.g., Chrome, AnyDesk, Teams)?"
if %errorlevel%==1 (
    set installApps=1
)
choice /M "Install Office or WPS?"
if %errorlevel%==1 (
    set installOffice=1
) else (
    set installOffice=0
)
choice /M "Install TPP?"
if %errorlevel%==1 (
    set installTPP=1
)
choice /M "Install HQ Printers?"
if %errorlevel%==1 (
    set installPrinters=1
)

:: Add HQ Wifi to the list
if %addHQWifi%==1 (
    echo Adding HQ WiFi
    call .\module\add_hq_wifi.bat
)

:: Sync time and set timezone
if %runTimeSync%==1 (
    echo Setting Timezone to Malaysia and syncing time...
    call .\module\sync_time.bat
)

:: Install apps using Chocolatey
if %installApps%==1 (
    echo Installing Chocolatey
    call .\module\install_chocolatey.bat
    echo Installing applications...
    start .\module\install_software.bat
    echo All apps installed successfully.
)

:: Install Office or WPS
if %installOffice%==1 (
    echo Installing Office...
    start .\Office\setup.exe /configure .\Office\configuration.xml
) else (
    echo Installing WPS...
    choco install wps-office -y --force
)

:: Install TPP
if %installTPP%==1 (
    echo Installing TPP...
    start /w .\TPP.exe /silent
)

:: Install HQ Printers
if %installPrinters%==1 (

    bcdedit /set nointegritychecks on
    bcdedit /set testsigning on
    echo Driver signature enforcement disabled.

    echo Installing HQ Printers...
    start .\module\add_konikaprinter.bat
    start .\module\add_sharpprinter.bat

    bcdedit /set nointegritychecks off
    bcdedit /set testsigning off   
    echo All printers installed successfully.
)

:: Windows Customization
echo Customizing Windows...
start .\module\customize_windows.bat

pause
exit
