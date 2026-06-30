import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    # Application
    APP_NAME = os.getenv("APP_NAME", "Savor Street API")
    APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
    DEBUG = os.getenv("DEBUG", "True").lower() == "true"

    # Database
    DB_HOST = os.getenv("MYSQLHOST", "localhost")
    DB_PORT = int(os.getenv("MYSQLPORT", 3306))
    DB_NAME = os.getenv("MYSQLDATABASE", "savor_street")
    DB_USER = os.getenv("MYSQLUSER", "root")
    DB_PASSWORD = os.getenv("MYSQLPASSWORD", "")

    # Security
    SECRET_KEY = os.getenv("SECRET_KEY", "CHANGE_THIS_SECRET_KEY")
    ALGORITHM = os.getenv("ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES = int(
        os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", 30)
    )