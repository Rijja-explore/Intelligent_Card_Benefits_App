# Intelligent Card Benefits App

A backend service for intelligent awareness of banking card benefits, powered by FastAPI and Google Gemini (GenAI).

---

## Features
- REST API for retrieving credit card benefits, features, and terms
- GenAI-powered endpoint for personalized benefit recommendations
- Data scraping utilities for updating benefits/features from the web
- Modular, production-ready Python codebase

---

## Project Structure

```
backend/
  main.py            # FastAPI app entrypoint
  data_loader.py     # Loads benefits, features, terms from dataset
  genai_service.py   # GenAI integration (Google Gemini)
  retrieval.py       # Simple RAG retrieval logic
  requirements.txt   # Python dependencies

dataset/
  benefits.json      # Scraped benefits data
  features.json      # Scraped features data
  terms_raw.txt      # Raw terms text

scraper/
  scrape_benefits.py # Web scraper for benefits/features
```

---

## Setup & Installation

### 1. Clone the Repository
```bash
# Clone the repo
$ git clone <repo-url>
$ cd Intelligent_Card_Benefits_App
```

### 2. Create & Activate Virtual Environment
```bash
# Windows
$ python -m venv .venv
$ .venv\Scripts\activate
```

### 3. Install Dependencies
```bash
$ pip install -r backend/requirements.txt
$ pip install httpx  # For testing
```

### 4. Environment Variables
Create a `.env` file in the `backend/` folder with your Gemini API key:
```
GEMINI_API_KEY=your_google_gemini_api_key
```

---

## Running the Backend

```bash
$ cd backend
$ uvicorn main:app --reload
```

- API will be available at: http://localhost:8000
- Interactive docs: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

---

## API Endpoints

| Endpoint      | Method | Description                                 |
|--------------|--------|---------------------------------------------|
| `/`          | GET    | Health check                                |
| `/benefits`  | GET    | List all card benefits                      |
| `/features`  | GET    | List all card features                      |
| `/terms`     | GET    | Get terms text                              |
| `/analyze`   | POST   | Analyze user context, return sample benefits|
| `/genai`     | POST   | GenAI-powered benefit recommendation        |

---

## Data Scraping

To update benefits/features from the web:
```bash
$ cd scraper
$ python scrape_benefits.py
```
- This will update `dataset/benefits.json` and `dataset/features.json`

---

## Testing

- All endpoints are tested and working (see PROJECT_HEALTH_REPORT.md for details)
- To run API tests, use FastAPI's built-in docs or write tests using `fastapi.testclient`

---

## Notes & Recommendations
- The project currently uses `google.generativeai` (deprecated). Migrate to `google.genai` soon.
- Ensure `.env` is set up with a valid Gemini API key for GenAI endpoints.
- Data files are pre-populated, but you can re-scrape as needed.

---

## License
MIT
