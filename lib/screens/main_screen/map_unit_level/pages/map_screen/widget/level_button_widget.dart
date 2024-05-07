import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'dart:convert';
import 'package:mathgasing/models/level/level.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/level_type/posttest.dart';
import 'package:mathgasing/models/level_type/pretest.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/material_level_screen/pages/material_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/posttest_level_screen/pages/posttest_level_page.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/pretest_level_screen/pages/pretest_level_page.dart';

class LevelButtonWidget extends StatelessWidget {
  const LevelButtonWidget({
    Key? key,
    required this.level,
    required this.materi,
  }) : super(key: key);

  final Level level;
  final Materi materi;

  Future<List<PreTest>> fetchPretest() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getPretest?id_level=${level.id_level}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        print(jsonData);
        return jsonData.map((e) => PreTest.fromJson(e)).toList();
      } else {
        throw Exception('${response.headers}');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<PostTest>> fetchPosttest() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/getPosttest?id_level=${level.id_level}'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        print(jsonData);
        return jsonData.map((e) => PostTest.fromJson(e)).toList();
      } else {
        throw Exception('${response.headers}');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (level.level_number == 1) {
          try {
            print('Fetching pretest data...');
            List<PreTest> preTests = await fetchPretest();
            print('Pretest data fetched successfully: $preTests');

            PreTest preTest =
                preTests.firstWhere((preTest) => preTest.id_level == level.id_level);
            print('Pretest for current level found: $preTest');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Pretest ID: ${preTest.id_pretest}'),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreTestLevel(
                  level: level,
                  materi: materi,
                  pretest: preTest,
                ),
              ),
            );
          } catch (e) {
            // Handle error
            print('$e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$e'),
              ),
            );
          }
        } else if (level.level_number == 3) {
          try {
            print('Fetching posttest data...');
            List<PostTest> postTests = await fetchPosttest();
            print('Posttest data fetched successfully: $postTests');

            PostTest postTest = postTests
                .firstWhere((postTest) => postTest.id_level == level.id_level);
            print('Posttest for current level found: $postTest');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Posttest ID: ${postTest.id_posttest}'),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostTestLevel(
                  level: level,
                  materi: materi,
                  posttest: postTest,
                ),
              ),
            );
          } catch (e) {
            // Handle error
            print('$e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$e'),
              ),
            );
          }
        } else if (level.level_number == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaterialLevel(
                level: level,
                materi: materi,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              level.level_number.toString(),
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
