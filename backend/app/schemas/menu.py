from typing import List, Optional

from pydantic import BaseModel, ConfigDict

from app.models.enums import MenuCategory, MenuStatus


class MenuListItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_menu: int
    nama_menu: str
    harga: int
    kategori: MenuCategory
    gambar_menu: Optional[str] = None
    status: MenuStatus


class MenuOptionItem(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_opsi: int
    nama_opsi: str
    harga_tambahan: int


class MenuOptionGroup(BaseModel):
    grup_opsi: str
    tipe_opsi: str
    required: bool
    multiple: bool
    options: List[MenuOptionItem]


class MenuDetail(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_menu: int
    nama_menu: str
    harga: int
    kategori: MenuCategory
    deskripsi: Optional[str] = None
    gambar_menu: Optional[str] = None
    status: MenuStatus
    options: List[MenuOptionGroup]
