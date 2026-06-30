from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.core.db import Base
from app.models.enums import InvoiceStatus


class Invoice(Base):
    __tablename__ = "invoice"

    id_invoice: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    id_pemesanan: Mapped[int] = mapped_column(
        ForeignKey("pemesanan.id_pemesanan"),
        unique=True,
        nullable=False,
    )

    id_kasir: Mapped[int | None] = mapped_column(
        ForeignKey("kasir.id_kasir"),
        nullable=True,
    )

    total_harga: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
    )

    status: Mapped[InvoiceStatus] = mapped_column(
        Enum(InvoiceStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=InvoiceStatus.REQUESTED,
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

    pemesanan: Mapped["Pemesanan"] = relationship(
        "Pemesanan",
        back_populates="invoice",
    )

    kasir: Mapped["Kasir"] = relationship(
        "Kasir",
        back_populates="invoices",
    )

    def __repr__(self) -> str:
        return (
            f"<Invoice("
            f"id_invoice={self.id_invoice}, "
            f"total={self.total_harga}"
            f")>"
        )