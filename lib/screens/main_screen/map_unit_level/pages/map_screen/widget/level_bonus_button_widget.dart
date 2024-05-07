import 'package:flutter/material.dart';
import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/level_bonus_screen/pages/level_bonus_page.dart';

class LevelBonusButtonWidget extends StatelessWidget {
  const LevelBonusButtonWidget({
    Key? key,
    required this.levelBonus,
    required this.materi,
  }) : super(key: key);

  final LevelBonus levelBonus;
  final Materi materi;

  Future<List<LevelBonus>> fetchLevelsBonus() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getLevelBonus'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => LevelBonus.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch level bonus data: ${response.headers}');
      }
    } catch (e) {
      throw Exception('Error fetching level bonus data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LevelBonusButtonWidget - levelBonus: $levelBonus');
    return InkWell(
      onTap: () async {
        if (levelBonus.level_number == 1) {
          try {
            print('Fetching level bonus data...');
            List<LevelBonus> bonuses = await fetchLevelsBonus();
            print('Level Bonus data fetched successfully: $bonuses');

            LevelBonus bonus = bonuses.firstWhere((bonus) => bonus.id_level_bonus == levelBonus.id_level_bonus);
            print('Level Bonus for current level found: $bonus');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Level Bonus ID: ${bonus.id_level_bonus}'),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LevelBonusPage(
                  levelBonus: levelBonus,
                  materi: materi,
                ),
              ),
            );
          } catch (e) {
            // Handle error
            print('Error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
              ),
            );
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              levelBonus.level_number.toString(),
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}