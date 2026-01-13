from fastapi import FastAPI
from data_loader import load_benefits, load_features, load_terms

app = FastAPI(
    title="Intelligent Card Benefits AI Backend",
    description="Awareness-only banking benefit assistant",
    version="1.0"
)

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
def genai_endpoint(payload: dict):
    user_context = payload.get("user_context", {})
    language = payload.get("language", "English")

    benefits = load_benefits()

    ai_response = generate_ai_response(
        benefits=benefits,
        user_context=user_context,
        language=language
    )

    return ai_response
