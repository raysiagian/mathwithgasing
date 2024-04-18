import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
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
    id_level: int.parse(json["id_level"]), // Parse id_level as an integer
    questionsPretest: [], 
    // score_pretest: json["score_pretest"] as int?,
  );
}

  static Future<List<PreTest>>getPretest()async{
    var url = Uri.parse("https://mathgasing.cloud/api/getPretest"); // Adjusted URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)["data"];
      return body.map((dynamic item) => PreTest.fromJson(item)).toList();
      } else {
        throw Exception('${response.statusCode}');
    }
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