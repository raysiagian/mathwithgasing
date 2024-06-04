class QuestionPretest {
  final int id_question_pretest;
  final String question;
  final String pretest_option_1;
  final String pretest_option_2;
  final String pretest_option_3;
  final String pretest_option_4;
  final String pretest_correct_index;
  // final int id_pretest;

  QuestionPretest({
    required this.id_question_pretest,
    required this.question,
    required this.pretest_option_1,
    required this.pretest_option_2,
    required this.pretest_option_3,
    required this.pretest_option_4,
    required this.pretest_correct_index,
    // required this.id_pretest,

  }) : options = {
    'pretest_option_1': pretest_option_1,
    'pretest_option_2': pretest_option_2,
    'pretest_option_3': pretest_option_3,
    'pretest_option_4': pretest_option_4,
  };

  // Tambahkan deklarasi options di sini
  final Map<String, String> options;

  factory QuestionPretest.fromJson(Map<String, dynamic> json) {
    return QuestionPretest(
      id_question_pretest: json['id_question_pretest'] as int,
      question: json['question'] as String,
      pretest_option_1: json['pretest_option_1'] as String,
      pretest_option_2: json['pretest_option_2'] as String,
      pretest_option_3: json['pretest_option_3'] as String,
      pretest_option_4: json['pretest_option_4'] as String,
      pretest_correct_index: json['pretest_correct_index'] as String,
      // id_pretest: json['id_pretest'] as int,
    );
  }
   
  @override
  String toString() {
    return 'Question(id_question_prestest: $id_question_pretest, question: $question, pretest_option_1: $pretest_option_1, pretest_option_2: $pretest_option_2, pretest_option_3: $pretest_option_3, pretest_option_4: $pretest_option_4, pretest_correct_index: $pretest_correct_index,)';
  }
}