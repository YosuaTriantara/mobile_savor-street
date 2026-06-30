from sqlalchemy import Boolean, ForeignKey, Integer
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class MenuOpsi(Base):
    __tablename__ = "menu_opsi"

    id_menu: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("menu.id_menu", ondelete="CASCADE"),
        primary_key=True,
    )

    id_opsi: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("opsi.id_opsi", ondelete="CASCADE"),
        primary_key=True,
    )

    wajib: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=False,
    )

    # Relationships
    menu: Mapped["Menu"] = relationship(
        "Menu",
        back_populates="menu_opsi",
    )

    opsi: Mapped["Opsi"] = relationship(
        "Opsi",
        back_populates="menu_opsi",
    )

    def __repr__(self) -> str:
        return (
            f"<MenuOpsi("
            f"id_menu={self.id_menu}, "
            f"id_opsi={self.id_opsi}, "
            f"wajib={self.wajib}"
            f")>"
        )