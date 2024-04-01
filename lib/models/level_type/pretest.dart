import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/question_pretest/question_pretest.dart';

class PreTest {
  final int id_pretest;
  final List<QuestionPretest> questionsPretest;
  final int? score;

  PreTest({
    required this.id_pretest,
    required this.questionsPretest,
    required this.score,
  });

  factory PreTest.fromJson(Map<String, dynamic> json){
    return PreTest(
      id_pretest: json["id_pretest"] as int, 
      questionsPretest: [], 
      score: json["score"] as int,
    );
  }

  static Future<List<PreTest>>getPretest()async{
    var url = Uri.parse("http://10.0.2.2:8000/api/pretest"); // Adjusted URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)["data"];
      return body.map((dynamic item) => PreTest.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load materi');
    }
  }

  Map<String, dynamic> toJson()=> {
    'id_pretest': id_pretest,
    'score': score,
  };

  @override
  String toString() {
    return 'Materi{id_pretest: $id_pretest, score: $score}';
  }

}
