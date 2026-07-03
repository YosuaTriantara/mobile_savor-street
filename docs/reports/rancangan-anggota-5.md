# Rancangan Kerja — Anggota 5 (QR, Integration & Quality Engineer)

> Disusun: 3 Juli 2026
> Ownership: `mobile/lib/features/qr/`, `docs/`, GitHub Project, Integration, Testing
> Deliverables: **QR Ready · Integration Ready · Testing Ready**

---

## 1. Kondisi Repo Saat Ini (Hasil Analisis)

Rancangan ini dibuat berdasarkan kondisi nyata repo per 3 Juli 2026, bukan hanya
berdasarkan dokumen struktur tim.

| Bagian | Pemilik | Status |
|---|---|---|
| Backend + Database | Anggota 1 | ✅ Selesai & sudah deploy di `https://mobile-savor-street.vercel.app/api/v1` |
| Core & Shared (Flutter) | Anggota 2 | ✅ Selesai — Dio, GoRouter, theme, shared widgets, `ImageUrlHelper` |
| Menu & Customization | Anggota 3 | ❌ Belum ada (`features/menu/`, `features/customization/` belum dibuat) |
| Cart, Order, Invoice | Anggota 4 | ✅ Selesai — **sudah langsung memakai API asli** (bukan mock) |
| QR Management (internal) | — | ✅ Sudah ada: `generate_meja.py` + 15 QR image di `qr_codes/` |

Fakta penting yang sudah **diverifikasi langsung ke API production**:

1. **Isi QR Code** = URL `http://localhost:8000?table=<token>`.
   Token yang harus diambil aplikasi adalah nilai query param **`table`**.
2. Token pada `qr_codes/meja-01.png` **cocok dengan database production**:
   ```
   GET /tables/validate?token=bran9FoHy...
   → 200 {"success":true,"message":"QR berhasil divalidasi",
          "data":{"id_meja":1,"nomor_meja":"01","status":"active"}}
   ```
   Token salah → `404 {"success":false,"message":"QR meja tidak ditemukan","errors":{}}`.
   Meja nonaktif → `400 "Meja sedang tidak aktif"`.
3. **Tidak ada endpoint `/menus/{id}/options`** — opsi menu sudah *embedded* di
   response `GET /menus/{id_menu}` (field `options`, per grup opsi).
4. `gambar_menu` dari API berupa path relatif (mis. `menu/tomato-onion-fried-rice.png`).
   URL final = `https://ik.imagekit.io/szggpdpq5/` + path — **sudah ditangani**
   oleh `core/utils/image_url_helper.dart`, tinggal dipakai.
5. `core/session/table_session.dart` masih **stub** (`id_meja: 1` hardcode) dengan
   catatan eksplisit bahwa Anggota 5 yang menggantinya dengan session hasil scan QR.
6. **Diskrepansi dokumentasi**: `docs/flows/qr-flow.md` masih menulis format QR
   `savorstreet://table?token=` dan field response `table_id`/`table_number` —
   tidak sesuai implementasi nyata (`?table=` dan `id_meja`/`nomor_meja`).
   Wajib diperbarui (masuk tugas dokumentasi).

---

## 2. Rancangan Fitur QR (`features/qr/`)

### 2.1 Struktur Folder

```
features/qr/
├── data/
│   ├── datasources/
│   │   └── qr_remote_datasource.dart      # GET /tables/validate?token=
│   └── repositories/
│       └── qr_repository.dart             # validateToken(token) → TableEntity
├── domain/
│   └── entities/
│       └── table_entity.dart              # id_meja, nomor_meja, status
├── presentation/
│   ├── providers/
│   │   └── qr_validation_provider.dart    # AsyncNotifier: idle/loading/success/error
│   ├── screens/
│   │   └── qr_scan_screen.dart            # kamera + overlay + manual input
│   └── widgets/
│       ├── qr_scanner_overlay.dart        # frame kotak scan
│       └── manual_token_sheet.dart        # fallback input token manual
└── qr.dart                                # barrel export
```

Mengikuti pola yang sudah dipakai Anggota 4 (repository menerima `Dio` dari
`dioProvider`, parsing `response.data['data']`).

### 2.2 Kontrak API yang Dipakai

| Kasus | HTTP | Response |
|---|---|---|
| Token valid | 200 | `data: { id_meja, nomor_meja, status: "active" }` |
| Token tidak ditemukan | 404 | `success: false, message: "QR meja tidak ditemukan"` |
| Meja nonaktif | 400 | `success: false, message: "Meja sedang tidak aktif"` |

### 2.3 Parsing Isi QR (Token Parser)

QR nyata berisi URL, tetapi parser dibuat toleran terhadap 3 bentuk supaya tidak
rapuh jika format berubah:

```
1. URL dengan ?table=<token>   ← format produksi saat ini (generate_meja.py)
2. URL dengan ?token=<token>   ← format lama di docs
3. Raw token langsung          ← fallback / input manual
```

Fungsi murni `String? extractQrToken(String rawValue)` di `data/` — mudah di-unit-test.

### 2.4 Alur State

```
QrScanScreen (kamera aktif, mobile_scanner)
   ↓ QR terdeteksi → kamera di-pause (cegah double-scan)
extractQrToken(raw)
   ↓ null → tampilkan error "QR tidak dikenali" → resume kamera
qrValidationProvider.validate(token)      [loading overlay]
   ↓ gagal (404/400/timeout) → dialog error + tombol "Scan Ulang"
   ↓ sukses
tableSessionProvider.set(TableSession(idMeja, nomorMeja))
   ↓
context.go(AppRoutes.menu)
```

### 2.5 Dependensi & Permission Baru

- `pubspec.yaml`: tambah **`mobile_scanner`** (scanner berbasis kamera, aktif dipelihara).
- Android: `<uses-permission android:name="android.permission.CAMERA"/>` di
  `AndroidManifest.xml` (runtime permission ditangani mobile_scanner).
- iOS: `NSCameraUsageDescription` di `Info.plist`.
- **Fallback input manual token** (bottom sheet) — penting karena testing di
  emulator tanpa kamera fisik; juga berguna saat demo.

---

## 3. Rancangan Integrasi

Karena Anggota 1, 2, 4 ternyata sudah langsung memakai API asli, pekerjaan
"mengganti mock → real API" berubah menjadi pekerjaan **penyambungan session +
pengawalan alur end-to-end**:

### 3.1 Ganti Stub Table Session (prioritas tertinggi)

`core/session/table_session.dart` diubah dari `Provider<TableSession>` statis
menjadi `NotifierProvider<TableSessionNotifier, TableSession?>`:

- State awal `null` (belum scan).
- Diisi oleh fitur QR setelah validasi sukses.
- Konsumen yang harus disesuaikan: `order_provider.dart` (Anggota 4) yang
  membaca `id_meja` — koordinasikan sebelum merge.

### 3.2 Route Guard (GoRouter)

Tambah `redirect` di `app_router.dart`: jika `tableSessionProvider == null` dan
route bukan `/qr-scan` → paksa kembali ke `/qr-scan`. Dengan ini order tidak
mungkin terkirim tanpa meja yang valid.

### 3.3 Checklist Integrasi per Fitur

| Fitur | Status sekarang | Pekerjaan integrasi |
|---|---|---|
| QR | belum ada | dibangun langsung ke API asli (bagian 2) |
| Menu | belum ada (Anggota 3) | siapkan kontrak API + review PR agar langsung pakai `dioProvider` & `ImageUrlHelper` |
| Customization | belum ada (Anggota 3) | pastikan pakai `options` dari `GET /menus/{id}` (bukan endpoint terpisah) |
| Cart | ✅ API asli | verifikasi harga opsi (`harga_tambahan`) ikut terhitung |
| Order | ✅ API asli | ganti sumber `id_meja` dari stub → session QR |
| Invoice | ✅ API asli | verifikasi alur request-bill → invoice end-to-end |

### 3.4 Gambar Menu (ImageKit)

Tidak ada pekerjaan baru — `ImageUrlHelper.build()` sudah menggabungkan
`IMAGEKIT_URL_ENDPOINT` + path dari database. Tugas integrasi hanya memastikan
Anggota 3 memakainya bersama `CachedNetworkImage` dan menguji gambar tampil.

---

## 4. Rancangan Testing

| Level | Target | Alat |
|---|---|---|
| Unit | `extractQrToken` (3 format + input rusak), `QrRepository` (200/404/400/timeout via mock Dio), `ImageUrlHelper` | `flutter_test`, `mocktail` |
| Widget | `QrScanScreen` state error & loading, guard redirect | `flutter_test` |
| E2E manual | scan `qr_codes/meja-01.png` → menu → customization → cart → order → request bill → invoice | HP fisik + checklist |
| API smoke | semua endpoint via Swagger `/docs` | manual, didokumentasikan |

Skenario E2E ditulis sebagai checklist di `docs/testing/e2e-checklist.md` supaya
bisa dipakai ulang saat regression test sebelum demo.

Catatan teknis: QR image bisa discan dari layar laptop memakai HP fisik;
untuk emulator gunakan fallback input token manual.

---

## 5. Rancangan Dokumentasi (`docs/`)

Struktur akhir (melengkapi yang sudah ada, tanpa merombak):

```
docs/
├── api-contract/            # BARU — sesuai API production, per resource
│   ├── table-api.md         #   validate + contoh response nyata
│   ├── menu-api.md          #   list/filter/search/sort, detail + options embedded
│   ├── order-api.md         #   create, detail, request-bill
│   └── invoice-api.md
├── guides/                  # BARU
│   ├── installation.md      #   setup Flutter, run backend lokal, --dart-define
│   └── developer-guide.md   #   arsitektur, konvensi, alur kontribusi
├── flows/
│   ├── qr-flow.md           # UPDATE — samakan dengan implementasi (?table=, id_meja)
│   ├── order-flow.md        # (sudah ada)
│   └── screen-flow.md       # UPDATE setelah semua screen jadi
├── mobile/
│   └── state-management.md  # BARU — peta provider seluruh app
├── testing/
│   └── e2e-checklist.md     # BARU
└── reports/
    └── rancangan-anggota-5.md  # dokumen ini
```

---

## 6. Breakdown Issue GitHub Projects

Sesuai naming convention `[COMPONENT] Nama Task`:

1. `[QR] Add mobile_scanner dependency & camera permission`
2. `[QR] Create token parser & validation repository`
3. `[QR] Build QR scan screen (overlay, manual input, error states)`
4. `[QR] Implement table session notifier`
5. `[INTEGRATION] Replace table session stub & add router guard`
6. `[INTEGRATION] Verify end-to-end flow QR → order → invoice`
7. `[INTEGRATION] Wire menu & customization to real API` *(menunggu Anggota 3)*
8. `[TESTING] Unit tests: token parser, QR repository, helpers`
9. `[TESTING] E2E manual checklist & regression run`
10. `[DOCS] API contract: table, menu, order, invoice`
11. `[DOCS] Update QR docs to match implementation`
12. `[DOCS] Installation & developer guide`

## 7. Urutan Pengerjaan

| Fase | Isi | Alasan |
|---|---|---|
| **1. QR Feature** (issue 1–4) | scanner, parser, validasi, session | Blocker utama: tanpa ini order selalu memakai meja stub |
| **2. Integrasi Session** (issue 5–6) | ganti stub, router guard, E2E awal | Butuh koordinasi kecil dengan Anggota 4 |
| **3. Dokumentasi** (issue 10–12) | api-contract dulu (membantu Anggota 3), lalu guide | api-contract mempercepat pekerjaan menu/customization |
| **4. Testing & Integrasi Akhir** (issue 7–9) | unit test, E2E penuh | Fitur menu/customization dari Anggota 3 harus sudah masuk |

## 8. Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| Fitur Menu/Customization (Anggota 3) terlambat | Fase 1–3 tidak bergantung padanya; siapkan api-contract agar Anggota 3 cepat; route guard tetap bisa diuji dengan screen placeholder |
| Perubahan `tableSessionProvider` merusak kode Anggota 4 | Ubah lewat PR terpisah, tag Anggota 4 sebagai reviewer |
| Emulator tidak punya kamera | Fallback input token manual di QR screen |
| Token QR tidak sinkron dengan DB | Sudah diverifikasi cocok (meja-01 → 200 OK); jika `generate_meja.py` dijalankan ulang, DB production harus di-seed ulang |
