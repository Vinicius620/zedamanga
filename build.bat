@echo off
setlocal
cd /d "%~dp0"

where cmake >nul 2>nul
if errorlevel 1 (
  echo CMake nao foi encontrado no PATH.
  echo Instale o CMake e tente novamente.
  exit /b 1
)

if not exist build mkdir build

cmake -S . -B build -G "Visual Studio 17 2022"
if errorlevel 1 (
  echo Visual Studio generator nao encontrado. Tentando Ninja...
  cmake -S . -B build -G "Ninja"
)
if errorlevel 1 (
  echo Falha ao configurar o projeto.
  exit /b %errorlevel%
)

cmake --build build --config Release
if errorlevel 1 (
  echo Falha ao compilar o projeto.
  exit /b %errorlevel%
)

echo.
echo Build concluido.
echo Arquivos gerados:
echo   build\Release\esp_aim.exe
if exist build\Release\core_tests.exe echo   build\Release\core_tests.exe
if exist build\Release\kalashvini.exe echo   build\Release\kalashvini.exe
if exist build\esp_aim.exe echo   build\esp_aim.exe
if exist build\kalashvini.exe echo   build\kalashvini.exe

echo.
echo Para testar o modo sintetico:
echo   .\build\Release\esp_aim.exe --synthetic

echo Para abrir o overlay:
echo   .\build\Release\kalashvini.exe --run-for-ms 2000 --fov 30 --hfov 90
exit /b 0
