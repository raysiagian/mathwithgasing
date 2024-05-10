import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_type/material_video.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/models/unit/unit.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/pages/material_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/pages/posttest_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/pages/pretest_level_page.dart';

class LevelButtonWidget extends StatelessWidget {
  const LevelButtonWidget({
    Key? key,
    required this.unit,
    required this.materi,
  }) : super(key: key);

  final Unit unit;
  final Materi materi;

  Future<List<PreTest>> fetchPretest() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getPretest?id_unit=${unit.id_unit}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => PreTest.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load pretests');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<MaterialVideo>> fetchMaterialVideo() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getMaterialVideo?id_unit=${unit.id_unit}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => MaterialVideo.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load material videos');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<PostTest>> fetchPosttest() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getPosttest?id_unit=${unit.id_unit}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => PostTest.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load posttests');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            List<PreTest> pretests = await fetchPretest();

            if (pretests.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreTestLevel(
                    unit: unit,
                    materi: materi,
                    pretest: pretests.first,
                  ),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('No Pretest Available'),
                    content: Text('There is no pretest available for this unit.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MaterialLevel(
                  unit: unit,
                  materi: materi, 
                ),
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                '2',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () async {
            List<PostTest> posttests = await fetchPosttest();

            if (posttests.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostTestLevel(
                    unit: unit,
                    materi: materi, 
                    posttest: posttests.first,
                  ),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('No Posttest Available'),
                    content: Text('There is no posttest available for this unit.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                '3',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
