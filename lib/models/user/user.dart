class User {
  final int id_user;
  final String name;
  final String email;
  final String password;
  final String gender;

  final String createdAt;
  final String? updatedAt;

  User({
    required this.id_user,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id_user: json['id_user'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      createdAt: json['created_at'].toString(), // Convert to String
      updatedAt: json['updated_at'] != null ? json['updated_at'].toString() : null, // Convert to String if not null
    );
  }

  
  //   static Future<User> fetchUser() async {
  //   final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/'));

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     return User.fromJson(jsonData);
  //   } else {
  //     throw Exception('Failed to fetch user data');
  //   }
  // }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id_user,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}