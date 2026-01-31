@echo off
echo Starting Card Benefits Assistant...
echo.

echo [1/2] Starting Backend Server...
cd backend
start "Backend Server" cmd /k "python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000"
cd ..

echo [2/2] Waiting for backend to start...
timeout /t 3 /nobreak > nul

echo Starting Flutter Frontend...
cd frontend\cardbenefits
start "Flutter Frontend" cmd /k "flutter run -d web-server --web-port 3000"
cd ..\..

echo.
echo ===================================
echo   Card Benefits Assistant Started
echo ===================================
echo Backend:  http://localhost:8000
echo Frontend: http://localhost:3000
echo API Docs: http://localhost:8000/docs
echo ===================================
echo.
echo Both services are running in separate windows.
echo Close this window or press Ctrl+C to stop.
pause