import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';

class UnitBonus {
   final int id_unit_Bonus;
   final String title;
   final String explanation;
   final List<LevelBonus> levelsbonus; // Menambahkan levelbonus sebagai List<LevelButton>

   UnitBonus({
      required this.id_unit_Bonus,
      required this.title,
      required this.explanation,
      required this.levelsbonus, // Menginisialisasi levelbonus
   });

  factory UnitBonus.fromJson(Map<String, dynamic> json) {
    return UnitBonus(
      id_unit_Bonus: json["id_unit_Bonus"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
      levelsbonus: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_unit_Bonus': id_unit_Bonus,
    'title': title,
    'explanation': explanation,
  };

  @override
  String toString() {
    return 'Unit{id_unit_Bonus: $id_unit_Bonus, title: $title, explanation: $explanation}';
  }
}