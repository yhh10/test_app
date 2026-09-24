from fastapi import FastAPI, Depends, HTTPException, status
from schema import UserCreate
from sqlalchemy.orm import Session
from database import get_db, engine
from fastapi.middleware.cors import CORSMiddleware
import model

model.Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/login")
def login(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(model.User).filter(model.User.username == user_data.username).first()
    print(f"Flutter 수신된 유저 데이터 : {user_data}")


@app.get("/api/signin")
def signin(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(model.User).filter(model.User.username == user_data.username).first()

    if user:
        pass