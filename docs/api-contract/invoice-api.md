# Invoice API

Base URL: `https://mobile-savor-street.vercel.app/api/v1`

## GET /invoices/{id_invoice}

Rincian tagihan. `id_invoice` didapat dari response
`POST /orders/{id}/request-bill`.

**Response 200 (`data`)**

```json
{
  "id_invoice": 7,
  "id_pemesanan": 10,
  "nomor_meja": "01",
  "nama_pelanggan": "Arjun",
  "status": "requested",
  "total_harga": 160500,
  "items": [
    {
      "nama_menu": "Tomato Onion Fried Rice",
      "jumlah": 2,
      "harga_satuan": 75000,
      "subtotal": 150000,
      "catatan": "",
      "opsi": [ { "nama_opsi": "Extra Spicy", "harga_tambahan": 0 } ]
    }
  ],
  "created_at": "2026-07-03T12:05:00"
}
```

Status invoice: `requested` → `paid` | `cancelled`.
Pembayaran dilakukan manual ke kasir — tidak ada payment gateway;
status `paid` diubah oleh sisi kasir, bukan oleh aplikasi customer.
