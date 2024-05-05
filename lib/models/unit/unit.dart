import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level/level.dart';

class Unit {
  final int id_unit;
  final String title;
  final String explanation;
  final List<Level> levels;
  

  Unit({
    required this.id_unit,
    required this.title,
    required this.explanation,
    required this.levels,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id_unit: json["id_unit"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      levels: [],
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
