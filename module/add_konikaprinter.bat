:: Install Konica Printer Driver
pnputil /add-driver ".\printerDriver\win_x64\KOAXCJ__.inf" /install /force
if %errorlevel% neq 0 (
    echo Failed to install the Konica printer driver.
    pause
    exit /b
)
echo Konica printer driver installed successfully.

:: Create TCP/IP port for Konica printer
cscript %WINDIR%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%printer1_ip% -h %printer1_ip% -o raw -n 9100
if %errorlevel% neq 0 (
    echo Failed to create TCP/IP port for Konica printer.
    pause
    exit /b
)
echo Konica printer port created successfully.

:: Add Konica printer
rundll32 printui.dll,PrintUIEntry /if /b "%printer1_name%" /r "IP_%printer1_ip%" /m "KOAXCJ__.inf" /f .\printerDriver\win_x64\KOAXCJ__.inf
if %errorlevel% neq 0 (
    echo Failed to install Konica printer.
    pause
    exit /b
)
echo Konica Printer Added.