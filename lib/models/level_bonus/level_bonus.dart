import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/question_level_bonus/question_level_bonus.dart';

class LevelBonus{
  final int id_level_bonus;
  final int level_number;
  final List<QuestionLevelBonus> questions;
  final int score;

  LevelBonus({
    required this.id_level_bonus,
    required this.level_number,
    required this.questions,
    required this.score,
  });

}
