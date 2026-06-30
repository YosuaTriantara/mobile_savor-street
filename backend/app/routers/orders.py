from fastapi import APIRouter, Depends, Path
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.response import success_response
from app.schemas.order import OrderCreate, OrderCreateResponse, OrderDetail, RequestBillResponse
from app.services import order_service

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.post("")
def create_order(payload: OrderCreate, db: Session = Depends(get_db)):
    pemesanan = order_service.create_order(db, payload)
    data = OrderCreateResponse.model_validate(pemesanan).model_dump(mode="json")
    return success_response(message="Pesanan berhasil dibuat", data=data, status_code=201)


@router.get("/{id_pemesanan}")
def get_order_detail(id_pemesanan: int = Path(...), db: Session = Depends(get_db)):
    detail = order_service.get_order_detail(db, id_pemesanan)
    data = OrderDetail.model_validate(detail).model_dump(mode="json")
    return success_response(message="Detail pesanan berhasil diambil", data=data)


@router.post("/{id_pemesanan}/request-bill")
def request_bill(id_pemesanan: int = Path(...), db: Session = Depends(get_db)):
    invoice = order_service.request_bill(db, id_pemesanan)
    data = RequestBillResponse.model_validate(invoice).model_dump(mode="json")
    return success_response(message="Permintaan tagihan berhasil dikirim", data=data)
