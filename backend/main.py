from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from data_loader import load_benefits, load_features, load_terms
from genai_service import generate_ai_response

app = FastAPI(
    title="Intelligent Card Benefits AI Backend",
    description="Awareness-only banking benefit assistant",
    version="1.0"
)

# Add CORS middleware to allow Flutter frontend connections
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models for request validation
class UserContext(BaseModel):
    user_type: str
    location: str

class GenAIRequest(BaseModel):
    user_context: UserContext
    language: str

@app.get("/")
def root():
    return {"status": "Backend running successfully"}

@app.get("/benefits")
def get_benefits():
    return load_benefits()

@app.get("/features")
def get_features():
    return load_features()

@app.get("/terms")
def get_terms():
    return {"terms": load_terms()}

@app.post("/analyze")
def analyze_user(context: dict):
    """
    This endpoint will later connect to GenAI.
    For now, it returns benefits + user context.
    """
    benefits = load_benefits()
    return {
        "user_context": context,
        "benefits": benefits[:3],  # sample
        "message": "GenAI integration comes next"
    }

@app.post("/genai")
def genai_endpoint(payload: GenAIRequest):
    """
    Generate AI-powered card benefit recommendations
    """
    benefits = load_benefits()

    ai_response = generate_ai_response(
        benefits=benefits,
        user_context=payload.user_context.dict(),
        language=payload.language
    )

    return ai_response
