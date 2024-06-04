class ScorePretest {
  final int idScorePretest;
  final int idPretest;
  final int idUser;
  final int idUnit;
  final int scorePretest;

  ScorePretest({
    required this.idScorePretest,
    required this.idPretest,
    required this.idUser,
    required this.idUnit,
    required this.scorePretest,
  });

  factory ScorePretest.fromJson(Map<String, dynamic> json) {
    return ScorePretest(
      idScorePretest: _parseToInt(json['id_ScorePretest']),
      idPretest: _parseToInt(json['id_pretest']),
      idUser: _parseToInt(json['id_user']),
      idUnit: _parseToInt(json['id_unit']),
      scorePretest: _parseToInt(json['score']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else {
      return 0;
    }
  }
}