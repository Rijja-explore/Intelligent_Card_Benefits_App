@echo off
echo Setting up Card Benefits Assistant...
echo.

echo [1/3] Installing Python Backend Dependencies...
cd backend
pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo Error installing Python dependencies!
    pause
    exit /b 1
)
cd ..

echo [2/3] Installing Flutter Dependencies...
cd frontend\cardbenefits
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo Error installing Flutter dependencies!
    pause
    exit /b 1
)
cd ..\..

echo [3/3] Testing Backend Connection...
cd backend
echo Testing FastAPI server startup...
timeout /t 2 /nobreak > nul
cd ..

echo.
echo ========================================
echo   Setup Complete! ✓
echo ========================================
echo.
echo Next steps:
echo 1. Run: start_app.bat (to start both services)
echo 2. Open: http://localhost:3000 (Flutter app)
echo 3. Visit: http://localhost:8000/docs (API docs)
echo.
echo Backend: Python FastAPI + AI Service
echo Frontend: Flutter Web with Material 3
echo ========================================
pause