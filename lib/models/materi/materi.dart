import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';

class Materi {
  final int id_materi;
  final List<Unit> units;
  final String title;
  final String imageCard;
  final String imageBackground;

  Materi({
    required this.id_materi,
    required this.units,
    required this.title,
    required this.imageCard,
    required this.imageBackground,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id_materi: json["id_materi"] as int,
      title: json["title"] as String,
      imageCard: json["imageCard"] as String,
      imageBackground: json["imageBackground"] as String,
      units: [], // You might need to adjust this depending on your data structure
    );
  }

  static Future<List<Materi>> getMateri() async {
    var url = Uri.parse("http://10.0.2.2:8000/api/materi"); // Adjusted URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body)["data"];
      return body.map((dynamic item) => Materi.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load materi');
    }
  }

  Map<String, dynamic> toJson() => {
    'id_materi': id_materi,
    'title': title,
    'imageCard': imageCard,
    'imageBackground': imageBackground,
  };

  @override
  String toString() {
    return 'Materi{id_materi: $id_materi, title: $title}';
  }
}
