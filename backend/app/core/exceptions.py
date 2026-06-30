from typing import Any


class AppError(Exception):
    def __init__(self, message: str, status_code: int = 400, errors: Any = None):
        self.message = message
        self.status_code = status_code
        self.errors = errors if errors is not None else {}
        super().__init__(message)


class NotFoundError(AppError):
    def __init__(self, message: str = "Data tidak ditemukan", errors: Any = None):
        super().__init__(message=message, status_code=404, errors=errors)


class ValidationAppError(AppError):
    def __init__(self, message: str = "Validation Error", errors: Any = None):
        super().__init__(message=message, status_code=422, errors=errors)
