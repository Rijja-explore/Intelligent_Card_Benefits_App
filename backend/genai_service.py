import os
import json
import google.generativeai as genai
from dotenv import load_dotenv
from retrieval import retrieve_relevant_benefits


# Load environment variables
load_dotenv()

# Configure Gemini
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Use fast & free-tier friendly model
model = genai.GenerativeModel("gemini-1.5-flash")


def generate_ai_response(benefits, user_context, language="English"):

    # 🔹 RAG RETRIEVAL STEP
    retrieved_benefits = retrieve_relevant_benefits(benefits, user_context)

    prompt = f"""
You are an intelligent banking assistant.

IMPORTANT RULE:
- Use ONLY the benefits provided below.
- Do NOT assume or add information outside this data.

User Context:
- User type: {user_context.get("user_type")}
- Location: {user_context.get("location")}
- Language: {language}

Tasks:
1. Summarize the benefits in simple language.
2. Recommend the single most useful benefit.
3. Explain why it is useful.
4. Respond in {language}.

Retrieved Benefits (Ground Truth):
{retrieved_benefits}
"""
    response = model.generate_content(prompt)
    
    return {
        "ai_response": response.text,
        "user_context": user_context,
        "language": language,
        "retrieved_benefits": retrieved_benefits
    }