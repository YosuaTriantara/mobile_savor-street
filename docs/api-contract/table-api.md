# Table API

Base URL: `https://mobile-savor-street.vercel.app/api/v1`

Semua response memakai wrapper standar:

```json
{ "success": true, "message": "...", "data": ... }
```

## GET /tables/validate

Memvalidasi token QR meja dan mengembalikan data meja. Dipakai fitur QR
(`features/qr/`) setelah scan.

**Query Parameter**

| Param | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `token` | string | ya | `qr_token` hasil parsing isi QR code |

**Response 200 — token valid**

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

**Response 404 — token tidak ditemukan**

```json
{ "success": false, "message": "QR meja tidak ditemukan", "errors": {} }
```

**Response 400 — meja nonaktif**

```json
{ "success": false, "message": "Meja sedang tidak aktif", "errors": {} }
```

## Catatan Implementasi Mobile

- Isi QR produksi berbentuk URL `http://localhost:8000?table=<token>`;
  aplikasi mengambil query param `table` (lihat
  `features/qr/data/qr_token_parser.dart`).
- Setelah valid, `id_meja` + `nomor_meja` disimpan ke
  `tableSessionStateProvider` dan dipakai fitur cart/order.
