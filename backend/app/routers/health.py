from fastapi import APIRouter

from app.core.config import Config
from app.core.response import success_response

router = APIRouter(tags=["Health"])


@router.get("/health")
def health_check():
    return success_response(
        message="Backend is running",
        data={
            "service": Config.APP_NAME,
            "version": Config.APP_VERSION,
        },
    )
