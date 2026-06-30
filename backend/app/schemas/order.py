from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, ConfigDict, Field, field_validator

from app.models.enums import OrderStatus


# Request schemas

class OrderItemCreate(BaseModel):
    id_menu: int
    jumlah: int = Field(gt=0)
    catatan: Optional[str] = ""
    opsi: List[int] = Field(default_factory=list)

    @field_validator("catatan", mode="before")
    @classmethod
    def empty_string_if_none(cls, v):
        return v or ""


class OrderCreate(BaseModel):
    id_meja: int
    nama_pelanggan: Optional[str] = None
    items: List[OrderItemCreate] = Field(min_length=1)


# Response schemas

class OrderCreateResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_pemesanan: int
    status: OrderStatus
    created_at: datetime


class OrderOptionDetail(BaseModel):
    nama_opsi: str
    harga_tambahan: int


class OrderItemDetail(BaseModel):
    nama_menu: str
    jumlah: int
    harga_satuan: int
    subtotal: int
    catatan: Optional[str] = ""
    opsi: List[OrderOptionDetail]


class OrderDetail(BaseModel):
    id_pemesanan: int
    nomor_meja: str
    nama_pelanggan: Optional[str] = None
    status: OrderStatus
    tanggal_pemesanan: datetime
    items: List[OrderItemDetail]


class RequestBillResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_invoice: int
    status: str
