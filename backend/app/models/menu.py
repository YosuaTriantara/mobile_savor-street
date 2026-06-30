from datetime import datetime
from typing import List

from sqlalchemy import DateTime, Enum, Integer, String, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base
from app.models.enums import MenuCategory, MenuStatus


class Menu(Base):
    __tablename__ = "menu"

    id_menu: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    nama_menu: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
    )

    harga: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
    )

    kategori: Mapped[MenuCategory] = mapped_column(
        Enum(MenuCategory, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
    )

    deskripsi: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    gambar_menu: Mapped[str | None] = mapped_column(
        String(255),
        nullable=True,
    )

    status: Mapped[MenuStatus] = mapped_column(
        Enum(MenuStatus, values_callable=lambda obj: [e.value for e in obj]),
        nullable=False,
        default=MenuStatus.AVAILABLE,
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

    item_pemesanan: Mapped[List["ItemPemesanan"]] = relationship(
        "ItemPemesanan",
        back_populates="menu",
    )

    menu_opsi: Mapped[List["MenuOpsi"]] = relationship(
        "MenuOpsi",
        back_populates="menu",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        return (
            f"<Menu("
            f"id_menu={self.id_menu}, "
            f"nama_menu='{self.nama_menu}', "
            f"harga={self.harga}"
            f")>"
        )