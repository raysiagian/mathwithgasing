import 'package:mathgasing/models/question_pretest/question_pretest.dart';

class PreTest {
  final int id_pretest;
  final List<QuestionPretest> questionsPretest;
  // final int? score_pretest;
  final int id_level;

  PreTest({
    required this.id_pretest,
    required this.questionsPretest,
    // required this.score_pretest,
    required this.id_level,
  });

  factory PreTest.fromJson(Map<String, dynamic> json){
  return PreTest(
    id_pretest: json["id_pretest"] as int, 
    id_level: json["id_level"] as int,
    questionsPretest: [], 
    // score_pretest: json["score_pretest"] as int?,
  );
}

  Map<String, dynamic> toJson()=> {
    'id_pretest': id_pretest,
    // 'score_pretest': score_pretest,
    'id_level': id_level,
  };

   Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'API Token',
     };

  @override
  String toString() {
    return 'Materi{id_pretest: $id_pretest, id_level: $id_level}';
  }

}