class User {
  final int id_user;
  final String name;
  final String email;
  final String gender;
  final int lives;
  final String is_active;
  final String createdAt;  // Changed to String
  final String updatedAt;  // Changed to String

  User({
    required this.id_user,
    required this.name,
    required this.email,
    required this.gender,
    required this.lives,
    required this.is_active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id_user: json['id_user'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      lives: int.parse(json['lives']),
      is_active: json['is_active'] as String,
      createdAt: json['created_at'] as String,  // Parse as String
      updatedAt: json['updated_at'] as String,  // Parse as String
    );
  }
}
