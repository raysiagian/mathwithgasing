import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';

class Level {
  final int id_level;
  final int level_number;
  final int id_unit;

  Level({
    required this.id_level,
    required this.level_number,
    required this.id_unit,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
  return Level(
    id_level: int.parse(json["id_level"].toString()),
    level_number: int.parse(json["level_number"].toString()),
    id_unit: int.parse(json["id_unit"].toString()),
  );
}


  static Future<List<Level>> getLevels() async {
    try {
      var url = Uri.parse(baseurl + "api/getLevel");
      final response = await http.get(url, headers: {"Content-type": "application/json"});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> jsonData = responseData['data'];
        return jsonData.map((json) => Level.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load levels from API');
      }
    } catch (e) {
      throw Exception('Error fetching levels: $e');
    }
  }

  Map<String, dynamic> toJson() => {
    'id_level': id_level,
    'level_number': level_number,
    'id_unit': id_unit,
  };

  @override
  String toString() {
    return 'Level{id_level: $id_level, level_number: $level_number, id_unit: $id_unit}';
  }
}