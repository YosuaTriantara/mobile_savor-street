from typing import List, Optional

from sqlalchemy.orm import Session, joinedload

from app.core.exceptions import NotFoundError
from app.models.enums import MenuCategory, MenuStatus, OptionStatus
from app.models.menu import Menu
from app.models.menu_opsi import MenuOpsi
from app.schemas.menu import MenuOptionGroup, MenuOptionItem

SORT_MAP = {
    "price_asc": (Menu.harga, "asc"),
    "price_desc": (Menu.harga, "desc"),
    "name_asc": (Menu.nama_menu, "asc"),
    "name_desc": (Menu.nama_menu, "desc"),
}


def get_categories() -> List[str]:
    return [c.value for c in MenuCategory]


def list_menus(
    db: Session,
    category: Optional[str] = None,
    search: Optional[str] = None,
    sort: Optional[str] = None,
) -> List[Menu]:
    query = db.query(Menu).filter(Menu.status == MenuStatus.AVAILABLE)

    if category:
        query = query.filter(Menu.kategori == category)

    if search:
        query = query.filter(Menu.nama_menu.ilike(f"%{search}%"))

    if sort and sort in SORT_MAP:
        column, direction = SORT_MAP[sort]
        query = query.order_by(column.desc() if direction == "desc" else column.asc())
    else:
        query = query.order_by(Menu.id_menu.asc())

    return query.all()


def get_menu_detail(db: Session, id_menu: int) -> dict:
    menu = db.query(Menu).filter(Menu.id_menu == id_menu).first()

    if menu is None:
        raise NotFoundError("Menu tidak ditemukan")

    menu_opsi_rows = (
        db.query(MenuOpsi)
        .options(joinedload(MenuOpsi.opsi))
        .filter(MenuOpsi.id_menu == id_menu)
        .all()
    )

    groups: dict[tuple[str, str], MenuOptionGroup] = {}

    for row in menu_opsi_rows:
        opsi = row.opsi

        if opsi.status != OptionStatus.ACTIVE:
            continue

        key = (opsi.grup_opsi, opsi.tipe_opsi.value)

        if key not in groups:
            groups[key] = MenuOptionGroup(
                grup_opsi=opsi.grup_opsi,
                tipe_opsi=opsi.tipe_opsi.value,
                required=bool(row.wajib),
                multiple=opsi.tipe_opsi.value == "topping",
                options=[],
            )

        groups[key].options.append(
            MenuOptionItem(
                id_opsi=opsi.id_opsi,
                nama_opsi=opsi.nama_opsi,
                harga_tambahan=opsi.harga_tambahan,
            )
        )

    return {
        "id_menu": menu.id_menu,
        "nama_menu": menu.nama_menu,
        "harga": menu.harga,
        "kategori": menu.kategori,
        "deskripsi": menu.deskripsi,
        "gambar_menu": menu.gambar_menu,
        "status": menu.status,
        "options": list(groups.values()),
    }
