from datetime import datetime
from typing import List

from sqlalchemy import DateTime, Enum, Integer, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base
from app.models.enums import TableStatus


class Meja(Base):
    __tablename__ = "meja"

    id_meja: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    nomor_meja: Mapped[str] = mapped_column(
        String(20),
        unique=True,
        nullable=False,
    )

    qr_token: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        nullable=False,
    )

    status: Mapped[TableStatus] = mapped_column(
        Enum(TableStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=TableStatus.ACTIVE,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        server_default=func.now(),
        nullable=False,
    )

    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    # Relationships
    pemesanan: Mapped[List["Pemesanan"]] = relationship(
        "Pemesanan",
        back_populates="meja",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        return (
            f"<Meja("
            f"id_meja={self.id_meja}, "
            f"nomor_meja='{self.nomor_meja}', "
            f"status='{self.status.value}'"
            f")>"
        )