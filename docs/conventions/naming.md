# Naming Convention

## Repository Folder

Gunakan lowercase dan kebab-case jika lebih dari satu kata.

```text
mobile/
backend/
database/
docs/
```

## Flutter

| Jenis | Format | Contoh |
|---|---|---|
| Folder feature | lowercase | `menu`, `cart`, `invoice` |
| File Dart | snake_case | `menu_list_screen.dart` |
| Class | PascalCase | `MenuListScreen` |
| Variable | camelCase | `menuItems` |
| Provider | camelCase + Provider | `menuProvider` |

## Backend FastAPI

| Jenis | Format | Contoh |
|---|---|---|
| File router | snake_case | `menu_router.py` |
| File service | snake_case | `menu_service.py` |
| Function | snake_case | `get_menu_list` |
| Class schema | PascalCase | `MenuResponse` |

## Database

| Jenis | Format | Contoh |
|---|---|---|
| Table | snake_case | `item_pemesanan` |
| Column | snake_case | `id_menu` |
| Primary key | `id_` + table | `id_menu` |
| Foreign key | `id_` + referenced table | `id_pemesanan` |

## API Endpoint

Gunakan plural noun dan kebab-case jika perlu.

```text
GET /menus
GET /menus/{id_menu}
POST /orders
POST /invoices/request
GET /tables/validate
```
