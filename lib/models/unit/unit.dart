import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/level/level.dart';

class Unit {
  final int id_unit;
  final String title;
  final String explanation;

  Unit({
    required this.id_unit,
    required this.title,
    required this.explanation,
  });

  Future<List<Unit>> getUnitFromAPI() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/unit");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Unit.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load units from API');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id_unit: json["id_unit"] as int,
      title: json["title"] as String,
      explanation: json["explanation"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_unit': id_unit,
        'title': title,
        'explanation': explanation,
      };

  @override
  String toString() {
    return 'Unit{id_unit: $id_unit, title: $title, explanation: $explanation}';
  }
}
