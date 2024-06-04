import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/level_bonus_button_widget.dart';

class UnitBonusWidget extends StatelessWidget {
  const UnitBonusWidget({
    Key? key,
    required this.unitBonus,
    required this.materi,
  }) : super(key: key);

  final UnitBonus unitBonus;
  final Materi materi;

  Future<List<LevelBonus>> fetchLevelsBonus() async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/levelbonus/getByUnit/${unitBonus.id_unit_Bonus}'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((e) => LevelBonus.fromJson(e)).toList();
        } else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            final levelData = jsonData['data'];
            if (levelData is List) {
              return levelData.map((e) => LevelBonus.fromJson(e)).toList();
            } else {
              return [LevelBonus.fromJson(levelData)];
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
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            padding: const EdgeInsets.only(left: 10.0, top: 30),
            height: 170,
            color: Color.fromRGBO(0, 0, 0, 0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unitBonus.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  unitBonus.explanation,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<LevelBonus>>(
          future: fetchLevelsBonus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
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
              return Column(
                children: snapshot.data!.map((levelBonus) {
                  return LevelBonusButtonWidget(
                    levelBonus: levelBonus,
                    materi: materi,
                    unit_bonus: unitBonus,
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