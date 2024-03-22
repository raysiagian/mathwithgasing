import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/unit/unit.dart';

class Materi {
  final int id;
  final List<Unit> units;
  final String title;
  final String imageCard;
  final String imageBackground;

  Materi({
    required this.id,
    required this.units,
    required this.title,
    required this.imageCard,
    required this.imageBackground,
  });

  Future<List<Map<String, dynamic>>> getMateri()async{
    var url = Uri.parse("http://10.0.2.2:8000/api/getMateri");
    final response = await http.get(url, headers: {"Content-Type": "aplication/json"});
    final List body = json.decode(response.body);
    return List<Map<String, dynamic>>.from(body);
  }

factory Materi.fromJson(Map<String, dynamic> json) {
  return Materi(
    id: json["id"] as int,
    title: json["title"] as String,
    imageCard: json["imageCard"] as String,
    imageBackground: json["imageBackground"] as String,
    units: [], 
  );
}
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageCard': imageCard,
        'imageBackground': imageBackground,
      };

  @override
  String toString() {
    return 'Materi{id: $id, title: $title}';
  }

}
