# 🚀 Frontend-Backend Connection Guide

## Overview

The Card Benefits Assistant is now fully connected with:

- **Backend**: FastAPI server with CORS enabled
- **Frontend**: Flutter web app with proper API integration

## 📁 Project Structure

```
Intelligent_Card_Benefits_App/
├── backend/                  # Python FastAPI server
│   ├── main.py              # API endpoints with CORS
│   ├── requirements.txt     # Python dependencies
│   └── ...
├── frontend/cardbenefits/   # Flutter web application
│   ├── lib/
│   │   ├── main.dart       # App entry point
│   │   ├── card_input.dart # Main input form
│   │   ├── ai_result.dart  # Results display
│   │   ├── disclaimer.dart # About page
│   │   └── api_config.dart # API configuration
│   └── ...
├── setup.bat               # Automated setup script
└── start_app.bat          # Automated startup script
```

## 🔧 Quick Setup

### Option 1: Automated Setup (Recommended)

```bash
# 1. Run setup script
./setup.bat

# 2. Start both services
./start_app.bat
```

### Option 2: Manual Setup

```bash
# Backend setup
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload --port 8000

# Frontend setup (new terminal)
cd frontend/cardbenefits
flutter pub get
flutter run -d web-server --web-port 3000
```

## 🌐 Service URLs

| Service         | URL                        | Purpose                       |
| --------------- | -------------------------- | ----------------------------- |
| **Frontend**    | http://localhost:3000      | Flutter web app               |
| **Backend API** | http://localhost:8000      | FastAPI server                |
| **API Docs**    | http://localhost:8000/docs | Interactive API documentation |

## 🔌 API Integration

### Backend Endpoints

- `POST /genai` - Generate AI recommendations
- `GET /` - Health check
- `GET /benefits` - Get benefits data
- `GET /docs` - API documentation

### Frontend Configuration

The Flutter app uses `api_config.dart` for centralized API configuration:

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';
  static String get genaiUrl => '$baseUrl/genai';
}
```

### Request Flow

1. User fills form in `CardInputPage`
2. Frontend validates input
3. HTTP POST to `/genai` endpoint
4. Backend processes with AI service
5. Frontend displays results in `ResultPage`

## 🛠 Connection Features

### Backend (FastAPI)

✅ **CORS middleware** - Allows frontend connections  
✅ **Pydantic validation** - Type-safe request/response  
✅ **Error handling** - Proper HTTP status codes  
✅ **API documentation** - Auto-generated with Swagger

### Frontend (Flutter)

✅ **Centralized API config** - Easy URL management  
✅ **Enhanced error handling** - Network and server errors  
✅ **Loading states** - User feedback during requests  
✅ **Input validation** - Form validation before API calls

## 🔒 Security & Production

### Development

- CORS allows all origins (`allow_origins=["*"]`)
- No authentication required
- Local development only

### Production Checklist

- [ ] Update CORS to specific origins
- [ ] Add authentication middleware
- [ ] Use HTTPS for API calls
- [ ] Update `ApiConfig.baseUrl` to production URL
- [ ] Enable API rate limiting

## 🐛 Troubleshooting

### Common Issues

**Frontend can't connect to backend:**

- Ensure backend is running on port 8000
- Check CORS configuration in `backend/main.py`
- Verify API URL in `api_config.dart`

**Backend not starting:**

- Install dependencies: `pip install -r requirements.txt`
- Check Python version compatibility
- Verify port 8000 is available

**Flutter web not loading:**

- Run `flutter pub get`
- Enable web support: `flutter config --enable-web`
- Check port 3000 availability

### Debug Commands

```bash
# Test backend directly
curl -X POST http://localhost:8000/genai \
  -H "Content-Type: application/json" \
  -d '{"user_context":{"user_type":"Student","location":"Chennai"},"language":"English"}'

# Check backend health
curl http://localhost:8000/

# Flutter debug mode
flutter run -d web-server --web-port 3000 --debug
```

## 📱 Usage Flow

1. **Setup**: Run `setup.bat` to install dependencies
2. **Start**: Run `start_app.bat` to launch both services
3. **Access**: Open http://localhost:3000 in your browser
4. **Input**: Fill the card benefits form
5. **Analyze**: Click "Analyze Benefits"
6. **Results**: View AI-generated recommendations
7. **Navigate**: Use info button for disclaimer

The application is now fully connected and ready for development! 🎉
