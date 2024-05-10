import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';


class Unit {
  final int id_unit;
  final String title;
  final String explanation;


  Unit({
    required this.id_unit,
    required this.title,
    required this.explanation,

  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id_unit: json["id_unit"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_unit': id_unit,
    'title': title,
    'explanation': explanation,
  };

  @override
  String toString() {
    return 'Unit{id_unit: $id_unit, title: $title, explanation: $explanation}';
  }
}
