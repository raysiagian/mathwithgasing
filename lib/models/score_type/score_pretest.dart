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
      idScorePretest: json['id_ScorePretest'] ?? 0,
      idPretest: json['id_pretest'] ?? 0,
      idUser: json['id_user'] ?? 0,
      idUnit: json['id_unit'] ?? 0,
      scorePretest: json['score'] ?? 0,
    );
  }
}
