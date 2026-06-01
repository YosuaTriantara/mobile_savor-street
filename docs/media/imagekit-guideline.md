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
    ├── rice/
    ├── noodles/
    ├── side-dish/
    └── beverage/
```

Contoh:

```text
savor-street/menu/rice/nasi-goreng.jpg
savor-street/menu/noodles/mie-goreng.jpg
savor-street/menu/side-dish/french-fries.jpg
savor-street/menu/beverage/es-teh-manis.jpg
```

---

# Naming Convention

Gunakan format:

```text
nama-menu.jpg
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
https://ik.imagekit.io/savorstreet/menu/rice/nasi-goreng.jpg
```

Jangan menyimpan:

```text
nasi-goreng.jpg
/menu/rice/nasi-goreng.jpg
```

Database harus selalu menyimpan URL lengkap yang dapat langsung digunakan oleh aplikasi mobile.

---

# Standar Format Gambar

Format yang diperbolehkan:

```text
jpg
jpeg
png
webp
```

Rekomendasi:

```text
webp
```

karena ukuran file lebih kecil.

---

# Ukuran Gambar

Rekomendasi:

```text
Aspect Ratio : 1 : 1
Resolution   : 800 x 800 px
```

Minimal:

```text
600 x 600 px
```

Maksimal:

```text
1200 x 1200 px
```

---

# Penggunaan pada Backend

Backend hanya menyimpan dan mengembalikan URL gambar.

Contoh response API:

```json
{
  "id_menu": 1,
  "nama_menu": "Nasi Goreng",
  "harga": 25000,
  "gambar_menu": "https://ik.imagekit.io/savorstreet/menu/rice/nasi-goreng.jpg"
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

Setelah integrasi API selesai, seluruh gambar harus menggunakan URL dari ImageKit.

---