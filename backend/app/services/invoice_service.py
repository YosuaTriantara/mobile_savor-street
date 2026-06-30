from sqlalchemy.orm import Session, joinedload

from app.core.exceptions import NotFoundError
from app.models.invoice import Invoice
from app.models.item_opsi import ItemOpsi
from app.models.item_pemesanan import ItemPemesanan
from app.models.pemesanan import Pemesanan
from app.services.order_service import _serialize_order


def get_invoice_detail(db: Session, id_invoice: int) -> dict:
    invoice = (
        db.query(Invoice)
        .options(
            joinedload(Invoice.pemesanan).joinedload(Pemesanan.meja),
            joinedload(Invoice.pemesanan)
            .joinedload(Pemesanan.items)
            .joinedload(ItemPemesanan.menu),
            joinedload(Invoice.pemesanan)
            .joinedload(Pemesanan.items)
            .joinedload(ItemPemesanan.opsi)
            .joinedload(ItemOpsi.opsi),
        )
        .filter(Invoice.id_invoice == id_invoice)
        .first()
    )

    if invoice is None:
        raise NotFoundError("Invoice tidak ditemukan")

    order_data = _serialize_order(invoice.pemesanan)

    return {
        "id_invoice": invoice.id_invoice,
        "id_pemesanan": invoice.id_pemesanan,
        "nomor_meja": order_data["nomor_meja"],
        "nama_pelanggan": order_data["nama_pelanggan"],
        "status": invoice.status,
        "total_harga": invoice.total_harga,
        "items": order_data["items"],
        "created_at": invoice.created_at,
    }
