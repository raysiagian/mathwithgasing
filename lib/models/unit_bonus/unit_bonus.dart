import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';

class UnitBonus {
   final int id;
   final String title;
   final String explanation;
   final List<LevelBonus> levelbonuses; // Menambahkan levelbonuses sebagai List<LevelButton>

   UnitBonus({
      required this.id,
      required this.title,
      required this.explanation,
      required this.levelbonuses, // Menginisialisasi levelbonuses
   });

 Future<List<UnitBonus>> getUnitFromAPI() async {
    try {
      var url = Uri.parse(baseurl +"api/getUnit");
      final response = await http.get(url, headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => UnitBonus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load units from API');
      }
    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }


  factory UnitBonus.fromJson(Map<String, dynamic> json){
    return UnitBonus(
      id: json["id"] as int, 
      title: json["title"] as String, 
      explanation: json["explanation"] as String, 
      levelbonuses: [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'explanation': explanation,

  };

  @override
  String toString() {
    return 'UnitBonus{id: $id, title: $title, explanation: $explanation}';
  }

}