import requests
from bs4 import BeautifulSoup

import json
import os
from pathlib import Path

# Get absolute path to dataset folder
DATASET_DIR = Path(__file__).resolve().parent.parent / "dataset"
os.makedirs(DATASET_DIR, exist_ok=True)

HEADERS = {
    "User-Agent": "Mozilla/5.0"
}

BENEFIT_URLS = [
    "https://www.bankbazaar.com/credit-card.html",
    "https://www.bankbazaar.com/credit-card/rewards-credit-card-in-india.html",
    "https://www.bankbazaar.com/credit-card-offers.html",
    "https://www.bankbazaar.com/hdfc-credit-card.html",
    "https://www.bankbazaar.com/yes-bank-credit-card.html",
    "https://www.bankbazaar.com/rbl-bank-credit-card.html",
    "https://www.bankbazaar.com/sbi-credit-card.html"
]

def scrape_benefits():
    benefits = []
    for url in BENEFIT_URLS:
        print(f"Scraping: {url}")
        resp = requests.get(url, headers=HEADERS)
        soup = BeautifulSoup(resp.text, "html.parser")

        # Extract headings and paragraphs
        for h in soup.find_all(["h1", "h2", "h3"]):
            title = h.get_text(strip=True)
            # Get next paragraph or list
            next_p = h.find_next_sibling("p")
            next_ul = h.find_next_sibling("ul")
            if next_p:
                benefits.append({
                    "benefit_name": title,
                    "description": next_p.get_text(strip=True),
                    "source": url
                })
            if next_ul:
                for li in next_ul.find_all("li"):
                    benefits.append({
                        "benefit_name": title,
                        "description": li.get_text(strip=True),
                        "source": url
                    })

        # Also extract standalone paragraphs and list items
        for p in soup.find_all("p"):
            txt = p.get_text(strip=True)
            if len(txt) > 50:
                benefits.append({
                    "benefit_name": "General Info",
                    "description": txt,
                    "source": url
                })
        for li in soup.find_all("li"):
            txt = li.get_text(strip=True)
            if len(txt) > 30:
                benefits.append({
                    "benefit_name": "List Item",
                    "description": txt,
                    "source": url
                })

    with open(DATASET_DIR / "benefits.json", "w", encoding="utf-8") as f:
        json.dump(benefits, f, indent=2, ensure_ascii=False)
    print("✅ benefits.json created")



# ---------- 2. SCRAPE FEATURES ----------
def scrape_features():
    features = []
    for url in BENEFIT_URLS:
        print(f"Scraping features: {url}")
        resp = requests.get(url, headers=HEADERS)
        soup = BeautifulSoup(resp.text, "html.parser")

        for h in soup.find_all(["h1", "h2", "h3"]):
            title = h.get_text(strip=True)
            next_p = h.find_next_sibling("p")
            next_ul = h.find_next_sibling("ul")
            if next_p:
                features.append({
                    "feature_name": title,
                    "description": next_p.get_text(strip=True),
                    "source": url
                })
            if next_ul:
                for li in next_ul.find_all("li"):
                    features.append({
                        "feature_name": title,
                        "description": li.get_text(strip=True),
                        "source": url
                    })

        for p in soup.find_all("p"):
            txt = p.get_text(strip=True)
            if len(txt) > 50:
                features.append({
                    "feature_name": "General Info",
                    "description": txt,
                    "source": url
                })
        for li in soup.find_all("li"):
            txt = li.get_text(strip=True)
            if len(txt) > 30:
                features.append({
                    "feature_name": "List Item",
                    "description": txt,
                    "source": url
                })

    with open(DATASET_DIR / "features.json", "w", encoding="utf-8") as f:
        json.dump(features, f, indent=2, ensure_ascii=False)
    print("✅ features.json created")



# ---------- 3. SCRAPE TERMS & CONDITIONS ----------
def scrape_terms():
    terms = []
    for url in BENEFIT_URLS:
        print(f"Scraping terms: {url}")
        resp = requests.get(url, headers=HEADERS)
        soup = BeautifulSoup(resp.text, "html.parser")

        for h in soup.find_all(["h1", "h2", "h3"]):
            title = h.get_text(strip=True)
            if "term" in title.lower() or "condition" in title.lower():
                next_p = h.find_next_sibling("p")
                if next_p:
                    terms.append(title + ":\n" + next_p.get_text(strip=True))
        for p in soup.find_all("p"):
            txt = p.get_text(strip=True)
            if "term" in txt.lower() or "condition" in txt.lower():
                terms.append(txt)

    terms_text = "\n\n".join(terms)
    with open(DATASET_DIR / "terms_raw.txt", "w", encoding="utf-8") as f:
        f.write(terms_text)
    print("✅ terms_raw.txt created")


# ---------- RUN ALL ----------
if __name__ == "__main__":
    scrape_benefits()
    scrape_features()
    scrape_terms()
    print("\n🎉 ALL REQUIRED DATASETS SCRAPED SUCCESSFULLY")
