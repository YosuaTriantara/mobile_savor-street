# API Contract - Invoice / Request Bill

Pembayaran dilakukan manual kepada kasir. API invoice hanya digunakan untuk request bill dan menampilkan rincian tagihan.

## Request Bill

```http
POST /api/v1/invoices/request
```

### Request Body

```json
{
  "id_pemesanan": 1
}
```

### Success Response

```json
{
  "success": true,
  "message": "Request bill berhasil dibuat.",
  "data": {
    "id_invoice": 1,
    "id_pemesanan": 1,
    "status": "requested",
    "total_harga": 68000
  }
}
```

## Get Invoice Detail

```http
GET /api/v1/invoices/{id_invoice}
```

### Success Response

```json
{
  "success": true,
  "message": "Invoice berhasil diambil.",
  "data": {
    "id_invoice": 1,
    "id_pemesanan": 1,
    "table_number": "M01",
    "status": "requested",
    "items": [
      {
        "id_menu": 1,
        "nama_menu": "Nasi Goreng Savor",
        "harga_satuan": 25000,
        "jumlah": 2,
        "options": [
          {"nama_opsi": "Pedas Level 2", "harga_tambahan": 0},
          {"nama_opsi": "Large", "harga_tambahan": 5000}
        ],
        "catatan": "Tidak pakai bawang.",
        "subtotal": 60000
      },
      {
        "id_menu": 16,
        "nama_menu": "Iced Tea",
        "harga_satuan": 10000,
        "jumlah": 1,
        "options": [],
        "catatan": "Es sedikit.",
        "subtotal": 10000
      }
    ],
    "total_harga": 70000,
    "payment_method": "Manual ke kasir"
  }
}
```
