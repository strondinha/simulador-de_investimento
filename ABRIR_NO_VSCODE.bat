@echo off
setlocal
cd /d "%~dp0"
where code >nul 2>&1
if errorlevel 1 (
  echo Abra o VS Code e use Arquivo, Abrir Pasta.
  echo Escolha a pasta simulador_investimentos que contem pubspec.yaml.
  pause
  exit /b 1
)
call code --reuse-window "%~dp0Simulador_Investimentos.code-workspace"
