# API Contract - Menu

## Get Menu List

```http
GET /api/v1/menus
```

### Optional Query Params

| Name | Type | Required | Description |
|---|---|---:|---|
| `category` | string | No | Filter kategori: Rice, Noodles, Side Dish, Beverage |
| `search` | string | No | Search berdasarkan nama menu |

### Success Response

```json
{
  "success": true,
  "message": "Menu berhasil diambil.",
  "data": [
    {
      "id_menu": 1,
      "nama_menu": "Nasi Goreng Savor",
      "harga": 25000,
      "kategori": "Rice",
      "deskripsi": "Nasi goreng khas Savor Street dengan bumbu gurih dan telur.",
      "gambar_menu": "assets/images/nasi_goreng_savor.jpg",
      "status": "available"
    }
  ]
}
```

## Get Menu Detail

```http
GET /api/v1/menus/{id_menu}
```

### Success Response

```json
{
  "success": true,
  "message": "Detail menu berhasil diambil.",
  "data": {
    "id_menu": 1,
    "nama_menu": "Nasi Goreng Savor",
    "harga": 25000,
    "kategori": "Rice",
    "deskripsi": "Nasi goreng khas Savor Street dengan bumbu gurih dan telur.",
    "gambar_menu": "assets/images/nasi_goreng_savor.jpg",
    "status": "available"
  }
}
```

## Get Menu Categories

```http
GET /api/v1/menus/categories
```

### Success Response

```json
{
  "success": true,
  "message": "Kategori menu berhasil diambil.",
  "data": ["Rice", "Noodles", "Side Dish", "Beverage"]
}
```
