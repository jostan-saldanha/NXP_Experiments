@echo off
setlocal

:: Ensure working directory is always this script's directory (USB or local disk)
cd /d "%~dp0"

set "FW_FILE=chip-rw61x-light-switch-combo-example.srec"
set "CMD_SCRIPT=%~dp0commands_script"
set "LOG_FILE=%TEMP%\jlink_rw612_flash.log"

:: Step 1: Verify firmware binary exists
if exist "%~dp0%FW_FILE%" goto :fw_ready
if exist "%~dp0firmware\%FW_FILE%" (
    echo [INFO] Copying firmware binary from firmware\ directory...
    copy /y "%~dp0firmware\%FW_FILE%" "%~dp0%FW_FILE%" >nul
    goto :fw_ready
)

echo ============================================================
echo [ERROR] Firmware file "%FW_FILE%" not found!
echo Please ensure the firmware binary is present in:
echo   %~dp0
echo ============================================================
echo.
pause
exit /b 1

:fw_ready

:: Step 2: Verify commands_script exists, regenerate if missing
if not exist "%CMD_SCRIPT%" (
    echo [INFO] Generating commands_script...
    (
        echo reset
        echo halt
        echo loadfile %FW_FILE%
        echo reset
        echo go
        echo quit
    ) > "%CMD_SCRIPT%"
)

:: Step 3: Locate SEGGER J-Link executable dynamically
set "JLINK_EXE="

:: 3a. User manual override if defined
if defined JLINK_PATH if exist "%JLINK_PATH%" set "JLINK_EXE=%JLINK_PATH%"

:: 3b. Check Windows Registry (HKCU / HKLM / WOW6432Node)
if not defined JLINK_EXE (
    for %%K in (
        "HKCU\Software\SEGGER\J-Link"
        "HKLM\SOFTWARE\SEGGER\J-Link"
        "HKLM\SOFTWARE\WOW6432Node\SEGGER\J-Link"
    ) do (
        if not defined JLINK_EXE (
            for /f "tokens=2* skip=2" %%A in ('reg query %%K /v InstallPath 2^>nul') do (
                if exist "%%~B\JLink.exe" set "JLINK_EXE=%%~B\JLink.exe"
            )
        )
    )
)

:: 3c. Scan standard Program Files installation directories (all version subfolders)
if not defined JLINK_EXE (
    for %%P in (
        "%ProgramFiles%"
        "%ProgramFiles(x86)%"
        "%LOCALAPPDATA%\Programs"
        "C:\Program Files"
        "C:\Program Files (x86)"
        "D:\Program Files"
        "D:\Program Files (x86)"
    ) do (
        if exist "%%~P\SEGGER" (
            for /d %%D in ("%%~P\SEGGER\JLink*") do (
                if exist "%%~D\JLink.exe" set "JLINK_EXE=%%~D\JLink.exe"
            )
        )
    )
)

:: 3d. Check system PATH via 'where', but filter out Java's jlink.exe collision
if not defined JLINK_EXE (
    for /f "delims=" %%I in ('where JLink.exe 2^>nul') do (
        if not defined JLINK_EXE (
            echo "%%~I" | findstr /i "Java jdk" >nul
            if errorlevel 1 (
                if exist "%%~I" set "JLINK_EXE=%%~I"
            )
        )
    )
)

:: Step 4: If J-Link is still not found, show user-friendly instructions
if not defined JLINK_EXE goto :jlink_not_found

:: Step 5: Execute Flashing
echo ============================================================
echo   Flashing Matter Light Switch Combo to NXP FRDM-RW612
echo ============================================================
echo Flasher:  "%JLINK_EXE%"
echo Firmware: "%~dp0%FW_FILE%"
echo Device:   RW612 (Interface: SWD, Speed: 4000 kHz)
echo ============================================================
echo.
echo Connecting to FRDM-RW612 via J-Link...

if exist "%LOG_FILE%" del /f /q "%LOG_FILE%" >nul 2>&1

:: Run J-Link with -ExitOnError 1 and -NoGui 1 to prevent hanging on prompts, and capture output
"%JLINK_EXE%" -device RW612 -if SWD -speed 4000 -autoconnect 1 -ExitOnError 1 -NoGui 1 -CommanderScript "%CMD_SCRIPT%" > "%LOG_FILE%" 2>&1
set "FLASH_ERR=%ERRORLEVEL%"

:: Show the log output so user sees real-time progress
type "%LOG_FILE%"

echo.

:: Strict Verification:
:: 1. If ExitOnError triggered an exit code != 0
if %FLASH_ERR% NEQ 0 goto :flash_error

:: 2. Check if connection failure or error strings are present in log
findstr /i /c:"FAILED: Cannot connect" /c:"connection not established" /c:"Could not connect to target" /c:"Cannot connect to the probe" /c:"Error while programming" "%LOG_FILE%" >nul 2>&1
if not errorlevel 1 goto :flash_error

:: 3. Check if actual successful file download occurred
findstr /i /c:"Downloading file" /c:"O.K." /c:"Flash download completed" "%LOG_FILE%" >nul 2>&1
if errorlevel 1 goto :flash_error

goto :flash_success

:flash_success
echo ============================================================
echo [SUCCESS] Firmware Flashed Successfully!
echo ============================================================
echo Next Steps:
echo 1. Open a Serial Terminal (PuTTY, Tera Term, VS Code) on your COM port.
echo    - Baud Rate: 115200, Data: 8 bit, Parity: None, Stop: 1
echo 2. Press the RESET button on the FRDM-RW612 board.
echo 3. At the prompt, type: mattercommissioning on
echo 4. Commission device with phone using QR code: matter_qr_code.html
echo ============================================================
goto :flash_done

:flash_error
echo ============================================================
echo [ERROR] Flashing failed! Device was not flashed.
echo ============================================================
echo Reason: Could not connect to the FRDM-RW612 board.
echo.
echo Troubleshooting Checklist:
echo 1. Connect Micro-USB Cable to the J10 (Debug) port on the board.
echo    (NOT the high-speed USB port).
echo 2. Verify that the Power LED on the FRDM-RW612 is ON.
echo 3. Open Windows Device Manager -^> Ports (COM ^& LPT):
echo    Ensure 'JLink CDC UART Port' is listed.
echo 4. Unplug and replug the USB cable, then run this script again.
echo ============================================================
goto :flash_done

:jlink_not_found
echo ========================================================================
echo [ERROR] SEGGER J-Link was NOT found on this system!
echo ========================================================================
echo Flashing the FRDM-RW612 board requires SEGGER J-Link software.
echo.
echo Please follow these steps:
echo 1. Download and install SEGGER J-Link Software and Documentation Pack:
echo    https://www.segger.com/downloads/jlink/
echo 2. Connect the FRDM-RW612 board to your PC via USB port J10 (Debug).
echo 3. Re-run this script after installation.
echo ========================================================================
echo.
goto :flash_done

:flash_done
if exist "%LOG_FILE%" del /f /q "%LOG_FILE%" >nul 2>&1
pause
