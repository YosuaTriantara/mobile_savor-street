# E2E Manual Test Checklist

Checklist regression manual untuk alur lengkap customer. Jalankan sebelum
demo/rilis. Gunakan HP fisik (scan QR dari layar laptop) atau emulator
(pakai input token manual).

Backend: `https://mobile-savor-street.vercel.app/api/v1` (production).

## Persiapan

- [ ] `flutter pub get` sukses.
- [ ] App terpasang dan berjalan (`flutter run`).
- [ ] Buka gambar `qr_codes/meja-01.png` di layar lain untuk discan.

## 1. QR Scan & Session

- [ ] App terbuka langsung di halaman QR scan.
- [ ] Permission kamera diminta saat pertama kali; setelah diizinkan preview kamera tampil.
- [ ] Scan QR `meja-01.png` → loading "Memvalidasi meja..." → masuk ke halaman Menu.
- [ ] (Negatif) Scan QR acak (mis. QR WiFi) → pesan "QR tidak dikenali", kamera tetap jalan.
- [ ] (Negatif) Input token manual `token-salah` → pesan "QR meja tidak ditemukan".
- [ ] Input token manual yang valid → masuk ke halaman Menu.
- [ ] (Guard) Sebelum scan, buka deep link/route `/cart` → dipaksa kembali ke QR scan.

## 2. Menu & Customization *(menunggu fitur Anggota 3)*

- [ ] Daftar menu tampil dengan gambar dari ImageKit.
- [ ] Filter kategori, search, dan detail menu berfungsi.
- [ ] Opsi kustomisasi (level pedas / ukuran / topping) sesuai `GET /menus/{id}`.

## 3. Cart

- [ ] Item bisa ditambah/dihapus, quantity bisa diubah.
- [ ] Nomor meja di header cart sesuai meja yang discan (mis. "01").
- [ ] Total harga benar (termasuk `harga_tambahan` opsi).

## 4. Order

- [ ] Submit order sukses → Order Success screen dengan nomor pesanan.
- [ ] Order tercatat benar via `GET /orders/{id}` (cek lewat Swagger `/docs`).
- [ ] (Negatif) Submit saat offline → pesan error jelas, app tidak crash.

## 5. Invoice & Request Bill

- [ ] Request Bill sukses → status order jadi `bill_requested`.
- [ ] Invoice screen menampilkan rincian item + total sesuai pesanan.
- [ ] Status pembayaran tampil `requested` (pembayaran manual ke kasir).

## Catatan Hasil

| Tanggal | Tester | Hasil | Catatan |
|---|---|---|---|
| | | | |
