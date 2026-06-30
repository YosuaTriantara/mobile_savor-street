from typing import List

from sqlalchemy.orm import Session, joinedload

from app.core.exceptions import AppError, NotFoundError
from app.models.enums import MenuStatus, OptionStatus, OrderStatus, TableStatus
from app.models.invoice import Invoice
from app.models.item_opsi import ItemOpsi
from app.models.item_pemesanan import ItemPemesanan
from app.models.meja import Meja
from app.models.menu import Menu
from app.models.opsi import Opsi
from app.models.pemesanan import Pemesanan
from app.schemas.order import OrderCreate


def create_order(db: Session, payload: OrderCreate) -> Pemesanan:
    meja = db.query(Meja).filter(Meja.id_meja == payload.id_meja).first()

    if meja is None:
        raise NotFoundError("Meja tidak ditemukan")

    if meja.status != TableStatus.ACTIVE:
        raise AppError("Meja sedang tidak aktif", status_code=400)

    pemesanan = Pemesanan(
        id_meja=payload.id_meja,
        nama_pelanggan=payload.nama_pelanggan,
        status=OrderStatus.ORDERED,
    )
    db.add(pemesanan)
    db.flush()  

    for item in payload.items:
        menu = db.query(Menu).filter(Menu.id_menu == item.id_menu).first()

        if menu is None:
            raise NotFoundError(f"Menu dengan id {item.id_menu} tidak ditemukan")

        if menu.status != MenuStatus.AVAILABLE:
            raise AppError(f"Menu '{menu.nama_menu}' sedang tidak tersedia", status_code=400)

        selected_opsi: List[Opsi] = []
        harga_tambahan_total = 0

        if item.opsi:
            selected_opsi = db.query(Opsi).filter(Opsi.id_opsi.in_(item.opsi)).all()

            if len(selected_opsi) != len(set(item.opsi)):
                raise AppError("Salah satu opsi yang dipilih tidak ditemukan", status_code=400)

            for opsi in selected_opsi:
                if opsi.status != OptionStatus.ACTIVE:
                    raise AppError(f"Opsi '{opsi.nama_opsi}' sedang tidak aktif", status_code=400)
                harga_tambahan_total += opsi.harga_tambahan

        harga_satuan = menu.harga + harga_tambahan_total
        subtotal = harga_satuan * item.jumlah

        item_pemesanan = ItemPemesanan(
            id_pemesanan=pemesanan.id_pemesanan,
            id_menu=item.id_menu,
            jumlah=item.jumlah,
            catatan=item.catatan,
            harga_satuan=harga_satuan,
            subtotal=subtotal,
        )
        db.add(item_pemesanan)
        db.flush()  

        for opsi in selected_opsi:
            db.add(ItemOpsi(id_item_pemesanan=item_pemesanan.id_item_pemesanan, id_opsi=opsi.id_opsi))

    db.commit()
    db.refresh(pemesanan)
    return pemesanan


def _load_order_or_404(db: Session, id_pemesanan: int) -> Pemesanan:
    pemesanan = (
        db.query(Pemesanan)
        .options(
            joinedload(Pemesanan.meja),
            joinedload(Pemesanan.items).joinedload(ItemPemesanan.menu),
            joinedload(Pemesanan.items).joinedload(ItemPemesanan.opsi).joinedload(ItemOpsi.opsi),
        )
        .filter(Pemesanan.id_pemesanan == id_pemesanan)
        .first()
    )

    if pemesanan is None:
        raise NotFoundError("Pesanan tidak ditemukan")

    return pemesanan


def get_order_detail(db: Session, id_pemesanan: int) -> dict:
    pemesanan = _load_order_or_404(db, id_pemesanan)
    return _serialize_order(pemesanan)


def _serialize_order(pemesanan: Pemesanan) -> dict:
    items = []

    for item in pemesanan.items:
        items.append(
            {
                "nama_menu": item.menu.nama_menu,
                "jumlah": item.jumlah,
                "harga_satuan": item.harga_satuan,
                "subtotal": item.subtotal,
                "catatan": item.catatan or "",
                "opsi": [
                    {"nama_opsi": io.opsi.nama_opsi, "harga_tambahan": io.opsi.harga_tambahan}
                    for io in item.opsi
                ],
            }
        )

    return {
        "id_pemesanan": pemesanan.id_pemesanan,
        "nomor_meja": pemesanan.meja.nomor_meja,
        "nama_pelanggan": pemesanan.nama_pelanggan,
        "status": pemesanan.status,
        "tanggal_pemesanan": pemesanan.tanggal_pemesanan,
        "items": items,
    }


def request_bill(db: Session, id_pemesanan: int) -> Invoice:
    pemesanan = _load_order_or_404(db, id_pemesanan)

    existing_invoice = db.query(Invoice).filter(Invoice.id_pemesanan == id_pemesanan).first()
    if existing_invoice is not None:
        raise AppError("Tagihan untuk pesanan ini sudah pernah dibuat", status_code=400)

    if pemesanan.status == OrderStatus.CANCELLED:
        raise AppError("Pesanan ini sudah dibatalkan", status_code=400)

    total_harga = sum(item.subtotal for item in pemesanan.items)

    invoice = Invoice(
        id_pemesanan=id_pemesanan,
        total_harga=total_harga,
    )
    db.add(invoice)

    pemesanan.status = OrderStatus.BILL_REQUESTED

    db.commit()
    db.refresh(invoice)
    return invoice
