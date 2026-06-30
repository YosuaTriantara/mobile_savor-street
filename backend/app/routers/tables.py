from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.db import get_db
from app.core.response import success_response
from app.schemas.meja import MejaValidateResponse
from app.services import table_service

router = APIRouter(prefix="/tables", tags=["Tables"])


@router.get("/validate")
def validate_table(token: str = Query(...), db: Session = Depends(get_db)):
    meja = table_service.validate_table(db, token)
    data = MejaValidateResponse.model_validate(meja).model_dump(mode="json")
    return success_response(message="QR berhasil divalidasi", data=data)
