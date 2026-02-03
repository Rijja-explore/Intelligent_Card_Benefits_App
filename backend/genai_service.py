import os
import json
from dotenv import load_dotenv
from google import genai
from retrieval import retrieve_relevant_benefits

# Load environment variables
load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise RuntimeError("GEMINI_API_KEY not found")

# Configure Gemini client
client = genai.Client(api_key=API_KEY)

def generate_ai_response(benefits, user_context, language="English"):
    # 🔹 RAG: Retrieve relevant benefits
    retrieved = retrieve_relevant_benefits(benefits, user_context)

    prompt = f"""
You are an intelligent banking assistant.

STRICT RULE:
- Use ONLY the benefits provided below.
- Do NOT assume anything outside this data.

User Context:
{user_context}

Tasks:
1. Summarize the benefits in simple language.
2. Recommend the most useful benefit.
3. Explain why it is useful.
4. Respond in {language}.

Retrieved Benefits:
{json.dumps(retrieved, indent=2)}
"""

    response = client.models.generate_content(
        model="gemini-1.5-flash",
        contents=prompt
    )

    return {
        "ai_response": response.text,
        "language": language
    }
