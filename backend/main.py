from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List

from database import engine, get_db
from models import Base, Contact, ContactCreate, ContactResponse

# Création des tables
Base.metadata.create_all(bind=engine)

# Initialisation de l'application
app = FastAPI(title="Contact API")

# Configuration CORS (pour Flutter)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ================== ENDPOINTS ==================

# ➕ Ajouter un contact
@app.post("/contacts", response_model=ContactResponse)
def create_contact(contact: ContactCreate, db: Session = Depends(get_db)):
    # Vérifier l'unicité du téléphone
    existing_contact = db.query(Contact).filter(
        Contact.phone == contact.phone
    ).first()

    if existing_contact:
        raise HTTPException(
            status_code=400,
            detail="Ce numéro de téléphone existe déjà"
        )

    new_contact = Contact(
        name=contact.name,
        phone=contact.phone,
        email=contact.email,
        note=contact.note,
        photo=contact.photo,
        isFavorite=contact.isFavorite
    )

    db.add(new_contact)
    db.commit()
    db.refresh(new_contact)

    return new_contact

# 📋 Lister tous les contacts
@app.get("/contacts", response_model=List[ContactResponse])
def get_contacts(db: Session = Depends(get_db)):
    return db.query(Contact).all()

# 🔍 Récupérer un contact par ID
@app.get("/contacts/{contact_id}", response_model=ContactResponse)
def get_contact(contact_id: int, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()

    if contact is None:
        raise HTTPException(
            status_code=404,
            detail="Contact non trouvé"
        )

    return contact

# ❌ Supprimer un contact
@app.delete("/contacts/{contact_id}")
def delete_contact(contact_id: int, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()

    if contact is None:
        raise HTTPException(
            status_code=404,
            detail="Contact non trouvé"
        )

    db.delete(contact)
    db.commit()

    return {"message": "Contact supprimé avec succès"}

# ================== LANCEMENT ==================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)