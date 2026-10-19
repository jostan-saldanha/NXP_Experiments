@echo off
set JLINK_CMD="C:\Program Files\SEGGER\JLink_V952\JLink.exe"
if not exist %JLINK_CMD% (
    set JLINK_CMD=JLink.exe
)

if not exist "chip-rw61x-light-switch-combo-example.srec" (
    if exist "chip-rw61x-light-switch-combo-example.hex" (
        echo Renaming chip-rw61x-light-switch-combo-example.hex to chip-rw61x-light-switch-combo-example.srec...
        copy /y "chip-rw61x-light-switch-combo-example.hex" "chip-rw61x-light-switch-combo-example.srec"
    ) else (
        echo [ERROR] chip-rw61x-light-switch-combo-example.srec not found!
        echo Please place your prebuilt chip-rw61x-light-switch-combo-example.srec (or .hex) in this folder.
        pause
        exit /b 1
    )
)

echo Flashing Matter Light Switch OTBR Combo to FRDM-RW612 via SEGGER J-Link...
%JLINK_CMD% -device RW612 -if SWD -speed 4000 -autoconnect 1 -CommanderScript commands_script
pause

