# Order API

Base URL: `https://mobile-savor-street.vercel.app/api/v1`

## POST /orders

Membuat pesanan baru dari cart.

**Request Body**

```json
{
  "id_meja": 1,
  "nama_pelanggan": "Arjun",
  "items": [
    {
      "id_menu": 1,
      "jumlah": 2,
      "catatan": "Tidak pedas",
      "opsi": [3, 5]
    }
  ]
}
```

| Field | Tipe | Wajib | Keterangan |
|---|---|---|---|
| `id_meja` | int | ya | dari table session hasil scan QR |
| `nama_pelanggan` | string | tidak | boleh null |
| `items` | array | ya, min 1 | |
| `items[].id_menu` | int | ya | |
| `items[].jumlah` | int | ya, > 0 | |
| `items[].catatan` | string | tidak | default `""` |
| `items[].opsi` | int[] | tidak | daftar `id_opsi`, default `[]` |

**Response 200**

```json
{
  "success": true,
  "message": "...",
  "data": { "id_pemesanan": 10, "status": "ordered", "created_at": "2026-07-03T12:00:00" }
}
```

## GET /orders/{id_pemesanan}

**Response 200 (`data`)**

```json
{
  "id_pemesanan": 10,
  "nomor_meja": "01",
  "nama_pelanggan": "Arjun",
  "status": "ordered",
  "tanggal_pemesanan": "2026-07-03T12:00:00",
  "items": [
    {
      "nama_menu": "Tomato Onion Fried Rice",
      "jumlah": 2,
      "harga_satuan": 75000,
      "subtotal": 150000,
      "catatan": "Tidak pedas",
      "opsi": [ { "nama_opsi": "Extra Spicy", "harga_tambahan": 0 } ]
    }
  ]
}
```

Status order: `ordered` → `bill_requested` → `completed` | `cancelled`.

## POST /orders/{id_pemesanan}/request-bill

Meminta tagihan; membuat invoice untuk order tersebut.

**Response 200 (`data`)**

```json
{ "id_invoice": 7, "status": "requested" }
```

`id_invoice` selanjutnya dipakai `GET /invoices/{id_invoice}`.
