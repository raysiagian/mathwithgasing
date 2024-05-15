import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
class User {
  final int id_user;
  final String name;
  final String email;
  final String gender;
  final int lives;
  final String createdAt;


  User({
    required this.id_user,
    required this.name,
    required this.email,
    // required this.password,
    required this.gender,
    required this.lives,
    required this.createdAt,
    // this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id_user: json['id_user'],
      name: json['name'],
      email: json['email'],
      // password: json['password'],
      gender: json['gender'],
      lives: json['lives'],
      createdAt: json.containsKey('created_at') ? json['created_at'] : null, 

      // updatedAt: json['updated_at'] != null ? json['updated_at'].toString() : null, // Convert to String if not null
    );
  }
  

  Map<String, dynamic> toJson() => {
      'id_user': id_user,
      'name': name,
      'email': email,
      // 'password': password,
      'gender': gender,
      'lives': lives,
      if (createdAt != null) 'created_at': createdAt,

      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
  };

  @override
  String toString(){
    return'User{id-user: $id_user, name : $name, email : $email, gender : $gender, lives: $lives}';
  }


}
