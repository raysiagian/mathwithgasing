import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Level {
  final int id_level;
  final int level_number;

  Level({
    required this.id_level,
    required this.level_number,
  });

  get questionsPretest => null;

  get number => null;

  get id_pretest => null;

    Future<List<Level>> getLevel() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/level");
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
    );
  }

  Map<String, dynamic> toJson() => {
    'id_level': id_level,
    'level_number': level_number,
  };

  //  void navigateToPage(BuildContext context) {
  //   switch (level_number) {
  //     case 1:
  //       Navigator.pushNamed(context, '/pretestScreen');
  //       break;
  //     case 2:
  //       Navigator.pushNamed(context, '/materialScreen');
  //       break;
  //     case 3:
  //       Navigator.pushNamed(context, '/posttestScreen');
  //       break;
  //     default:
  //       // Do something if level_number is not 1, 2, or 3
  //       break;
  //   }
  // }

  @override
  String toString(){
    return 'Level{id_level: $id_level, level_number: $level_number}';
  }

}
