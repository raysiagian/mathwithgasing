
class QuestionLevelBonus {
  final int id_question_level_bonus;
  final String question;
  final String option_1;
  final String option_2;
  final String option_3;
  final String option_4;
  final String correct_index;
  // final int id_level_bonus;

  QuestionLevelBonus({
    required this.id_question_level_bonus,
    required this.question,
    required this.option_1,
    required this.option_2,
    required this.option_3,
    required this.option_4,
    required this.correct_index,
    // required this.id_level_bonus,
  });

  factory QuestionLevelBonus.fromJson(Map<String, dynamic> json) {
    return QuestionLevelBonus(
      id_question_level_bonus: json['id_question_level_bonus'] as int,
      question: json['question'] as String,
      option_1: json['option_1'] as String,
      option_2: json['option_2'] as String,
      option_3: json['option_3'] as String,
      option_4: json['option_4'] as String,
      correct_index: json['correct_index'] as String,
      // id_level_bonus: json['id_level_bonus'] as int,
    );
  }


  @override
  String toString() {
    return 'Question(id_question_level_bonus: $id_question_level_bonus, question: $question, option_1: $option_1, option_2: $option_2, option_3: $option_3, option_4: $option_4, correct_index: $correct_index,)';
  }
}
