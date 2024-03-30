import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionLevelBonus {
  final int id_question_level_bonus;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;

  QuestionLevelBonus({
    required this.id_question_level_bonus,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
  });

}
