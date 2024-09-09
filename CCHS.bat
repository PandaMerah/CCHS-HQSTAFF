@echo off

::Variable Declaration
set installPrinters=0
set installOffice=0
set installTPP=0
set addHQWifi=0
set SSID=CCHS
set HEXSTR=125cchsHQ2023
set XML_OUTPUT_PATH=%TEMP%\%SSID%-wireless-profile-generated.xml
set printer1_ip=192.168.1.150
set printer2_name=Konica Minolta C226i Printer
set printer2_ip=192.168.1.180
set printer2_name=Sharp MX-3140n Printer

:: Start script
echo Customization of the installation script
cd "%USERPROFILE%\Downloads\CCHS-HQSTAFF-main"

:: User Customization
choice /M "Install printers HQ?"
if %errorlevel%==1 (
    set installPrinters=1
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
choice /M "Install addHQWifi?"
if %errorlevel%==1 (
    set addHQWifi=1
)

::Adding HQ Wifi to the list
if %addHQWifi%==1 (
  echo Adding HQ Wifi
  echo ^<?xml version="1.0"?^>^<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1"^>^<name^>%SSID%^</name^>^<SSIDConfig^>^<SSID^>^<name^>%SSID%^</name^>^</SSID^>^</SSIDConfig^>^<connectionType^>ESS^</connectionType^>^<connectionMode^>auto^</connectionMode^>^<MSM^>^<security^>^<authEncryption^>^<authentication^>WPA2PSK^</authentication^>^<encryption^>AES^</encryption^>^<useOneX^>false^</useOneX^>^</authEncryption^>^<sharedKey^>^<keyType^>passPhrase^</keyType^>^<protected^>false^</protected^>^<keyMaterial^>%HEXSTR%^</keyMaterial^>^</sharedKey^>^</security^>^</MSM^>^<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3"^>^<enableRandomization^>false^</enableRandomization^>^</MacRandomization^>^</WLANProfile^> >%XML_OUTPUT_PATH%
  netsh wlan add profile filename="%XML_OUTPUT_PATH%"
  netsh wlan connect name="%SSID%"
  del "%XML_OUTPUT_PATH%"
)

::Set timezone to Malaysia and sync the time
tzutil /s "Singapore Standard Time"
w32tm /resync
echo The current time and date:
date /t
time /t
echo Time has been sync, please check the time is it correct
pause

:: Installing Apps
echo ........Installing Apps........
winget upgrade --id Microsoft.Winget.Client
winget install --id=Google.Chrome -e -h --force
winget install --id=AnyDeskSoftwareGmbH.AnyDesk -e -h --force
winget install --id=Microsoft.Teams -e -h --force
winget install --id=RARLab.WinRAR -e -h --force
winget install --id=Box.Box -e -h --force
winget install --id=Adobe.Acrobat.Reader.64-bit -e -h --force

if %installOffice%==1 (
    echo ........Installing Office........
    ::call .\Office\office.bat
    start .\Office\setup.exe /configure .\Office\configuration.xml
) else if %installOffice%==0 (
    echo ........Installing WPS........
    winget install --id=Kingsoft.WPSOffice -e -h --force
)

if %installTPP%==1 (
    echo ........Installing TPP........
    start /w .\TPP.exe /silent
)

:: Customizing Windows
echo ........Customizing Windows........
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f
copy .\CCHS_WALLPAPER.jpg "%USERPROFILE%\Documents"
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%USERPROFILE%\Documents\CCHS_WALLPAPER.jpg" /f
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters


:: Installing HQ Printers
if %installPrinters%==1 (
    echo ........Installing HQ Printers........
    pnputil /add-driver .\printerDriver\Konica\KOAXCJ__.inf /install
    if %errorlevel% neq 0 (
        echo Failed to install the printer driver.
        pause
        exit /b
    )
    echo Printer driver installed successfully.
    cscript %WINDIR%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%printer1_ip% -h %printer1_ip% -o raw -n 9100
    if %errorlevel% neq 0 (
        echo Failed to create TCP/IP printer port.
        pause
        exit /b
    )
    echo Printer port created successfully.
    rundll32 printui.dll,PrintUIEntry /if /b "%printer1_name%" /r "IP_%printer1_ip%" /m "KOAXCJ__.inf" /f .\printerDriver\Konica\KOAXCJ__.inf
    if %errorlevel% neq 0 (
        echo Failed to install the printer.
        pause
        exit /b
    )
    echo Konica Printer Added
    pnputil /add-driver ".\printerDriver\Sharp\ss0emenu.inf" /install
    if %errorlevel% neq 0 (
        echo Failed to install the printer driver.
        pause
        exit /b
    )
    echo Printer driver installed successfully.
    cscript %WINDIR%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%printer2_ip% -h %printer2_ip% -o raw -n 9100
    if %errorlevel% neq 0 (a
        echo Failed to create TCP/IP printer port.
        pause
        exit /b
    )
    echo Printer port created successfully.
    rundll32 printui.dll,PrintUIEntry /if /b "%printer2_name%" /r "IP_%printer2_ip%" /m "ss0emenu.inf" /f ".\printerDriver\Sharp\ss0emenu.inf"
    if %errorlevel% neq 0 (
        echo Failed to install the printer.
        pause
        exit /b
    )
    Echo Sharp Printer Added
    echo Printer installed successfully.
)

echo Fresh Windows setup is complete!
pause
exit