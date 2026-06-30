from pathlib import Path
from sqlalchemy import text
from app.core.db import engine, Base
from app import models  

SCHEMA_PATH = Path(__file__).resolve().parent.parent / "database" / "seeds" / "002_seed_meja.sql"

with open(SCHEMA_PATH, "r", encoding="utf-8") as file:
    sql = file.read()

statements = [
    stmt.strip()
    for stmt in sql.split(";")
    if stmt.strip()
]

with engine.begin() as conn:
    for statement in statements:
        conn.execute(text(statement))

print("Database berhasil dibuat.")