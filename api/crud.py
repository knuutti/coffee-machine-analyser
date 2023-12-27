from sqlalchemy.orm import Session
from datetime import datetime
from . import models, schemas

def get_data(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Data).offset(skip).limit(limit).all()

def delete_data(db: Session, data_id: int):
    db_data = db.query(models.Data).filter(models.Data.id == data_id).first()
    if not db_data: return {"message": "No data to remove"}
    db.delete(db_data)
    db.commit()
    return {"message": "Data removed"}

def create_data(db: Session):
    db_data = models.Data(timestamp=datetime.strptime(data.timestamp.split(".")[0],'%Y-%m-%d %H:%M:%S'), coffee=data.coffee)
    db.add(db_data)
    db.commit()
    db.refresh(db_data)
    return db_data