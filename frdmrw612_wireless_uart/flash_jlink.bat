@echo off
set JLINK_CMD="C:\Program Files\SEGGER\JLink_V952\JLink.exe"
if not exist %JLINK_CMD% (
    set JLINK_CMD=JLink.exe
)

echo Flashing wireless_uart to FRDM-RW612 via SEGGER J-Link...
%JLINK_CMD% -device RW612 -if SWD -speed 4000 -autoconnect 1 -CommanderScript commands_script
pause

