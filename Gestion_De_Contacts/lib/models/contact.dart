class Contact {
  final int? id;
  final String name;
  final String phone;
  final String? email;
  final String? note;
  final String? photo;
  final bool isFavorite;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.note,
    this.photo,
    this.isFavorite = false,
  });

  // =========================
  // 🔹 SQLITE (EXISTANT)
  // =========================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'photo': photo,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String?,
      note: map['note'] as String?,
      photo: map['photo'] as String?,
      isFavorite: (map['isFavorite'] as int?) == 1,
    );
  }

  // =========================
  // 🔹 FASTAPI / JSON (AJOUTÉ)
  // =========================
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      note: json['note'] as String?,
      photo: json['photo'] as String?,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'photo': photo,
      'isFavorite': isFavorite,
    };
  }

  // =========================
  // 🔹 UTILS (EXISTANT)
  // =========================
  Contact copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? note,
    String? photo,
    bool? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      note: note ?? this.note,
      photo: photo ?? this.photo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, phone: $phone, email: $email, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
