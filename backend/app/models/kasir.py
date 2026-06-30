from sqlalchemy import Enum, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base
from app.models.enums import CashierStatus


class Kasir(Base):
    __tablename__ = "kasir"

    id_kasir: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    nama_kasir: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    username: Mapped[str] = mapped_column(
        String(50),
        unique=True,
        nullable=False,
    )

    password: Mapped[str] = mapped_column(
        String(255),
        nullable=False,
    )

    status: Mapped[CashierStatus] = mapped_column(
        Enum(CashierStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=CashierStatus.ACTIVE,
    )

    # ==========================
    # Relationships
    # ==========================

    invoices: Mapped[list["Invoice"]] = relationship(
        "Invoice",
        back_populates="kasir",
    )

    def __repr__(self) -> str:
        return (
            f"<Kasir("
            f"id_kasir={self.id_kasir}, "
            f"username='{self.username}'"
            f")>"
        )