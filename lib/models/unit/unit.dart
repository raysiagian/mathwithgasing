import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/models/level/level.dart';

class Unit {
   final int id;
   final String title;
   final String explanation;
   final List<Level> levels; // Menambahkan levels sebagai List<LevelButton>

   Unit({
      required this.id,
      required this.title,
      required this.explanation,
      required this.levels, // Menginisialisasi levels
   });

 Future<List<Unit>> getUnitFromAPI() async {
    try {
      var url = Uri.parse("http://10.0.2.2:8000/api/getUnit");
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


  factory Unit.fromJson(Map<String, dynamic> json){
    return Unit(
      id: json["id"] as int, 
      title: json["title"] as String, 
      explanation: json["explanation"] as String, 
      levels: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'explanation': explanation,

  };

  @override
  String toString() {
    return 'Unit{id: $id, title: $title, explanation: $explanation}';
  }

}