import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/question_level_bonus/question_level_bonus.dart';

class LevelBonus {
  final int id_level_bonus;
  final int level_number;
  final int id_unit_bonus;
  final List<QuestionLevelBonus> questionsLevelBonus;

  LevelBonus({
    required this.id_level_bonus,
    required this.level_number,
    required this.id_unit_bonus,
    this.questionsLevelBonus = const [],
  });

    factory LevelBonus.fromJson(Map<String, dynamic> json) {
    return LevelBonus(
      id_level_bonus: int.parse(json["id_level_bonus"].toString()),
      level_number: int.parse(json["level_number"].toString()),
      id_unit_bonus: int.parse(json["id_unit_Bonus"].toString()), // Perbaikan di sini
    );
  }


  static Future<List<LevelBonus>> getLevelsBonus() async {
    try {
      var url = Uri.parse(baseurl + "api/getLevelBonus");
      final response = await http.get(url, headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];
        return jsonData.map((json) => LevelBonus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load levels from API');
      }
    } catch (e) {
      throw Exception('Error fetching levels: $e');
    }
  }

  

  static Future<void> updateFinalScore(int id, int score) async {
    try {
      var url = Uri.parse(baseurl + "api/updateFinalScore/$id");
      final response = await http.put(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode({"score_pretest": score}),
      );

      if (response.statusCode == 200) {
        print("Score updated successfully");
      } else {
        throw Exception('Failed to update score: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal Memperbaharui Skor: $e');
    }
  }

  Map<String, dynamic> toJson() => {
        'id_level_bonus': id_level_bonus,
        'level_number': level_number,
        'id_unit_bonus': id_unit_bonus,
      };

  @override
  String toString() {
    return 'Level{id_level_bonus: $id_level_bonus, level_number: $level_number, id_unit_bonus: $id_unit_bonus}';
  }
}