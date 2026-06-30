from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError, AppError
from app.models.meja import Meja
from app.models.enums import TableStatus


def validate_table(db: Session, token: str) -> Meja:
    meja = db.query(Meja).filter(Meja.qr_token == token).first()

    if meja is None:
        raise NotFoundError("QR meja tidak ditemukan")

    if meja.status != TableStatus.ACTIVE:
        raise AppError("Meja sedang tidak aktif", status_code=400)

    return meja
