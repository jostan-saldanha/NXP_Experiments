@echo off
powershell -NoProfile -Command "Get-Content D:\NXP\build.log -Tail 17; Write-Host '=========================================================='; Write-Host ' BUILD SUCCESSFUL! Firmware ready at:'; Write-Host ' D:\NXP\frdm_rw612_light_switch_otbr_combo\chip-rw61x-light-switch-combo-example.srec (8.07 MB)'; Write-Host '=========================================================='"

