class ScorePosttest {
  final int idScorePosttest;
  final int idPosttest;
  final int idUser;
  final int idUnit;
  final int scorePosttest;

  ScorePosttest({
    required this.idScorePosttest,
    required this.idPosttest,
    required this.idUser,
    required this.idUnit,
    required this.scorePosttest,
  });

  factory ScorePosttest.fromJson(Map<String, dynamic> json) {
    return ScorePosttest(
      idScorePosttest: _parseToInt(json['id_ScorePosttest']),
      idPosttest: _parseToInt(json['id_posttest']),
      idUser: _parseToInt(json['id_user']),
      idUnit: _parseToInt(json['id_unit']),
      scorePosttest: _parseToInt(json['score']),
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