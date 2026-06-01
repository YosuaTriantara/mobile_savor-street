# Savor Street

Savor Street adalah aplikasi mobile pemesanan makanan berbasis QR Code untuk restoran. Customer tidak perlu login. Customer cukup melakukan scan QR Code meja, melihat menu, melakukan kustomisasi pesanan, menambahkan item ke cart, melakukan order, meminta tagihan, lalu melakukan pembayaran manual ke kasir.

Project ini menggunakan pendekatan **monorepo**, sehingga aplikasi mobile, backend, database, dan dokumentasi berada dalam satu repository yang sama.

---

## 1. Tujuan Project

Tujuan utama project ini adalah membangun aplikasi mobile yang dapat digunakan customer restoran untuk:

- Scan QR Code meja.
- Melihat daftar menu makanan dan minuman.
- Melihat detail menu.
- Melakukan kustomisasi item pesanan.
- Menambahkan item ke keranjang.
- Melakukan konfirmasi order.
- Melakukan request bill.
- Melihat rincian invoice/tagihan.

Pembayaran dilakukan secara manual ke kasir. Project ini belum menggunakan payment gateway dan belum menggunakan login customer.

---

## 2. Tech Stack

| Bagian | Teknologi |
|---|---|
| Mobile App | Flutter |
| State Management | Riverpod |
| Routing | Go Router |
| HTTP Client | Dio |
| Backend API | FastAPI |
| Database | MySQL |
| Media Storage | Backend static files |
| Version Control | Git & GitHub |
| Project Management | GitHub Projects |
| API Documentation | Swagger / OpenAPI |

---

## 3. Arsitektur Repository

Struktur repository menggunakan konsep **monorepo**.

```text
savor-street/
│
├── mobile/                 # Flutter mobile application
├── backend/                # FastAPI backend service
├── database/               # Database schema, migration, dan seed data
├── docs/                   # Dokumentasi project
├── .gitignore
└── README.md
```

Monorepo hanya memengaruhi cara tim menyimpan dan mengelola source code. Saat aplikasi mobile di-build menjadi APK, folder `backend/`, `database/`, dan `docs/` tidak ikut masuk ke aplikasi.

---

## 4. Struktur Folder Mobile

Folder `mobile/` berisi aplikasi Flutter.

```text
mobile/
│
├── android/
├── ios/
├── assets/
│   ├── images/
│   └── icons/
│
├── lib/
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── routes/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   ├── models/
│   │   └── helpers/
│   │
│   └── features/
│       ├── qr/
│       ├── menu/
│       ├── customization/
│       ├── cart/
│       ├── order/
│       └── invoice/
│
├── test/
├── pubspec.yaml
└── README.md
```

---

## 5. Penjelasan Folder Mobile

### `core/`

Folder ini berisi konfigurasi umum yang digunakan oleh seluruh aplikasi.

```text
core/
├── config/       # Environment, base URL, app config
├── constants/    # Constant value seperti route name, status, key
├── network/      # HTTP client dan API handler
├── routes/       # Routing aplikasi
├── theme/        # Color, typography, dan tema aplikasi
└── utils/        # Utility function umum
```

### `shared/`

Folder ini berisi komponen yang digunakan di banyak feature.

```text
shared/
├── widgets/      # Button, card, loading, empty state
├── models/       # Model umum
└── helpers/      # Formatter harga, validator, dll
```

### `features/`

Folder ini berisi component utama aplikasi. Setiap feature berdiri sendiri agar mudah dikerjakan secara paralel.

```text
features/
├── qr/
├── menu/
├── customization/
├── cart/
├── order/
└── invoice/
```

---

## 6. Struktur Standar Setiap Feature Flutter

Setiap feature di dalam folder `features/` menggunakan struktur yang sama.

Contoh untuk feature `menu`:

```text
features/menu/
│
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
│
├── domain/
│   ├── entities/
│   └── usecases/
│
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
│
└── menu.dart
```

| Folder | Fungsi |
|---|---|
| `data/models` | Model data dari API atau mock data |
| `data/repositories` | Penghubung antara UI dan sumber data |
| `data/datasources` | Sumber data, bisa dari API atau mock JSON |
| `domain/entities` | Struktur data inti yang digunakan feature |
| `domain/usecases` | Logika bisnis feature |
| `presentation/screens` | Halaman UI |
| `presentation/widgets` | Widget khusus feature |
| `presentation/providers` | Riverpod provider untuk state management |

---

## 7. State Management

Project ini menggunakan **Riverpod** sebagai state management utama.

Riverpod digunakan untuk:

- Mengelola data menu.
- Mengelola session meja hasil scan QR.
- Mengelola cart.
- Mengelola proses order.
- Mengelola invoice.
- Menghubungkan UI dengan repository.

Pola sederhana:

```text
Screen
↓
Provider
↓
Use Case / Repository
↓
Datasource
↓
API / Mock Data
```

Catatan untuk gambar menu:

- Riverpod tidak menyimpan file gambar secara langsung.
- Riverpod menyimpan data menu yang berisi `gambar_menu` berupa URL/path gambar.
- UI menampilkan gambar dari URL menggunakan widget image network, misalnya `CachedNetworkImage`.

---

## 8. Struktur Folder Backend

Folder `backend/` berisi service API menggunakan FastAPI.

```text
backend/
│
├── app/
│   ├── main.py
│   │
│   ├── core/
│   │   ├── config.py
│   │   └── database.py
│   │
│   ├── routers/
│   │   ├── table_router.py
│   │   ├── menu_router.py
│   │   ├── order_router.py
│   │   └── invoice_router.py
│   │
│   ├── models/
│   │   ├── table_model.py
│   │   ├── menu_model.py
│   │   ├── order_model.py
│   │   └── invoice_model.py
│   │
│   ├── schemas/
│   │   ├── table_schema.py
│   │   ├── menu_schema.py
│   │   ├── order_schema.py
│   │   └── invoice_schema.py
│   │
│   ├── services/
│   │   ├── table_service.py
│   │   ├── menu_service.py
│   │   ├── order_service.py
│   │   └── invoice_service.py
│   │
│   └── repositories/
│       ├── table_repository.py
│       ├── menu_repository.py
│       ├── order_repository.py
│       └── invoice_repository.py
├── requirements.txt
├── .env.example
└── README.md
```

---

## 9. Penjelasan Folder Backend

| Folder | Fungsi |
|---|---|
| `core/` | Konfigurasi aplikasi dan koneksi database |
| `routers/` | Definisi endpoint API |
| `models/` | Representasi tabel database |
| `schemas/` | Request dan response schema |
| `services/` | Logika bisnis backend |
| `repositories/` | Query dan akses database |

---

## 10. Penyimpanan Gambar

Project Savor Street menggunakan **ImageKit** sebagai layanan penyimpanan dan distribusi gambar menu.

### Alasan Penggunaan ImageKit

- Mengurangi beban penyimpanan pada backend.
- Tidak perlu mengelola file statis secara manual.
- Mendukung CDN sehingga gambar dapat diakses lebih cepat.
- Memudahkan pengelolaan aset gambar menu.

### Arsitektur Penyimpanan Gambar

```text
Image Menu
↓
ImageKit
↓
Image URL
↓
Database
↓
Backend API
↓
Flutter App
```

### Penyimpanan di Database

Tabel `menu` memiliki kolom:

```sql
gambar_menu VARCHAR(500)
```

Kolom ini menyimpan URL gambar dari ImageKit.

Contoh:

```text
https://ik.imagekit.io/savorstreet/menu/nasi-goreng.jpg
```

### Penggunaan pada Backend

Backend tidak menyimpan file gambar secara lokal.

Backend hanya:
- Menyimpan URL gambar ke database.
- Mengembalikan URL gambar melalui API.

Contoh response:

```json
{
  "id_menu": 1,
  "nama_menu": "Nasi Goreng",
  "harga": 25000,
  "gambar_menu": "https://ik.imagekit.io/savorstreet/menu/nasi-goreng.jpg"
}
```

### Penggunaan pada Mobile App

Flutter menampilkan gambar menggunakan URL yang diterima dari API.

Contoh alur:

```text
Riverpod Provider
↓
Repository
↓
API Service
↓
Image URL
↓
CachedNetworkImage
```

### Catatan

- Backend tidak menggunakan folder `uploads/`.
- Backend tidak menyediakan endpoint untuk file gambar.
- Seluruh aset gambar menu dikelola melalui ImageKit.

---
## 11. Struktur Folder Database

```text
database/
│
├── schema/
│   ├── 001_create_tables.sql
│   
│
├── seeds/
│   ├── menu_seed.sql
│   ├── table_seed.sql
│   └── option_seed.sql
│
├── migrations/
│   └── README.md
│
└── README.md
```

---

## 12. Rancangan Tabel Utama

Database mengikuti kebutuhan utama aplikasi Savor Street.

```text
meja
├── id_meja
├── nomor_meja
├── qr_token
└── status

menu
├── id_menu
├── nama_menu
├── harga
├── kategori
├── deskripsi
└── gambar_menu

pemesanan
├── id_pemesanan
├── tanggal_pemesanan
├── id_meja
└── nama_pelanggan

item_pemesanan
├── id_item_pemesanan
├── id_pemesanan
├── id_menu
├── jumlah
└── catatan

opsi
├── id_opsi
├── nama_opsi
└── tipe_opsi

item_opsi
├── id_item_opsi
├── id_item_pemesanan
└── id_opsi

invoice
├── id_invoice
├── id_pemesanan
├── total_harga
└── status_pembayaran
```

Catatan:

- Customer tidak perlu login.
- QR Code hanya menyimpan `qr_token`, bukan `id_meja`.
- `qr_token` digunakan sebagai data unik untuk validasi meja.
- `gambar_menu` menyimpan path atau URL gambar, bukan file gambar.
- `catatan` pada `item_pemesanan` digunakan untuk menyimpan catatan khusus dari customer.
- Pembayaran dilakukan manual ke kasir.
- Status pembayaran cukup berupa informasi tagihan, bukan payment gateway.

---

## 13. QR Code Architecture

QR Code pada meja hanya menyimpan token unik.

Contoh isi QR:

```text
tbl_a01_f8s91x
```

QR tidak menyimpan data JSON seperti:

```json
{
  "table_id": 1,
  "token": "tbl_a01_f8s91x"
}
```

Alasan penggunaan token-only:

- QR lebih sederhana.
- `id_meja` tidak terekspos langsung.
- Backend menjadi sumber kebenaran untuk data meja.
- Validasi QR lebih aman karena token harus cocok dengan data di database.

Alur scan QR:

```text
Customer scan QR
↓
Flutter membaca qr_token
↓
Flutter mengirim token ke backend
↓
Backend mencari token pada tabel meja
↓
Jika valid, backend mengembalikan data meja
↓
Customer masuk ke halaman menu
```

---

## 14. QR Management

QR Management adalah proses internal untuk membuat QR Code yang akan ditempel pada meja restoran. Proses ini berbeda dengan QR Authentication yang digunakan customer saat scan QR.

### QR Management

```text
Generate token unik per meja
↓
Simpan token ke tabel meja
↓
Generate QR image dari token
↓
Export QR image
↓
Cetak dan tempel QR di meja
```

### QR Authentication

```text
Scan QR
↓
Validasi token
↓
Masuk ke menu
```

Untuk MVP, QR dapat dibuat menggunakan script sederhana, misalnya `generate_qr.py`, yang membaca data meja dan menghasilkan file gambar QR.

Contoh output:

```text
backend/uploads/qr/
├── meja-a01.png
├── meja-a02.png
└── meja-a03.png
```

Catatan: folder QR image digunakan untuk kebutuhan cetak/setup internal. Customer app tetap hanya membaca token dari QR.

---

## 15. Struktur Folder Dokumentasi

```text
docs/
│
├── api-contract/
│   ├── table-api.md
│   ├── menu-api.md
│   ├── order-api.md
│   └── invoice-api.md
│
├── database/
│   ├── erd.md
│   └── schema-notes.md
│
├── mobile/
│   ├── screen-flow.md
│   └── state-management.md
│
├── qr/
│   ├── qr-format.md
│   ├── qr-generation.md
│   └── qr-validation.md
│
├── media/
│   └── menu-image-handling.md
│
└── reports/
```

---

## 16. Component Project

Project ini dibagi berdasarkan component agar mudah dikelola di GitHub Projects.

| Component | Deskripsi |
|---|---|
| Project Setup | Setup awal repository, Flutter, FastAPI, MySQL, dan GitHub workflow |
| Design System | Komponen UI reusable seperti button, card, typography, dan theme |
| QR Management | Generate token QR, generate QR image, dan menyiapkan QR untuk meja |
| QR Authentication | Scan QR Code dan validasi token meja |
| Menu | Menampilkan daftar menu, detail menu, search, filter kategori, dan gambar menu |
| Customization | Mengatur opsi pesanan seperti level pedas, topping, ukuran, dan catatan |
| Cart | Mengelola keranjang pesanan customer |
| Order | Mengirim pesanan dari customer ke backend |
| Invoice | Menampilkan rincian tagihan dan request bill |
| Backend API | Membuat endpoint untuk QR, menu, order, invoice, dan static media |
| Database | Membuat schema, relasi, dan seed data |
| Integration | Menghubungkan mobile app dengan backend asli |
| Testing | Pengujian fitur, API, database, dan end-to-end flow |
| Documentation | Dokumentasi penggunaan, setup, API, QR, media, dan laporan teknis |

---

## 17. Dependency Antar Component

Agar setiap component bisa dikerjakan tanpa terlalu menunggu component lain, project menggunakan mock data dan API contract sejak awal.

```text
Project Setup
├── Design System
├── Mock Data
├── Database Design
├── Backend API Skeleton
└── Mobile Feature Skeleton

QR Management
├── Bisa mulai dari seed data meja
├── Menghasilkan qr_token dan QR image
└── Tidak perlu menunggu mobile app

QR Authentication
├── Bisa mulai dengan dummy QR token
└── Integrasi backend dilakukan setelah API validate table siap

Menu
├── Bisa mulai dengan mock JSON
├── Gambar bisa menggunakan asset lokal sementara
└── Integrasi backend dilakukan setelah GET /menus dan static uploads siap

Customization
├── Bisa mulai dengan static option list
└── Integrasi backend dilakukan setelah option API siap

Cart
├── Bisa mulai dengan local state
└── Tidak perlu menunggu backend

Order
├── Bisa mulai dengan mock submit response
└── Integrasi backend dilakukan setelah POST /orders siap

Invoice
├── Bisa mulai dengan mock invoice data
└── Integrasi backend dilakukan setelah invoice API siap
```

---

## 18. API Endpoint Awal

Endpoint awal yang dibutuhkan:

```http
GET /health
GET /tables/validate?token={qr_token}
GET /menus
GET /menus/{id_menu}
GET /menus/categories
GET /menus/{id_menu}/options
POST /orders
POST /orders/{id_pemesanan}/request-bill
GET /invoices/{id_invoice}
GET /uploads/menu/{filename}
```

Catatan:

- Endpoint `/uploads/menu/{filename}` adalah static file endpoint, bukan endpoint API bisnis.
- Field `gambar_menu` pada response menu dapat berupa path relatif seperti `/uploads/menu/nasi-goreng.jpg` atau full URL sesuai konfigurasi backend.

---

## 19. Contoh Menu Response

```json
{
  "success": true,
  "message": "Menu berhasil diambil",
  "data": [
    {
      "id_menu": 1,
      "nama_menu": "Nasi Goreng",
      "harga": 25000,
      "kategori": "Rice",
      "deskripsi": "Nasi goreng dengan bumbu khas",
      "gambar_menu": "/uploads/menu/nasi-goreng.jpg"
    }
  ]
}
```

---

## 20. Contoh Order Payload

```json
{
  "id_meja": 1,
  "qr_token": "tbl_a01_f8s91x",
  "items": [
    {
      "id_menu": 1,
      "jumlah": 2,
      "catatan": "Tidak pedas, tanpa bawang",
      "opsi": [
        {
          "id_opsi": 3,
          "nama_opsi": "Extra Telur"
        }
      ]
    }
  ]
}
```

Catatan:

- `catatan` disimpan pada tabel `item_pemesanan`.
- `opsi` disimpan melalui tabel penghubung `item_opsi`.
- `qr_token` digunakan untuk memastikan order berasal dari QR meja yang valid.

---

## 21. Naming Convention Issue

Format issue GitHub Projects:

```text
[COMPONENT] Nama Task
```

Contoh:

```text
[QR MANAGEMENT] Generate QR image per table
[QR] Create QR scan screen
[MENU] Create menu card widget
[CART] Implement add to cart logic
[ORDER] Create submit order API
[INVOICE] Build invoice screen
```

---

## 22. Ringkasan

Savor Street menggunakan struktur monorepo agar seluruh bagian project dapat dikelola dalam satu repository. Aplikasi mobile menggunakan Flutter dengan Riverpod dan feature-based architecture. Backend menggunakan FastAPI, database menggunakan MySQL, dan manajemen pekerjaan dilakukan melalui GitHub Projects berbasis component.

Struktur ini dibuat agar setiap component dapat dikembangkan secara paralel, diuji secara mandiri, dan diintegrasikan secara bertahap.

Keputusan teknis utama:

- Customer tidak login.
- QR Code hanya menyimpan token.
- QR token divalidasi melalui backend.
- Gambar menu disimpan di backend sebagai static file.
- Database menyimpan path/URL gambar menu.
- Catatan pesanan disimpan pada `item_pemesanan`.
- Pembayaran dilakukan manual ke kasir.
