import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Level {
  final int id_level;
  final int level_number;
  final int id_unit;

  Level({
    required this.id_level,
    required this.level_number,
    required this.id_unit,

  });

  get number => null;

  get id_pretest => null;

  get questionsPretest => null;

  get id_material_video => null;

  get id_posttest => null;

  get questionsPosttest => null;

  Future<List<Level>> getLevel() async {
    try {
      var url = Uri.parse("http://127.0.0.1:8000/api/level");
      final response = await http.get(url, headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Level.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load levels from API');
      }
    } catch (e) {
      throw Exception('Error fetching levels: $e');
    }
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id_level: json["id_level"] as int,
      level_number: json["level_number"] as int,
      id_unit: json["level_number"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_level': id_level,
    'level_number': level_number,
    'id_unit': id_unit,
  };

  @override
  String toString(){
    return 'Level{id_level: $id_level, level_number: $level_number, id_unit: $id_unit}';
  }
}
