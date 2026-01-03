class Contact {
  int? id;
  String name;
  String phone;
  String? email;
  String? note;
  String? photo;
  bool isFavorite;
  int? userId; // ✅ ID de l'utilisateur propriétaire

  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    this.photo,
    this.isFavorite = false,
    this.userId,
  });

  // Conversion depuis JSON (API)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      note: json['note'],
      photo: json['photo'],
      isFavorite: json['isFavorite'] ?? false,
      userId: json['user_id'], // ✅ user_id depuis l'API
    );
  }

  // Conversion vers JSON (API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'photo': photo,
      'isFavorite': isFavorite,
      if (userId != null) 'user_id': userId, // ✅ user_id vers l'API
    };
  }

  // Conversion depuis Map (SQLite local si utilisé)
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      note: map['note'],
      photo: map['photo'],
      isFavorite: map['isFavorite'] == 1,
      userId: map['user_id'],
    );
  }

  // Conversion vers Map (SQLite local si utilisé)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'photo': photo,
      'isFavorite': isFavorite ? 1 : 0,
      if (userId != null) 'user_id': userId,
    };
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phone: $phone, userId: $userId)';
  }
}