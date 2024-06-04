class Badge {
  final int id_bagde;
  final String image;
  final String imageUrl;
  final String title;
  final String explanation;

  Badge({
    required this.id_bagde,
    required this.image,
    required this.imageUrl,
    required this.title,
    required this.explanation,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id_bagde: json["id_bagde"] as int,
      image: json['image'] ?? '',
      imageUrl: json["imageUrl"] ?? '',  
      title: json['title'] ?? '',
      explanation: json['explanation'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Badge{id_bagde:$id_bagde, image: $image, title: $title, explanation: $explanation, imageUrl: $imageUrl}';
  }
}