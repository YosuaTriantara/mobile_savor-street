# Order Flow

Dokumen ini menjelaskan alur pemesanan pada aplikasi Savor Street.

## Alur Pemesanan

```text
Customer melihat menu
↓
Customer memilih menu
↓
Customer mengatur customization
↓
Item dimasukkan ke cart
↓
Customer mengecek cart
↓
Customer menekan tombol Order
↓
Mobile app mengirim order ke backend
↓
Backend menyimpan order ke database
↓
Customer melihat Order Success Screen
```

## Batasan Order

- Customer hanya sampai melakukan pemesanan.
- Status order pada MVP cukup menggunakan `ordered`.
- Tidak ada tracking dapur seperti preparing, ready, atau served.
- Pembayaran dilakukan manual ke kasir.

## Data yang Dikirim Saat Order

- `table_id`
- `customer_name` opsional
- daftar item menu
- quantity setiap item
- opsi customization setiap item
- catatan khusus setiap item

## Setelah Order Berhasil

Customer dapat:

- Kembali ke halaman menu.
- Melihat ringkasan order.
- Melakukan request bill.
