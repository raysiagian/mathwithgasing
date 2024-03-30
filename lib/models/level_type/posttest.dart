import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/question_posttest/question_posttest.dart';

class PostTest {
  final int id_posttest;
  final List<QuestionPostTest> questions;
  final int score;

  PostTest({
    required this.id_posttest,
    required this.questions,
    required this.score,
  });

}
