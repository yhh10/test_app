from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from app.schema import UserCreate
from app.database import get_db, engine
from app.model import Base, User

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/login")
def login(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == user_data.username).first()
    print(f"Flutter 수신된 유저 데이터 : {user_data.username}", flush=True)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="아이디 또는 비밀번호가 올바르지 않습니다.",
        )

    if user.username == user_data.username and user.password == user_data.password:
        return {
            "status": "success",
            "message": f"환영합니다. {user.username} 님",
            "user_id": user.id,
            "username": user.username,
        }
    else:
        return {
            "status": "fail",
            "message": "아이디 또는 비밀번호가 올바르지 않습니다.",
        }

@app.post("/api/signin")
def signin(user_data: UserCreate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == user_data.username).first()

    if user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="이미 존재하는 아이디입니다."
        )

    new_user = User(
        username=user_data.username,
        password=user_data.password
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "status": "success",
        "message": "회원가입을 완료했습니다.",
        "user_id": new_user.id,
        "username": new_user.username
    }