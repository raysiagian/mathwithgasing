import 'dart:convert';
import 'package:http/http.dart' as http;
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
      id_level: json["id_level"]as int,
      questionsPosttest: [],
      // score_pretest: json["score_pretest"] as int?,
    );
  }

    static Future<List<PostTest>>getPretest()async{
    var url = Uri.parse("http://10.0.2.2:8000/api/getPosttest"); // Adjusted URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)["data"];
      return body.map((dynamic item) => PostTest.fromJson(item)).toList();
      } else {
        throw Exception('${response.statusCode}');
    }
  }

    Map<String, dynamic> toJson()=> {
    'id_posttest': id_posttest,
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
    return 'Materi{id_posttest: $id_posttest, id_level: $id_level}';
  }


}
