import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionLevelBonus {
  final int id_question_level_bonus;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;
  final String correct_index;
  final int id_level_bonus;

  QuestionLevelBonus({
    required this.id_question_level_bonus,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
    required this.correct_index,
    required this.id_level_bonus,
  }) : options = {
    'option_1': option_1,
    'option_2': option_2,
    'option_3': option_3,
    'option_4': option_4,
  };

    final Map<String, String> options;

  factory QuestionLevelBonus.fromJson(Map<String, dynamic> json) {
    return QuestionLevelBonus(
      id_question_level_bonus: json['id_question_level_bonus'] as int,
      question: json['question'] as String,
      option_1: json['option_1'] as String,
      option_2: json['option_2'] as String,
      option_3: json['option_3'] as String,
      option_4: json['option_4'] as String,
      correct_index: json['correct_index'] as String,
      id_level_bonus: json['id_level_bonus'] as int,
    );
  }

    static Future<List<QuestionLevelBonus>> getQuestionFromAPI() async {
    try {
      var url = Uri.parse("http://127.0.0.1:8000/api/getQuestionLevelBonus");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => QuestionLevelBonus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions from API');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

    @override
  String toString() {
    return 'Question(id_question_level_bonus: $id_question_level_bonus, question: $question, option_1: $option_1, option_2: $option_2, option_3: $option_3, option_4: $option_4, correct_index: $correct_index, id_level_bonus: $id_level_bonus)';
  }

}
