# Database Setup Guide

Database menggunakan MySQL.

## Urutan Setup

1. Jalankan `database/schema/001_create_tables.sql`.
2. Jalankan `database/seeds/001_seed_table.sql`.
3. Jalankan `database/seeds/002_seed_menu.sql`.
4. Jalankan `database/seeds/003_seed_options.sql`.

## Database Name

```text
savor_street
```

## Catatan

- Harga disimpan sebagai integer, contoh `25000`, bukan `Rp 25.000`.
- Gambar menu disimpan sebagai path string.
- QR Code menggunakan `qr_token` pada tabel `meja`.
