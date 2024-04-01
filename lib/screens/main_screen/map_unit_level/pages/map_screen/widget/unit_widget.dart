import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Import http package
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/level_button_widget.dart';

class UnitWidget extends StatelessWidget {
  const UnitWidget({
    Key? key,
    required this.unit,
    required this.materi,
  }) : super(key: key);

  final Unit unit;
  final Materi materi;

  Future<List<Level>> fetchLevel() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/getLevel'), // Updated endpoint
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          // If jsonData is a list, parse it as a list of units
          return jsonData.map((e) => Level.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          // If jsonData is a map, check if it contains a 'data' key
          if (jsonData.containsKey('data')) {
            final levelData = jsonData['data'];
            if (levelData is List) {
              // If 'data' is a list, parse it as a list of units
              return levelData.map((e) => Level.fromJson(e)).toList();
            } else {
              // If 'data' is a single object, parse it as a single unit
              return [Level.fromJson(levelData)];
            }
          } else {
            throw Exception('Missing "data" key in API response');
          }
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load levels from API');
      }
    } catch (e) {
      throw Exception('Error fetching levels: $e');
    }
  }

 @override
  Widget build(BuildContext context) {
    // Panggil fungsi fetchLevels() saat UnitWidget dibuat atau dirender
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0), // Margin 20 px ke atas dan ke bawah
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, top: 30),
            height: 170,
            color: Color.fromRGBO(0, 0, 0, 0.4),
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  unit.explanation,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  )
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Gunakan FutureBuilder untuk menampilkan widget ketika data level sudah tersedia
        FutureBuilder<List<Level>>(
          future: fetchLevel(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // Tampilkan indikator loading
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available'),
              );
            } else {
              // Tampilkan tombol level jika data sudah tersedia
              return Column(
                children: snapshot.data!.map((level) {
                  return LevelButtonWidget(
                    level: level,
                    materi: materi,
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

}
