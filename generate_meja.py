import secrets
from pathlib import Path

import qrcode


JUMLAH_MEJA = 15
BASE_URL = "http://localhost:8000"

OUTPUT_DIR = Path(__file__).resolve().parent
QR_DIR = OUTPUT_DIR / "qr_codes"
SQL_PATH = OUTPUT_DIR.parent / "database" / "seeds" / "002_seed_meja.sql"

# GENERATE

def generate_token() -> str:
    return secrets.token_urlsafe(32)


def main() -> None:
    QR_DIR.mkdir(parents=True, exist_ok=True)
    SQL_PATH.parent.mkdir(parents=True, exist_ok=True)

    rows = []
    for i in range(1, JUMLAH_MEJA + 1):
        nomor_meja = f"{i:02d}"
        token = generate_token()
        url = f"{BASE_URL}?table={token}"

        # Buat & simpan QR code
        img = qrcode.make(url)
        img.save(QR_DIR / f"meja-{nomor_meja}.png")

        rows.append((nomor_meja, token))
        print(f"meja-{nomor_meja}  token={token}")

    # Tulis SQL seed
    lines = [
        "-- =====================================================================",
        "-- SEED DATA: meja",
        "-- Di-generate otomatis oleh generate_meja_seed.py",
        "-- qr_token acak (secrets.token_urlsafe), JANGAN diturunkan dari nomor_meja.",
        "-- Gambar QR code untuk tiap meja ada di folder qr_codes/ (untuk testing scan).",
        "-- =====================================================================",
        "",
        "INSERT INTO meja (nomor_meja, qr_token, status) VALUES",
    ]
    value_lines = [
        f"('{nomor}', '{token}', 'active')" for nomor, token in rows
    ]
    lines.append(",\n".join(value_lines) + ";")

    SQL_PATH.write_text("\n".join(lines), encoding="utf-8")

    print(f"\nSelesai. {JUMLAH_MEJA} QR code disimpan di: {QR_DIR}")
    print(f"SQL seed ditulis ke: {SQL_PATH}")


if __name__ == "__main__":
    main()
