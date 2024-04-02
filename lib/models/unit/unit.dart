import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<List<Unit>> getUnit() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/unit");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      var example = [
        {
          "id_unit": 1,
          "title": "Unit 1",
          "explanation": "Explanation for Unit 1",
          "levels": [
            {
              "id_level": 1,
              "title": "Level 1",
              "description": "Description for Level 1"
            },
            {
              "id_level": 2,
              "title": "Level 2",
              "description": "Description for Level 2"
            }
          ]
        },
        {
          "id_unit": 2,
          "title": "Unit 2",
          "explanation": "Explanation for Unit 2",
          "levels": [
            {
              "id_level": 3,
              "title": "Level 3",
              "description": "Description for Level 3"
            },
            {
              "id_level": 4,
              "title": "Level 4",
              "description": "Description for Level 4"
            }
          ]
        }
      ];

      List<Unit> data = example.map((e) => Unit.fromJson(e)).toList();
      return data;

    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }

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
