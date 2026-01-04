from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List

from database import engine, get_db
from models import Base, Contact, ContactCreate, ContactResponse

# Création des tables
Base.metadata.create_all(bind=engine)

# Initialisation de l'application
app = FastAPI(title="Contact API")

# Configuration CORS
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
    # Vérifier que user_id est fourni
    if contact.user_id is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="user_id est requis"
        )
    
    # Vérifier l'unicité du téléphone pour cet utilisateur
    existing_contact = db.query(Contact).filter(
        Contact.phone == contact.phone,
        Contact.user_id == contact.user_id
    ).first()

    if existing_contact:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Ce numéro de téléphone existe déjà dans vos contacts"
        )

    new_contact = Contact(
        name=contact.name,
        phone=contact.phone,
        email=contact.email,
        note=contact.note,
        photo=contact.photo,
        isFavorite=contact.isFavorite,
        user_id=contact.user_id
    )

    db.add(new_contact)
    db.commit()
    db.refresh(new_contact)

    print(f"✅ Contact créé: ID={new_contact.id}, User={new_contact.user_id}")
    return new_contact

# 📋 Lister tous les contacts d'un utilisateur
@app.get("/contacts", response_model=List[ContactResponse])
def get_contacts(user_id: int, db: Session = Depends(get_db)):
    contacts = db.query(Contact).filter(Contact.user_id == user_id).all()
    print(f"📋 {len(contacts)} contacts récupérés pour user {user_id}")
    return contacts

# 🔍 Récupérer un contact par ID
@app.get("/contacts/{contact_id}", response_model=ContactResponse)
def get_contact(contact_id: int, user_id: int, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.user_id == user_id
    ).first()

    if contact is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contact non trouvé"
        )

    return contact

# ✏️ Mettre à jour un contact
@app.put("/contacts/{contact_id}", response_model=ContactResponse)
def update_contact(
    contact_id: int,
    contact_update: ContactCreate,
    db: Session = Depends(get_db)
):
    # Vérifier que user_id est fourni
    if contact_update.user_id is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="user_id est requis"
        )
    
    # Récupérer le contact existant
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.user_id == contact_update.user_id
    ).first()

    if contact is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contact non trouvé ou vous n'avez pas les droits"
        )

    # Vérifier l'unicité du téléphone si modifié
    if contact_update.phone != contact.phone:
        existing = db.query(Contact).filter(
            Contact.phone == contact_update.phone,
            Contact.user_id == contact_update.user_id,
            Contact.id != contact_id
        ).first()

        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Ce numéro de téléphone existe déjà dans vos contacts"
            )

    # ✅ Mise à jour de tous les champs
    contact.name = contact_update.name
    contact.phone = contact_update.phone
    contact.email = contact_update.email
    contact.note = contact_update.note
    contact.photo = contact_update.photo
    contact.isFavorite = contact_update.isFavorite

    db.commit()
    db.refresh(contact)

    print(f"✅ Contact mis à jour: ID={contact.id}, Phone={contact.phone}")
    return contact

# 📝 Mettre à jour uniquement le statut favori
@app.patch("/contacts/{contact_id}/favorite")
def update_favorite(
    contact_id: int,
    user_id: int,
    favorite_data: dict,
    db: Session = Depends(get_db)
):
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.user_id == user_id
    ).first()

    if contact is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contact non trouvé"
        )

    contact.isFavorite = favorite_data.get("isFavorite", contact.isFavorite)
    db.commit()

    return {"message": "Statut favori mis à jour", "isFavorite": contact.isFavorite}

# ❌ Supprimer un contact
@app.delete("/contacts/{contact_id}")
def delete_contact(contact_id: int, user_id: int, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(
        Contact.id == contact_id,
        Contact.user_id == user_id
    ).first()

    if contact is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contact non trouvé"
        )

    db.delete(contact)
    db.commit()

    print(f"🗑 Contact supprimé: ID={contact_id}")
    return {"message": "Contact supprimé avec succès"}

# 🗑️ Supprimer tous les contacts d'un utilisateur
@app.delete("/contacts")
def delete_all_contacts(user_id: int, db: Session = Depends(get_db)):
    deleted = db.query(Contact).filter(Contact.user_id == user_id).delete()
    db.commit()
    
    return {"message": f"{deleted} contacts supprimés"}

# 🔍 Rechercher des contacts
@app.get("/contacts/search")
def search_contacts(query: str, user_id: int, db: Session = Depends(get_db)):
    contacts = db.query(Contact).filter(
        Contact.user_id == user_id,
        (Contact.name.contains(query)) | (Contact.phone.contains(query))
    ).all()
    
    return contacts

# ⭐ Récupérer uniquement les favoris
@app.get("/contacts/favorites")
def get_favorites(user_id: int, db: Session = Depends(get_db)):
    return db.query(Contact).filter(
        Contact.user_id == user_id,
        Contact.isFavorite == True
    ).all()

# ================== ENDPOINT TEST ==================

@app.get("/")
def root():
    return {
        "message": "✅ Contact API is running",
        "version": "2.0",
        "endpoints": {
            "POST /contacts": "Créer un contact",
            "GET /contacts?user_id=X": "Lister les contacts",
            "GET /contacts/{id}?user_id=X": "Récupérer un contact",
            "PUT /contacts/{id}": "Mettre à jour un contact",
            "DELETE /contacts/{id}?user_id=X": "Supprimer un contact",
        }
    }

# ================== LANCEMENT ==================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)