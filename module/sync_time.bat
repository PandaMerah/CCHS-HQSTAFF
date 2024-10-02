sc triggerinfo w32time delete
tzutil /s "Singapore Standard Time"
w32tm /resync
echo The current time and date:
date /t
time /t
echo Time has been synced, please check if it's correct
pause