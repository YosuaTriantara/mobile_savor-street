from typing import Optional

from fastapi import APIRouter, Depends, Path, Query
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.response import success_response
from app.schemas.menu import MenuDetail, MenuListItem
from app.services import menu_service

router = APIRouter(prefix="/menus", tags=["Menus"])


@router.get("/categories")
def get_categories():
    data = menu_service.get_categories()
    return success_response(message="Kategori berhasil diambil", data=data)


@router.get("")
def get_menus(
    category: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    sort: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    menus = menu_service.list_menus(db, category=category, search=search, sort=sort)
    data = [MenuListItem.model_validate(m).model_dump(mode="json") for m in menus]
    return success_response(message="Menu berhasil diambil", data=data)


@router.get("/{id_menu}")
def get_menu_detail(id_menu: int = Path(...), db: Session = Depends(get_db)):
    detail = menu_service.get_menu_detail(db, id_menu)
    data = MenuDetail.model_validate(detail).model_dump(mode="json")
    return success_response(message="Detail menu berhasil diambil", data=data)
