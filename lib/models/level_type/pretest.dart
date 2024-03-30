import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/question_pretest/question_pretest.dart';

class PreTest {
  final int id_pretest;
  final List<QuestionPretest> questionsPretest;
  final int score;

  PreTest({
    required this.id_pretest,
    required this.questionsPretest,
    required this.score,
  });

}
