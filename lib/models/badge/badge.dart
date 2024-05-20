class Badge {
  final int id_posttest;
  final String image;
  final String title;
  final String explanation;

  Badge({
    required this.id_posttest,
    required this.image,
    required this.title,
    required this.explanation,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id_posttest: json["id_posttest"] as int,
      image: json['image'] ?? '', // Tambahkan pengecekan null di sini
      title: json['title'] ?? '', // Tambahkan pengecekan null di sini
      explanation: json['explanation'] ?? '', // Tambahkan pengecekan null di sini
    );
  }

  @override
  String toString() {
    return 'Badge{id_posttest: $id_posttest, image: $image, title: $title, explanation: $explanation}';
  }
}