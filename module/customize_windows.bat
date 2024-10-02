:: Disable Windows Copilot
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f

:: Hide Task View button
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f

:: Disable Widgets on Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f

:: Show search box on Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f

:: Copy wallpaper to user's Documents folder
copy /Y ".\CCHS_WALLPAPER.jpg" "%USERPROFILE%\Documents"

:: Set custom wallpaper
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%USERPROFILE%\Documents\CCHS_WALLPAPER.jpg" /f

:: Refresh the wallpaper setting
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters ,1 ,True

echo Windows customization complete.