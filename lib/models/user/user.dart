import 'dart:convert';
import 'package:http/http.dart' as http;
class User {
  final int id_user;
  final String name;
  final String email;
  // final String password;
  final String gender;

  // final String createdAt;
  // final String? updatedAt;

  User({
    required this.id_user,
    required this.name,
    required this.email,
    // required this.password,
    required this.gender,
    // required this.createdAt,
    // this.updatedAt,
  });

  static Future<List<User>> fetchUser() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getUser'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData != null) {
          if (jsonData is List) {
            return jsonData.map((e) => User.fromJson(e)).toList();
          } else if (jsonData is Map<String, dynamic>) {
            if (jsonData.containsKey('data')) {
              final userData = jsonData['data'];
              if (userData != null) {
                if (userData is List) {
                  return userData.map((e) => User.fromJson(e)).toList();
                } else {
                  return [User.fromJson(userData)];
                }
              } else {
                throw Exception('Null user data received from API');
              }
            } else {
              throw Exception('Missing "data" key in API response');
            }
          } else {
            throw Exception('Unexpected data format');
          }
        } else {
          throw Exception('Null JSON data received from API');
        }
      } else {
        throw Exception('Failed to load users from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id_user: json['id_user'],
      name: json['name'],
      email: json['email'],
      // password: json['password'],
      gender: json['gender'],
      // createdAt: json['created_at'].toString(), // Convert to String
      // updatedAt: json['updated_at'] != null ? json['updated_at'].toString() : null, // Convert to String if not null
    );
  }
  

  Map<String, dynamic> toJson() => {
      'id_user': id_user,
      'name': name,
      'email': email,
      // 'password': password,
      'gender': gender,
      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
  };

  @override
  String toString(){
    return'User{id-user: $id_user, name : $name, email : $email, gender : $gender}';
  }


}
