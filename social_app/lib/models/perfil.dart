class Perfil {
  final String id;
  final String email;
  final String passwordHash;

  Perfil({
    required this.id,
    required this.email,
    required this.passwordHash,
  });

  // Convertir un JSON en un objecte Perfil
  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['id'],
      email: json['email'],
      passwordHash: json['passwordHash'],
    );
  }

  // Convertir un objecte Perfil a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
    };
  }
}
