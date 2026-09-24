from dotenv import load_dotenv
import os
from urllib.parse import quote_plus

load_dotenv()

def _mysql_url(user, password, host, port, name):
    return (
        f"mysql+pymysql://{user}:{quote_plus(password)}"
        f"@{host}:{port}/{name}?charset=utf8mb4"
    )

class Config():

    _host = os.getenv("DB_HOST", "db")
    _port = os.getenv("DB_PORT", "3306")

    SQLALCHEMY_DATABASE_URL = _mysql_url(
        os.environ["DB_USER"],
        os.environ["DB_PASSWORD"],
        _host, _port,
        os.environ["DB_NAME"]
    )

config = Config()