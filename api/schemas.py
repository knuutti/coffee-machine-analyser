from pydantic import BaseModel
import datetime


class DataBase(BaseModel):
    coffee: float | None = None
    timestamp: str

class DataCreate(DataBase):
    pass

class Data(DataBase):
    id: int

    class Config:
        orm_mode = True
