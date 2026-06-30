from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import Config
from app.core.exceptions import AppError
from app.core.response import error_response
from app.routers import health, invoices, menus, orders, tables

app = FastAPI(
    title=Config.APP_NAME,
    version=Config.APP_VERSION,
    debug=Config.DEBUG,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_PREFIX = "/api/v1"

app.include_router(health.router, prefix=API_PREFIX)
app.include_router(tables.router, prefix=API_PREFIX)
app.include_router(menus.router, prefix=API_PREFIX)
app.include_router(orders.router, prefix=API_PREFIX)
app.include_router(invoices.router, prefix=API_PREFIX)


@app.get("/")
def root():
    return {"message": f"{Config.APP_NAME} is running", "version": Config.APP_VERSION}


@app.exception_handler(AppError)
async def app_error_handler(request: Request, exc: AppError):
    return error_response(message=exc.message, errors=exc.errors, status_code=exc.status_code)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors: dict[str, list[str]] = {}

    for err in exc.errors():
        field = ".".join(str(loc) for loc in err["loc"] if loc != "body")
        errors.setdefault(field or "body", []).append(err["msg"])

    return error_response(message="Validation Error", errors=errors, status_code=422)


@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    return error_response(
        message="Terjadi kesalahan pada server" if not Config.DEBUG else str(exc),
        errors={},
        status_code=500,
    )
