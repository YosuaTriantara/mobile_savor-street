from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, String, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base
from app.models.enums import OrderStatus


class Pemesanan(Base):
    __tablename__ = "pemesanan"

    id_pemesanan: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    tanggal_pemesanan: Mapped[datetime] = mapped_column(
        DateTime,
        server_default=func.now(),
        nullable=False,
    )

    id_meja: Mapped[int] = mapped_column(
        ForeignKey("meja.id_meja"),
        nullable=False,
    )

    nama_pelanggan: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
    )

    status: Mapped[OrderStatus] = mapped_column(
        Enum(OrderStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=OrderStatus.ORDERED,
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

    # ==========================
    # Relationships
    # ==========================

    meja: Mapped["Meja"] = relationship(
        "Meja",
        back_populates="pemesanan",
    )

    items: Mapped[list["ItemPemesanan"]] = relationship(
        "ItemPemesanan",
        back_populates="pemesanan",
        cascade="all, delete-orphan",
    )

    invoice: Mapped["Invoice"] = relationship(
        "Invoice",
        back_populates="pemesanan",
        uselist=False,
    )

    def __repr__(self) -> str:
        return (
            f"<Pemesanan("
            f"id_pemesanan={self.id_pemesanan}, "
            f"status='{self.status.value}'"
            f")>"
        )