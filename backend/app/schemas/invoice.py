from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel

from app.models.enums import InvoiceStatus
from app.schemas.order import OrderItemDetail


class InvoiceDetail(BaseModel):
    id_invoice: int
    id_pemesanan: int
    nomor_meja: str
    nama_pelanggan: Optional[str] = None
    status: InvoiceStatus
    total_harga: int
    items: List[OrderItemDetail]
    created_at: datetime
