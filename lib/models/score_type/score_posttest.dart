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
      idScorePosttest: json['id_ScorePosttest'] ?? 0,
      idPosttest: json['id_posttest'] ?? 0,
      idUser: json['id_user'] ?? 0,
      idUnit: json['id_unit'] ?? 0,
      scorePosttest: json['score'] ?? 0,
    );
  }
}
