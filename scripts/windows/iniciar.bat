@echo off
setlocal
cd /d "%~dp0..\.."
set "navegador=chrome"
if /i "%~1"=="edge" set "navegador=edge"
where flutter >nul 2>&1
if errorlevel 1 (
  echo Flutter nao encontrado no PATH.
  echo Consulte docs\INSTALAR_FLUTTER_WINDOWS.md.
  pause
  exit /b 1
)
call flutter pub get
if errorlevel 1 goto falha
call flutter run -d %navegador% --no-web-resources-cdn
if errorlevel 1 goto falha
exit /b 0
:falha
echo Nao foi possivel iniciar. Confira a mensagem acima.
echo Para usar Edge: scripts\windows\iniciar.bat edge
echo Consulte docs\COMO_EXECUTAR.md.
pause
exit /b 1
