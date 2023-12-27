from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, DateTime, DECIMAL
from sqlalchemy.orm import relationship

from .database import Base


class Data(Base):
    __tablename__ = "data"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, unique=True)
    coffee = Column(DECIMAL)
