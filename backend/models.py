from sqlalchemy import Column, Integer, String, Boolean
from database import Base
from pydantic import BaseModel
from typing import Optional

# ======== Modèle SQLAlchemy (Base de données) ========

class Contact(Base):
    __tablename__ = "contacts"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    phone = Column(String, index=True, nullable=False)
    email = Column(String, nullable=True)
    note = Column(String, nullable=True)
    photo = Column(String, nullable=True)
    isFavorite = Column(Boolean, default=False)
    user_id = Column(Integer, nullable=False, index=True)  # ✅ Lien avec l'utilisateur

# ======== Modèles Pydantic (Validation) ========

class ContactCreate(BaseModel):
    name: str
    phone: str
    email: Optional[str] = None
    note: Optional[str] = None
    photo: Optional[str] = None
    isFavorite: bool = False
    user_id: int  # ✅ OBLIGATOIRE

class ContactResponse(BaseModel):
    id: int
    name: str
    phone: str
    email: Optional[str] = None
    note: Optional[str] = None
    photo: Optional[str] = None
    isFavorite: bool
    user_id: int

    class Config:
        from_attributes = True