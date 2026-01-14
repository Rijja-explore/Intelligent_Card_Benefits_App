def retrieve_relevant_benefits(benefits, user_context):
    """
    Simple RAG Retrieval:
    Filters benefits based on user type & location keywords
    """

    user_type = user_context.get("user_type", "").lower()
    location = user_context.get("location", "").lower()

    relevant = []

    for benefit in benefits:
        text = (benefit.get("benefit_name", "") + benefit.get("description", "")).lower()

        # Student-focused retrieval
        if user_type == "student" and any(
            kw in text for kw in ["reward", "cashback", "fuel", "discount"]
        ):
            relevant.append(benefit)

        # Location / travel relevance
        elif "travel" in text or "lounge" in text:
            relevant.append(benefit)

    # Fallback if nothing matched
    if not relevant:
        relevant = benefits[:3]

    # Limit context size (important for GenAI)
    return relevant[:5]
