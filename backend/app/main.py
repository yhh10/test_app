from fastapi import FastAPI, Depends, HTTPException, status
from schema import UserCreate
from sqlalchemy.orm import Session
from database import get_db, engine
import model

model.Base.metadata.create_all(bind=engine)

app = FastAPI()

@app.get("/api/login")
def login(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(model.User).filter(model.User.username == user_data.username).first()

    pass

@app.get("/api/signin")
def signin(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(model.User).filter(model.User.username == user_data.username).first()

    if not user:
        pass