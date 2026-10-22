@echo off
setlocal
cd /d "%~dp0..\.."
where flutter >nul 2>&1
if errorlevel 1 (
  echo Instale o Flutter e adicione ao PATH. Veja docs\COMO_EXECUTAR.md.
  pause
  exit /b 1
)
call flutter pub get
if errorlevel 1 goto falha
call dart format --output=none --set-exit-if-changed lib test
if errorlevel 1 goto falha
call flutter analyze
if errorlevel 1 goto falha
call flutter test
if errorlevel 1 goto falha
echo Todos os testes passaram.
pause
exit /b 0
:falha
echo Verifique o erro apresentado acima.
pause
exit /b 1
