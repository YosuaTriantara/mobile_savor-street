# API Contract - Table / QR

## Validate QR Token

```http
GET /api/v1/tables/validate?token={qr_token}
```

### Query Params

| Name | Type | Required | Description |
|---|---|---:|---|
| `token` | string | Yes | Token unik dari QR Code meja |

### Success Response

```json
{
  "success": true,
  "message": "QR token valid.",
  "data": {
    "table_id": 1,
    "table_number": "M01",
    "qr_token": "QR-TABLE-001-A9F2K1",
    "status": "active"
  }
}
```

### Error Response

```json
{
  "success": false,
  "message": "QR token tidak valid.",
  "errors": {
    "token": "Token tidak ditemukan atau meja tidak aktif."
  }
}
```
