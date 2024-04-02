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


  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id_level: json["id_level"],
      level_number: json["level_number"],
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
