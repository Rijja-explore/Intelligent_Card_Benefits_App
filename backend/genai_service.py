import os
import json
import google.generativeai as genai
from dotenv import load_dotenv
from retrieval import retrieve_relevant_benefits


# Load environment variables
load_dotenv()

# Check if we should use mock responses
USE_MOCK = os.getenv("USE_MOCK_RESPONSES", "false").lower() == "true"
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

# Configure Gemini only if API key is available
if GEMINI_API_KEY and GEMINI_API_KEY != "your_gemini_api_key_here" and not USE_MOCK:
    genai.configure(api_key=GEMINI_API_KEY)
    model = genai.GenerativeModel("gemini-1.5-flash")
else:
    model = None
    print("⚠️  Using mock AI responses (no valid GEMINI_API_KEY found)")


def generate_ai_response(benefits, user_context, language="English"):

    # 🔹 RAG RETRIEVAL STEP
    retrieved_benefits = retrieve_relevant_benefits(benefits, user_context)

    # Use mock response if no API key or mock is enabled
    if model is None or USE_MOCK:
        return generate_mock_response(user_context, language, retrieved_benefits)

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
    
    try:
        response = model.generate_content(prompt)
        return {
            "response": response.text,
            "user_context": user_context,
            "language": language,
            "retrieved_benefits": retrieved_benefits
        }
    except Exception as e:
        print(f"AI API Error: {e}")
        return generate_mock_response(user_context, language, retrieved_benefits)


def generate_mock_response(user_context, language, retrieved_benefits):
    """Generate a mock AI response for demonstration purposes"""
    
    user_type = user_context.get("user_type", "User")
    location = user_context.get("location", "your area")
    
    if language == "Tamil":
        response_text = f"""
## 🏦 உங்கள் கார்டு நன்மைகள் - {user_type}

### தனிப்பயனாக்கப்பட்ட பரிந்துரை:
{user_type} என்ற நிலையில், {location} இல் வசிக்கும் உங்களுக்கு இந்த நன்மைகள் மிகவும் பயனுள்ளதாக இருக்கும்:

• **கேஷ்பேக் ரிவார்ட்ஸ்**: தினசரி வாங்குதலில் 2-5% கேஷ்பேக்
• **டிஜிட்டல் வாலட் ஆஃபர்கள்**: UPI மற்றும் டிஜிட்டல் பேமெண்ட்களில் கூடுதல் புள்ளிகள்
• **ஆன்லைன் ஷாப்பிங்**: முக்கிய இ-காமர்ஸ் தளங்களில் தள்ளுபடி

### ஏன் இது பயனுள்ளது:
இந்த நன்மைகள் உங்கள் வாழ்க்கை முறை மற்றும் செலவு பழக்கங்களுக்கு ஏற்ப வடிவமைக்கப்பட்டுள்ளன.

*⚠️ இது கல்வி நோக்கத்திற்கான AI-generated பதில்*
        """
    else:
        response_text = f"""
## 🏦 Your Personalized Card Benefits - {user_type}

### Recommended Benefits for You:
Based on your profile as a {user_type} in {location}, here are the most relevant benefits:

• **Cashback Rewards**: Earn 2-5% cashback on everyday purchases
• **Digital Wallet Offers**: Extra points for UPI and digital payments  
• **Online Shopping**: Discounts on major e-commerce platforms
• **Fuel Surcharge Waiver**: Save on fuel purchases
• **Airport Lounge Access**: Complimentary access at select locations

### Why These Benefits Matter:
As a {user_type}, these benefits are tailored to your lifestyle and spending patterns. The cashback rewards provide immediate value on daily expenses, while digital payment incentives align with modern payment preferences.

### Usage Tips:
1. Maximize cashback by using the card for regular expenses
2. Take advantage of online offers during sales
3. Use digital payments for additional rewards

*⚠️ This is a demo AI response for educational purposes only*
        """
    
    return {
        "response": response_text,
        "user_context": user_context,
        "language": language,
        "retrieved_benefits": retrieved_benefits,
        "mock": True
    }