from sqlalchemy import ForeignKey, Integer, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class ItemPemesanan(Base):
    __tablename__ = "item_pemesanan"

    id_item_pemesanan: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    id_pemesanan: Mapped[int] = mapped_column(
        ForeignKey(
            "pemesanan.id_pemesanan",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    id_menu: Mapped[int] = mapped_column(
        ForeignKey(
            "menu.id_menu",
        ),
        nullable=False,
    )

    jumlah: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=1,
    )

    catatan: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    harga_satuan: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
    )

    subtotal: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
    )

    # ==========================
    # Relationships
    # ==========================

    pemesanan: Mapped["Pemesanan"] = relationship(
        "Pemesanan",
        back_populates="items",
    )

    menu: Mapped["Menu"] = relationship(
        "Menu",
        back_populates="item_pemesanan",
    )

    opsi: Mapped[list["ItemOpsi"]] = relationship(
        "ItemOpsi",
        back_populates="item_pemesanan",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        return (
            f"<ItemPemesanan("
            f"id={self.id_item_pemesanan}, "
            f"menu={self.id_menu}, "
            f"qty={self.jumlah}"
            f")>"
        )