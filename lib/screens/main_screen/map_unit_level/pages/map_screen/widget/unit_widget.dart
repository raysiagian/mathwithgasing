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
      var example = [
        {"id_level": 1, "level_number": 1},
        {"id_level": 2, "level_number": 2},
        {"id_level": 4, "level_number": 3},
      ];

      List<Level> data = example.map((e) => Level.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw Exception('Error fetching levels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, top: 30),
              height: 170,
              width: double.infinity,
              color: Colors.red,
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
                  Text(unit.explanation,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Level>>(
            future: fetchLevel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('lodinggggg.....'));
              } else {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return LevelButtonWidget(
                        level: snapshot.data![index],
                        materi: materi,
                      );
                      //return const Text('FuckYouuu',style: TextStyle(color: Colors.black),);
                    },
                  );
                } else {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
