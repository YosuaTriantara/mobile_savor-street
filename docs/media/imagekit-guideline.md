# ImageKit Guidelines

## Tujuan

Dokumen ini menjelaskan standar penggunaan ImageKit pada project Savor Street.

Seluruh gambar menu yang digunakan oleh aplikasi harus disimpan dan dikelola melalui ImageKit. Backend tidak menyimpan file gambar secara lokal dan database hanya menyimpan URL gambar yang berasal dari ImageKit.

---

# Arsitektur Penyimpanan Gambar

```text
Image Asset
↓
ImageKit
↓
Image URL
↓
Database (menu.gambar_menu)
↓
Backend API
↓
Flutter Application
```

---

# Struktur Folder ImageKit

Gunakan struktur folder berikut:

```text
savor-street/
└── menu/
```

Contoh:

```text
/menu/nasi-goreng.png
/menu/mie-goreng.png
/menu/french-fries.png
/menu/es-teh-manis.png
```

---

# Naming Convention

Gunakan format:

```text
nama-menu.png
```

Aturan:

* Gunakan huruf kecil.
* Gunakan tanda hubung (-) sebagai pemisah kata.
* Jangan gunakan spasi.
* Jangan gunakan karakter khusus.

Contoh yang benar:

```text
nasi-goreng.jpg
mie-goreng-spesial.jpg
es-teh-manis.jpg
```

Contoh yang salah:

```text
Nasi Goreng.jpg
mie_goreng.jpg
es teh manis.jpg
```

---

# Format URL yang Disimpan di Database

Kolom:

```sql
menu.gambar_menu
```

Menyimpan URL penuh dari ImageKit.

Contoh:

```text
menu/rice/nasi-goreng.png
```


# Penggunaan pada Backend

Backend hanya menyimpan dan mengembalikan URL gambar.

Contoh response API:

```json
{
  "id_menu": 1,
  "nama_menu": "Nasi Goreng",
  "harga": 25000,
  "gambar_menu": "menu/rice/nasi-goreng.jpg"
}
```

Backend tidak:

* Menyimpan file gambar.
* Melayani static file.
* Menggunakan folder uploads.

---

# Penggunaan pada Mobile App

Flutter menggunakan URL gambar yang diberikan API.

Contoh:

```dart
CachedNetworkImage(
  imageUrl: menu.gambarMenu,
)
```

Alur:

```text
API
↓
Riverpod Provider
↓
Repository
↓
UI
↓
CachedNetworkImage
```

---

# Mock Data Development

Saat backend belum tersedia, mock data dapat menggunakan URL ImageKit atau asset lokal.

Contoh:

```json
{
  "id_menu": 1,
  "nama_menu": "Nasi Goreng",
  "gambar_menu": "assets/images/menu/nasi-goreng.jpg"
}
```


---