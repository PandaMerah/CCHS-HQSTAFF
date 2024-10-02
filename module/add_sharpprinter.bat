:: Install Sharp Printer Driver
pnputil /add-driver ".\printerDriver\64bit\ss0emenu.inf" /install /force
if %errorlevel% neq 0 (
    echo Failed to install the Sharp printer driver.
    pause
    exit /b
)
echo Sharp printer driver installed successfully.

:: Create TCP/IP port for Sharp printer
cscript %WINDIR%\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_%printer2_ip% -h %printer2_ip% -o raw -n 9100
if %errorlevel% neq 0 (
    echo Failed to create TCP/IP port for Sharp printer.
    pause
    exit /b
)
echo Sharp printer port created successfully.

:: Add Sharp printer
rundll32 printui.dll,PrintUIEntry /if /b "%printer2_name%" /r "IP_%printer2_ip%" /m "ss0emenu.inf" /f ".\printerDriver\64bit\ss0emenu.inf"
if %errorlevel% neq 0 (
    echo Failed to install Sharp printer.
    pause
    exit /b
)
echo Sharp Printer Added.
