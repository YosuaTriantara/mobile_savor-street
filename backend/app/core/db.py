from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.core.config import Config

DATABASE_URL = (
    f"mysql+pymysql://"
    f"{Config.DB_USER}:"
    f"{Config.DB_PASSWORD}@"
    f"{Config.DB_HOST}:"
    f"{Config.DB_PORT}/"
    f"{Config.DB_NAME}"
)

engine = create_engine(
    DATABASE_URL,
    echo=Config.DEBUG,
    future=True,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    except Exception:
        db.rollback()
        raise
    finally:
        db.close()