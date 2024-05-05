import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/question_posttest/question_posttest.dart';

class PostTest {
  final int id_posttest;
  final List<QuestionPostTest> questionsPosttest;
  final int id_level;

  PostTest({
    required this.id_posttest,
    required this.questionsPosttest,
    required this.id_level,

  });

  
  factory PostTest.fromJson(Map<String, dynamic> json){
    return PostTest(
      id_posttest: json["id_posttest"] as int, 
      id_level: json["id_level"] as int,
      questionsPosttest: [],
      // score_pretest: json["score_pretest"] as int?,
    );
  }


  Map<String, dynamic> toJson()=> {
    'id_posttest': id_posttest,
    // 'score_posttest': score_posttest,
    'id_level': id_level,
  };

   Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'API Token',
     };

  @override
  String toString() {
    return 'Materi{id_posttest: $id_posttest, id_level: $id_level}';
  }

}
