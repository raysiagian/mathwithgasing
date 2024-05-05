import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
class User {
  final int id_user;
  final String name;
  final String email;
  final String gender;


  User({
    required this.id_user,
    required this.name,
    required this.email,
    // required this.password,
    required this.gender,
    // required this.createdAt,
    // this.updatedAt,
  });
  
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
