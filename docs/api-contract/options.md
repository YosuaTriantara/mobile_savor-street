# API Contract - Customization Options

## Get Options

```http
GET /api/v1/options
```

### Success Response

```json
{
  "success": true,
  "message": "Opsi berhasil diambil.",
  "data": [
    {
      "id_opsi": 1,
      "nama_opsi": "Tidak Pedas",
      "tipe_opsi": "spicy_level",
      "harga_tambahan": 0,
      "status": "active"
    },
    {
      "id_opsi": 6,
      "nama_opsi": "Large",
      "tipe_opsi": "portion_size",
      "harga_tambahan": 5000,
      "status": "active"
    }
  ]
}
```

## Tipe Opsi

| Tipe | Keterangan |
|---|---|
| `spicy_level` | Tingkat kepedasan |
| `portion_size` | Ukuran porsi |
| `topping` | Tambahan topping |
| `note` | Catatan khusus dari customer |
