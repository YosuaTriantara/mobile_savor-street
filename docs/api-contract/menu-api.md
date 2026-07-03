# Menu API

Base URL: `https://mobile-savor-street.vercel.app/api/v1`

## GET /menus/categories

**Response 200**

```json
{
  "success": true,
  "message": "Kategori berhasil diambil",
  "data": ["Rice", "Noodles", "Side Dish", "Beverage"]
}
```

## GET /menus

Hanya menu berstatus `available` yang dikembalikan.

**Query Parameter (semua opsional)**

| Param | Nilai | Keterangan |
|---|---|---|
| `category` | `Rice` \| `Noodles` \| `Side Dish` \| `Beverage` | filter kategori |
| `search` | string | pencarian nama menu (case-insensitive, substring) |
| `sort` | `price_asc` \| `price_desc` \| `name_asc` \| `name_desc` | default: urut `id_menu` |

**Response 200**

```json
{
  "success": true,
  "message": "Menu berhasil diambil",
  "data": [
    {
      "id_menu": 1,
      "nama_menu": "Tomato Onion Fried Rice",
      "harga": 75000,
      "kategori": "Rice",
      "gambar_menu": "menu/tomato-onion-fried-rice.png",
      "status": "available"
    }
  ]
}
```

## GET /menus/{id_menu}

Detail menu **termasuk opsi kustomisasi** — tidak ada endpoint
`/menus/{id}/options` terpisah.

**Response 200**

```json
{
  "success": true,
  "message": "Detail menu berhasil diambil",
  "data": {
    "id_menu": 1,
    "nama_menu": "Tomato Onion Fried Rice",
    "harga": 75000,
    "kategori": "Rice",
    "deskripsi": "Nasi goreng tomat bawang",
    "gambar_menu": "menu/tomato-onion-fried-rice.png",
    "status": "available",
    "options": [
      {
        "grup_opsi": "Level Pedas",
        "tipe_opsi": "spicy_level",
        "required": true,
        "multiple": false,
        "options": [
          { "id_opsi": 1, "nama_opsi": "Extra Spicy", "harga_tambahan": 0 }
        ]
      }
    ]
  }
}
```

`tipe_opsi`: `spicy_level` | `portion_size` | `topping`.
Grup dengan `tipe_opsi = topping` bersifat `multiple: true` (boleh pilih
lebih dari satu); grup lain single-choice.

**Response 404**: `"Menu tidak ditemukan"`.

## Gambar Menu (ImageKit)

`gambar_menu` berisi path relatif. URL final:

```
https://ik.imagekit.io/szggpdpq5/ + gambar_menu
```

Di mobile sudah ditangani `core/utils/image_url_helper.dart`
(`ImageUrlHelper.build(gambarMenu)`) — jangan menggabungkan string manual.
