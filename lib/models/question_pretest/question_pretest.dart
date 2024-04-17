import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionPretest {
  final int id_question_pretest;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;
  final String correct_index;

  QuestionPretest({
    required this.id_question_pretest,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
    required this.correct_index,
  }) : options = {
    'option_1': option_1,
    'option_2': option_2,
    'option_3': option_3,
    'option_4': option_4,
  };

  // Tambahkan deklarasi options di sini
  final Map<String, String> options;

  factory QuestionPretest.fromJson(Map<String, dynamic> json) {
    return QuestionPretest(
      id_question_pretest: json['id_question_pretest'] as int,
      question: json['question'] as String,
      option_1: json['option_1'] as String,
      option_2: json['option_2'] as String,
      option_3: json['option_3'] as String,
      option_4: json['option_4'] as String,
      correct_index: json['correct_index'] as String,
    );
  }

  static Future<List<QuestionPretest>> getQuestionFromAPI() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/questionpretest");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => QuestionPretest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions from API');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
   
  @override
  String toString() {
    return 'Question(id_question_prestest: $id_question_pretest, question: $question, option_1: $option_1, option_2: $option_2, option_3: $option_3, option_4: $option_4, correct_index: $correct_index)';
  }
}