from fastapi import APIRouter, Depends, Path
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.response import success_response
from app.schemas.invoice import InvoiceDetail
from app.services import invoice_service

router = APIRouter(prefix="/invoices", tags=["Invoices"])


@router.get("/{id_invoice}")
def get_invoice(id_invoice: int = Path(...), db: Session = Depends(get_db)):
    detail = invoice_service.get_invoice_detail(db, id_invoice)
    data = InvoiceDetail.model_validate(detail).model_dump(mode="json")
    return success_response(message="Invoice berhasil diambil", data=data)
