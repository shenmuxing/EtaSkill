@echo off
setlocal

set "ENV_NAME=DEEPSEEK_API_KEY"
if not "%~1"=="" set "ENV_NAME=%~1"

echo This script stores a DeepSeek API key in your Windows user environment.
echo Do not paste the key into chat or pass it as a command-line argument.
echo.
set /p "DEEPSEEK_KEY=Paste DeepSeek API key, then press Enter: "

if "%DEEPSEEK_KEY%"=="" (
  echo No key entered. Nothing changed.
  exit /b 1
)

setx "%ENV_NAME%" "%DEEPSEEK_KEY%" >nul
if errorlevel 1 (
  echo Failed to set %ENV_NAME%.
  exit /b 1
)

echo %ENV_NAME% was saved to the user environment.
echo Open a new terminal before running verification.
endlocal
