# Backend Setup Guide

Backend menggunakan FastAPI dan MySQL.

## Struktur Folder

```text
backend/
├── app/
│   ├── main.py
│   ├── core/
│   │   ├── config.py
│   │   └── database.py
│   ├── routers/
│   │   ├── table_router.py
│   │   ├── menu_router.py
│   │   ├── option_router.py
│   │   ├── order_router.py
│   │   └── invoice_router.py
│   ├── models/
│   ├── schemas/
│   ├── services/
│   └── repositories/
├── requirements.txt
└── .env.example
```

## Dependency Awal

```text
fastapi
uvicorn
sqlalchemy
pymysql
python-dotenv
pydantic
```

## Endpoint Awal

```text
GET /api/v1/health
GET /api/v1/tables/validate
GET /api/v1/menus
GET /api/v1/menus/{id_menu}
GET /api/v1/options
POST /api/v1/orders
POST /api/v1/invoices/request
GET /api/v1/invoices/{id_invoice}
```
