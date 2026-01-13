import os
import json
import google.generativeai as genai
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure Gemini
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Use fast & free-tier friendly model
model = genai.GenerativeModel("gemini-1.5-flash")


def generate_ai_response(benefits, user_context, language="English"):
    prompt = f"""
You are an intelligent banking assistant.

User Context:
- User type: {user_context.get("user_type")}
- Location: {user_context.get("location")}
- Preferred Language: {language}

Tasks:
1. Summarize the banking benefits in simple language.
2. Recommend the single most useful benefit for this user.
3. Explain why it is useful.
4. Respond in {language}.

Banking Benefits Data:
{json.dumps(benefits[:5], indent=2)}
"""

    try:
        response = model.generate_content(prompt)
        return {
            "ai_response": response.text,
            "language": language
        }

    except Exception as e:
        # Fallback (VERY IMPORTANT for demos)
        return {
            "ai_response": "AI service is temporarily unavailable. Please try again later.",
            "error": str(e)
        }
