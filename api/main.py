from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from . import crud, models, schemas
from .database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)
app = FastAPI()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Create new data point
@app.post("/data/", response_model=schemas.Data)
def create_data(data: schemas.DataCreate, db: Session = Depends(get_db)):
    return crud.create_data(db=db, data=data)

# Get data points
@app.get("/data/", response_model=list[schemas.Data])
def get_data(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    data = crud.get_data(db, skip=skip, limit=limit)
    return data

# Delete data point based on id
@app.delete("/data/{data_id}", response_model=dict)
def delete_data(data_id: int, db: Session = Depends(get_db)):
    msg = crud.delete_data(db, data_id)
    return msg