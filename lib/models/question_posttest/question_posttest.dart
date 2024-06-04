class QuestionPostTest {
  final int id_question_posttest;
  final String question;
  final String posttest_option_1;
  final String posttest_option_2;
  final String posttest_option_3;
  final String posttest_option_4;
  final String posttest_correct_index;
  // final int id_posttest;

  QuestionPostTest({
    required this.id_question_posttest,
    required this.question,
    required this.posttest_option_1,
    required this.posttest_option_2,
    required this.posttest_option_3,
    required this.posttest_option_4,
    required this.posttest_correct_index,
    // required this.id_posttest,
  }) : options = {
          'posttest_option_1': posttest_option_1,
          'posttest_option_2': posttest_option_2,
          'posttest_option_3': posttest_option_3,
          'posttest_option_4': posttest_option_4,
        };

  final Map<String, String> options;

  factory QuestionPostTest.fromJson(Map<String, dynamic> json) {
  return QuestionPostTest(
    id_question_posttest: json['id_question_posttest'] as int,
    question: json['question'] as String? ?? '',
    posttest_option_1: json['posttest_option_1'] as String? ?? '',
    posttest_option_2: json['posttest_option_2'] as String? ?? '',
    posttest_option_3: json['posttest_option_3'] as String? ?? '',
    posttest_option_4: json['posttest_option_4'] as String? ?? '',
    posttest_correct_index: json['posttest_correct_index'] as String,
    // id_posttest: json['id_posttest'] as int,
  );
}

  @override
  String toString() {
    return 'Question(id_question_posttest: $id_question_posttest, question: $question, posttest_option_1: $posttest_option_1, posttest_option_2: $posttest_option_2, posttest_option_3: $posttest_option_3, posttest_option_4: $posttest_option_4, posttest_correct_index: $posttest_correct_index)';
  }
}
