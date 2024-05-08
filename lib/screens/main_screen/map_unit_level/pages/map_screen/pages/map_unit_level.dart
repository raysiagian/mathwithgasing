import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_bonus_widget.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_widget.dart';

class MapUnitLevel extends StatelessWidget {
  MapUnitLevel({Key? key}) : super(key: key);

  final Materi materi = Materi(
    id_materi: 1,
    units: [
      Unit(
        id_unit: 1,
        title: 'title',
        explanation: 'explanation',
        levels: [Level(id_level: 2, level_number: 2, id_unit: 2)],
      ),
      Unit(
        id_unit: 1,
        title: 'title',
        explanation: 'explanation',
        levels: [Level(id_level: 2, level_number: 2, id_unit: 2)],
      ),
      Unit(
        id_unit: 1,
        title: 'title',
        explanation: 'explanation',
        levels: [Level(id_level: 2, level_number: 2, id_unit: 2)],
      ),
    ],
    title: 'title',
    imageCard: 'imageCard',
    imageBackground: 'imageBackground',
    imageStatistic: 'imageStatistic',
  );
  final Unit unit = Unit(
    id_unit: 1,
    title: 'title',
    explanation: 'explanation',
    levels: [
      Level(id_level: 2, level_number: 1, id_unit: 1),
    ],
  );
  final UnitBonus unitBonus = UnitBonus(
    id_unit_Bonus: 1,
    title: 'title',
    explanation: 'explanation',
    levelsbonus: [
      LevelBonus(id_level_bonus: 2, level_number: 2, id_unit_bonus: 2),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          materi.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeWrapper()),
              (route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/penjumlahan_map_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                UnitWidget(unit: unit, materi: materi),
                UnitWidget(unit: unit, materi: materi),
                UnitBonusWidget(unitBonus: unitBonus, materi: materi),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
