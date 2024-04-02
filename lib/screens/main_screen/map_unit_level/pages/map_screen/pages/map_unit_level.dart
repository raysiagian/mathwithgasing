import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/screens/main_screen/home_wrapper/pages/home_wrapper.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/map_screen/widget/unit_widget.dart';

class MapUnitLevel extends StatelessWidget {
  const MapUnitLevel({Key? key, required this.materi}) : super(key: key);

  final Materi materi;

  Future<List<Unit>> fetchUnit2() async {
    try {
      var example = [
        {
          "id_unit": 1,
          "title": "Unit 1",
          "explanation": "Explanation for Unit 1",
          "levels": [
            {
              "id_level": 1,
              "title": "Level 1",
              "description": "Description for Level 1"
            },
            {
              "id_level": 2,
              "title": "Level 2",
              "description": "Description for Level 2"
            }
          ]
        },
        {
          "id_unit": 2,
          "title": "Unit 2",
          "explanation": "Explanation for Unit 2",
          "levels": [
            {
              "id_level": 3,
              "title": "Level 3",
              "description": "Description for Level 3"
            },
            {
              "id_level": 4,
              "title": "Level 4",
              "description": "Description for Level 4"
            }
          ]
        }
      ];

      List<Unit> data = example.map((e) => Unit.fromJson(e)).toList();
      return data;

    } catch (e) {
      throw Exception('Error fetching units: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materi.title),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<List<Unit>>(
            future: fetchUnit2(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(), // or any loading indicator
                );
              } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty){
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final unit = snapshot.data![index];
                      return UnitWidget(unit: unit, materi: materi);
                    },
                  );
                } else {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
              }
            },
          )
        ], 
      ),
    );
  }
}
