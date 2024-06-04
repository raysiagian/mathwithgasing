import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';

class UnitBonus {
   final int id_unit_Bonus;
   final String title;
   final String explanation;

    
   UnitBonus({
      required this.id_unit_Bonus,
      required this.title,
      required this.explanation,
   });

  factory UnitBonus.fromJson(Map<String, dynamic> json) {
    return UnitBonus(
      id_unit_Bonus: json['id_unit_Bonus'] as int,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
    );
  }

  @override
  String toString() {
    return 'Unit{id_unit_Bonus: $id_unit_Bonus, title: $title, explanation: $explanation}';
  }
}