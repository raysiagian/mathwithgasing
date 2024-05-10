class Materi {
  final int id_materi;
  final String title;
  final String imageCard;
  final String imageBackground;
  final String imageStatistic;

  Materi({
    required this.id_materi,
    required this.title,
    required this.imageCard,
    required this.imageBackground,
    required this.imageStatistic,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id_materi: json["id_materi"] as int,
      title: json["title"] as String,
      imageCard: json["imageCard"] as String,
      imageBackground: json["imageBackground"] as String,
      imageStatistic: json["imageStatistic"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_materi': id_materi,
    'title': title,
    'imageCard': imageCard,
    'imageBackground': imageBackground,
    'imageStatistic': imageStatistic,
  };

  @override
  String toString() {
    return 'Materi{id_materi: $id_materi, title: $title}';
  }
}
