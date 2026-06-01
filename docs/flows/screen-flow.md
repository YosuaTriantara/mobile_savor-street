# Screen Flow Savor Street

Dokumen ini menjelaskan alur layar aplikasi mobile Savor Street.

## Alur Utama Customer

```text
Splash Screen
↓
Scan QR Screen
↓
QR Validation
↓
Menu List Screen
↓
Menu Detail Screen
↓
Customization Screen
↓
Cart Screen
↓
Order Confirmation
↓
Order Success Screen
↓
Request Bill
↓
Invoice Screen
```

## Batasan Scope

- Customer tidak melakukan login atau registrasi.
- Customer hanya perlu scan QR Code meja.
- Customer tidak melakukan pembayaran di aplikasi.
- Pembayaran dilakukan manual kepada kasir.
- Sistem kasir web dashboard belum dibuat pada MVP saat ini, tetapi struktur backend dan database disiapkan agar bisa dikembangkan nanti.

## Daftar Route Mobile

| Route | Screen | Keterangan |
|---|---|---|
| `/splash` | Splash Screen | Halaman pembuka aplikasi |
| `/scan-qr` | Scan QR Screen | Scan QR Code meja |
| `/menu` | Menu List Screen | Menampilkan daftar menu |
| `/menu/:id` | Menu Detail Screen | Detail item menu |
| `/customize/:id` | Customization Screen | Kustomisasi item sebelum masuk cart |
| `/cart` | Cart Screen | Keranjang pesanan |
| `/order-success` | Order Success Screen | Pesanan berhasil dikirim |
| `/invoice/:id` | Invoice Screen | Rincian tagihan |
