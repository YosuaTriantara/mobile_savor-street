from pydantic import BaseModel, ConfigDict

from app.models.enums import TableStatus


class MejaValidateResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id_meja: int
    nomor_meja: str
    status: TableStatus
