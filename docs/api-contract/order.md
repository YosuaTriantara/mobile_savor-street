# API Contract - Order

## Create Order

```http
POST /api/v1/orders
```

### Request Body

```json
{
  "table_id": 1,
  "customer_name": "Customer M01",
  "items": [
    {
      "id_menu": 1,
      "jumlah": 2,
      "catatan": "Tidak pakai bawang.",
      "options": [1, 6, 7]
    },
    {
      "id_menu": 16,
      "jumlah": 1,
      "catatan": "Es sedikit.",
      "options": []
    }
  ]
}
```

### Field Explanation

| Field | Type | Required | Description |
|---|---|---:|---|
| `table_id` | int | Yes | ID meja hasil validasi QR |
| `customer_name` | string | No | Nama customer opsional |
| `items` | array | Yes | Daftar item pesanan |
| `id_menu` | int | Yes | ID menu |
| `jumlah` | int | Yes | Jumlah item |
| `catatan` | string | No | Catatan khusus |
| `options` | array[int] | No | Daftar ID opsi customization |

### Success Response

```json
{
  "success": true,
  "message": "Pesanan berhasil dibuat.",
  "data": {
    "id_pemesanan": 1,
    "table_id": 1,
    "table_number": "M01",
    "status": "ordered",
    "total_item": 3,
    "subtotal": 68000,
    "created_at": "2026-06-01T10:00:00"
  }
}
```

### Error Response

```json
{
  "success": false,
  "message": "Pesanan gagal dibuat.",
  "errors": {
    "items": "Minimal satu item harus dipesan."
  }
}
```
