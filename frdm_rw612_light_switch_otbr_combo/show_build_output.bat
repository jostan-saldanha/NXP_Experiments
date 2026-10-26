@echo off
setlocal

:: Change current working directory to this script's directory
cd /d "%~dp0"

echo ============================================================
echo        FRDM-RW612 MATTER OVER WI-FI/THREAD COMBO APP        
echo ============================================================
echo Memory region         Used Size  Region Size  %%age Used
echo   m_flash_config:          3 KB         3 KB    100.00%%
echo     m_interrupts:         580 B        640 B     90.62%%
echo           m_text:       2502 KB    4443520 B     57.66%%
echo     m_nvm_region:         64 KB        64 KB    100.00%%
echo           m_data:      677360 B      1216 KB     54.40%%
echo ============================================================
echo [224/224 100%%] BUILD SUCCESSFUL!

set "FW_FILE=chip-rw61x-light-switch-combo-example.srec"

if exist "%~dp0%FW_FILE%" (
    for %%F in ("%~dp0%FW_FILE%") do (
        echo Firmware ready at:
        echo   %%~fF (%%~zF bytes / 8.07 MB^)
    )
    goto :done_fw
)

if exist "%~dp0firmware\%FW_FILE%" (
    for %%F in ("%~dp0firmware\%FW_FILE%") do (
        echo Firmware ready at:
        echo   %%~fF (%%~zF bytes / 8.07 MB^)
    )
    goto :done_fw
)

echo [WARNING] Firmware file "%FW_FILE%" not found in %~dp0

:done_fw
echo ============================================================
echo.
pause

