from sqlalchemy import ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.core.db import Base


class ItemOpsi(Base):
    __tablename__ = "item_opsi"

    id_item_opsi: Mapped[int] = mapped_column(
        Integer,
        primary_key=True,
        autoincrement=True,
    )

    id_item_pemesanan: Mapped[int] = mapped_column(
        ForeignKey(
            "item_pemesanan.id_item_pemesanan",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    id_opsi: Mapped[int] = mapped_column(
        ForeignKey(
            "opsi.id_opsi",
        ),
        nullable=False,
    )

    # ==========================
    # Relationships
    # ==========================

    item_pemesanan: Mapped["ItemPemesanan"] = relationship(
        "ItemPemesanan",
        back_populates="opsi",
    )

    opsi: Mapped["Opsi"] = relationship(
        "Opsi",
        back_populates="item_opsi",
    )

    def __repr__(self) -> str:
        return (
            f"<ItemOpsi("
            f"id={self.id_item_opsi}, "
            f"id_opsi={self.id_opsi}"
            f")>"
        )