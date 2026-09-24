from pydantic import BaseModel
from datetime import datetime

class UserCreate(BaseModel):
    id: int
    username: str