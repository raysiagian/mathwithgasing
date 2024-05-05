import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';

class QuestionPostTest {
  final int id_question_posttest;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;
  final String correct_index;
  final int id_posttest;

  QuestionPostTest({
    required this.id_question_posttest,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
    required this.correct_index,
    required this.id_posttest,
  }) : options = {
          'option_1': option_1,
          'option_2': option_2,
          'option_3': option_3,
          'option_4': option_4,
        };

  final Map<String, String> options;

  factory QuestionPostTest.fromJson(Map<String, dynamic> json) {
  return QuestionPostTest(
    id_question_posttest: json['id_question_posttest'] as int,
    question: json['question'] as String? ?? '',
    option_1: json['option_1'] as String? ?? '',
    option_2: json['option_2'] as String? ?? '',
    option_3: json['option_3'] as String? ?? '',
    option_4: json['option_4'] as String? ?? '',
    correct_index: json['correct_index'] as String,
    id_posttest: json['id_posttest'] as int,
  );
}

  @override
  String toString() {
    return 'Question(id_question_posttest: $id_question_posttest, question: $question, option_1: $option_1, option_2: $option_2, option_3: $option_3, option_4: $option_4, correct_index: $correct_index, id_posttest: $id_posttest)';
  }
}
