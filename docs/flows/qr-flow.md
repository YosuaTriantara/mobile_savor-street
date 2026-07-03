# QR Flow

QR Code digunakan untuk mengidentifikasi meja secara aman menggunakan token unik.

## Isi QR Code

QR Code tidak menyimpan nomor meja, tetapi token unik acak
(`secrets.token_urlsafe(32)`, di-generate oleh `generate_meja.py`).

Isi QR produksi berbentuk URL dengan query param `table`:

```text
http://localhost:8000?table=bran9FoHykTngrx1o6hecOxs_ZJe_aJq0z8fksC-8Sk
```

Parser di aplikasi (`features/qr/data/qr_token_parser.dart`) toleran terhadap
tiga bentuk:

1. URL dengan `?table=<token>` — format produksi saat ini.
2. URL dengan `?token=<token>` — format alternatif/lama.
3. Raw token langsung — dipakai juga oleh input token manual.

## Alur Validasi QR

```text
Customer scan QR (QrScanScreen, mobile_scanner)
↓
extractQrToken() membaca token dari isi QR
↓
GET /tables/validate?token=<token>
↓
Backend mengecek token di tabel meja
↓
Jika valid → TableSessionNotifier.start(idMeja, nomorMeja)
↓
Router guard terbuka, customer diarahkan ke /menu
```

Jika session belum ada, redirect di `app_router.dart` memaksa semua route
kembali ke `/` (QR scan) — order tidak mungkin terkirim tanpa meja valid.

## Kondisi Valid

- Token ditemukan di database.
- Status meja `active`.

**Response 200:**

```json
{
  "success": true,
  "message": "QR berhasil divalidasi",
  "data": {
    "id_meja": 1,
    "nomor_meja": "01",
    "status": "active"
  }
}
```

## Kondisi Tidak Valid

| Kondisi | HTTP | Message |
|---|---|---|
| Format QR tidak dikenali | — (lokal, tidak ke server) | "QR tidak dikenali..." |
| Token tidak ditemukan | 404 | "QR meja tidak ditemukan" |
| Meja nonaktif | 400 | "Meja sedang tidak aktif" |

## Fallback Tanpa Kamera

Tombol **"Masukkan Token Manual"** membuka bottom sheet untuk mengetik token —
dipakai saat testing di emulator atau ketika kamera bermasalah. Token manual
melewati jalur validasi yang sama dengan hasil scan.

## QR untuk Testing

Gambar QR tiap meja ada di folder `qr_codes/` (meja-01 s.d. meja-15).
Token di dalamnya sudah sinkron dengan database production
(diverifikasi 3 Juli 2026). Jika `generate_meja.py` dijalankan ulang,
database harus di-seed ulang agar tetap sinkron.
