# Mobile Setup Guide

Mobile app menggunakan Flutter, Riverpod, dan feature-based architecture.

## Struktur Folder

```text
mobile/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── network/
│   │   ├── routing/
│   │   └── utils/
│   ├── shared/
│   │   ├── widgets/
│   │   ├── themes/
│   │   └── models/
│   ├── features/
│   │   ├── qr/
│   │   ├── menu/
│   │   ├── customization/
│   │   ├── cart/
│   │   ├── order/
│   │   └── invoice/
│   └── main.dart
├── assets/
│   ├── images/
│   └── icons/
└── test/
```

## Dependency Awal

```yaml
flutter_riverpod
go_router
dio
flutter_dotenv
mobile_scanner
cached_network_image
freezed_annotation
json_annotation
```

## Prinsip

- Setiap feature memiliki screen, model, provider, repository, dan service sendiri.
- Gunakan mock data terlebih dahulu sebelum backend siap.
- Jangan langsung memanggil API dari UI; gunakan repository/service layer.
