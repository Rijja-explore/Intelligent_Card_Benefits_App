import json
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
DATASET_DIR = BASE_DIR / "dataset"

def load_benefits():
    with open(DATASET_DIR / "benefits.json", encoding="utf-8") as f:
        return json.load(f)

def load_features():
    with open(DATASET_DIR / "features.json", encoding="utf-8") as f:
        return json.load(f)

def load_terms():
    with open(DATASET_DIR / "terms_raw.txt", encoding="utf-8") as f:
        return f.read()
