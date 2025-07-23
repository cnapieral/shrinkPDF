@echo off
set "scriptPath=%~dp0shrink_pdf.ps1"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%scriptPath%" "%1"
pause