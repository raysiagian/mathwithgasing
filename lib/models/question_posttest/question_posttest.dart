import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionPostTest {
  final int id_question_posttest;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;

  QuestionPostTest({
    required this.id_question_posttest,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
  });

}
