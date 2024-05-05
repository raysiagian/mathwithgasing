import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';

class Materi {
  final int id_materi;
  final List<Unit> units;
  final String title;
  final String imageCard;
  final String imageBackground;
  final String imageStatistic;

  Materi({
    required this.id_materi,
    required this.units,
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
      units: [], // You might need to adjust this depending on your data structure
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
