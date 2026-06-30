from typing import List

from sqlalchemy import Enum, Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base
from app.models.enums import OptionStatus, OptionType


class Opsi(Base):
    __tablename__ = "opsi"

    id_opsi: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    grup_opsi: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    nama_opsi: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    tipe_opsi: Mapped[OptionType] = mapped_column(
        Enum(OptionType, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
    )

    harga_tambahan: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=0,
    )

    status: Mapped[OptionStatus] = mapped_column(
        Enum(OptionStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=OptionStatus.ACTIVE,
    )

    # ==========================
    # Relationships
    # ==========================

    item_opsi: Mapped[List["ItemOpsi"]] = relationship(
        "ItemOpsi",
        back_populates="opsi",
    )

    menu_opsi: Mapped[List["MenuOpsi"]] = relationship(
        "MenuOpsi",
        back_populates="opsi",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        return (
            f"<Opsi("
            f"id_opsi={self.id_opsi}, "
            f"nama_opsi='{self.nama_opsi}'"
            f")>"
        )