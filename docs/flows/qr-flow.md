# QR Flow

QR Code digunakan untuk mengidentifikasi meja secara aman menggunakan token unik.

## Isi QR Code

QR Code tidak hanya menyimpan nomor meja, tetapi menyimpan token unik.

Contoh isi QR:

```text
savorstreet://table?token=QR-TABLE-001-A9F2K1
```

atau dalam bentuk URL:

```text
https://savorstreet.app/table?token=QR-TABLE-001-A9F2K1
```

## Alur Validasi QR

```text
Customer scan QR
↓
Mobile app membaca token
↓
Mobile app mengirim token ke backend
↓
Backend mengecek token di tabel meja
↓
Jika valid, backend mengembalikan data meja
↓
Mobile app menyimpan table session
↓
Customer diarahkan ke menu
```

## Kondisi Valid

- Token ditemukan di database.
- Status meja aktif.
- Response mengandung `table_id`, `table_number`, dan `qr_token`.

## Kondisi Tidak Valid

- Token kosong.
- Token tidak ditemukan.
- Meja tidak aktif.
- Format QR tidak sesuai.

## Contoh Response Valid

```json
{
  "success": true,
  "message": "QR token valid.",
  "data": {
    "table_id": 1,
    "table_number": "M01",
    "qr_token": "QR-TABLE-001-A9F2K1",
    "status": "active"
  }
}
```
