@echo off
setlocal EnableDelayedExpansion
title Paso 2 - Inicializar Git y conectar repositorio remoto
color 1F

echo ================================================
echo PASO 2 - Inicializar Git y conectar repositorio
echo ================================================
echo.
echo Este paso NO hace push.
echo Solo deja Git inicializado y el remoto origin configurado.
echo.

set /p PROJECT_PATH=Ingresa la ruta completa del proyecto (ej: C:\temp\mvp-dataops-docente): 
if "%PROJECT_PATH%"=="" (
  echo [ERROR] Debes indicar una ruta.
  pause
  exit /b 1
)

if not exist "%PROJECT_PATH%" (
  echo [ERROR] La ruta no existe: %PROJECT_PATH%
  pause
  exit /b 1
)

cd /d "%PROJECT_PATH%"
echo.
echo Carpeta actual:
cd

echo.
set /p REPO_URL=Ingresa la URL HTTPS del repositorio GitHub (ej: https://github.com/mfiguer/mvp-dataops-docente.git): 
if "%REPO_URL%"=="" (
  echo [ERROR] Debes indicar la URL del repositorio.
  pause
  exit /b 1
)

echo.
echo Verificando Git...
git --version >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Git no esta instalado o no esta disponible en PATH.
  pause
  exit /b 1
)

echo.
echo Inicializando repositorio local...
if exist ".git" (
  echo [INFO] Ya existe una carpeta .git. Se mantendra la configuracion existente.
) else (
  git init
  if errorlevel 1 (
    echo [ERROR] No se pudo ejecutar git init.
    pause
    exit /b 1
  )
)

echo.
echo Configurando rama principal como main...
git branch -M main

echo.
echo Configurando remoto origin...
git remote get-url origin >nul 2>&1
if not errorlevel 1 (
  for /f "delims=" %%i in ('git remote get-url origin') do set CURRENT_ORIGIN=%%i
  echo [INFO] Ya existe origin: !CURRENT_ORIGIN!
  echo [INFO] Se reemplazara por: %REPO_URL%
  git remote remove origin
)

git remote add origin %REPO_URL%
if errorlevel 1 (
  echo [ERROR] No se pudo agregar el remoto origin.
  pause
  exit /b 1
)

echo.
echo Estado actual de Git:
git status

echo.
echo Remotos configurados:
git remote -v

echo.
echo ================================================
echo Paso 2 completado.
echo Git quedo inicializado y el remoto origin configurado.
echo El push se hara en el paso 3.
echo ================================================
pause
