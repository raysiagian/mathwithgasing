// chart_widget.dart
import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/score_type/score_posttest.dart';
import 'package:mathgasing/models/score_type/score_pretest.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/models/materi/materi.dart';

class ChartWidget extends StatefulWidget {
  final Materi materi;

  ChartWidget({required this.materi});

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  late Future<List<ScorePretest>> futurePretestScores = Future.value([]);
  late Future<List<ScorePosttest>> futurePosttestScores = Future.value([]);
  String? _token;
  User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
  }

  _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _token = token;
      });

      final user = await fetchUser(token);
      setState(() {
        _loggedInUser = user;
      });

      if (_loggedInUser != null) {
        setState(() {
          futurePretestScores = fetchPretestScores(_loggedInUser!.id_user, widget.materi.id_materi);
          futurePosttestScores = fetchPosttestScores(_loggedInUser!.id_user, widget.materi.id_materi);
        });
      }
    }
  }

  Future<User> fetchUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseurl + 'api/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to load user from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<List<ScorePretest>> fetchPretestScores(int userId, int materiId) async {
    final response = await http.get(
      Uri.parse(baseurl + 'api/user/get-scores-pretest-idmateri/$materiId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['data'];

      Map<int, ScorePretest> firstScoresMap = {};
      for (var item in jsonData) {
        ScorePretest score = ScorePretest.fromJson(item);
        if (score.idUser == userId) {
          int unitId = score.idUnit;
          if (!firstScoresMap.containsKey(unitId)) {
            firstScoresMap[unitId] = score;
          } else {
            if (score.idScorePretest < firstScoresMap[unitId]!.idScorePretest) {
              firstScoresMap[unitId] = score;
            }
          }
        }
      }
      return firstScoresMap.values.toList();
    } else {
      throw Exception('Failed to load pretest scores');
    }
  }

  Future<List<ScorePosttest>> fetchPosttestScores(int userId, int materiId) async {
    final response = await http.get(
      Uri.parse(baseurl + 'api/user/get-scores-posttest-idmateri/$materiId'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['data'];

      Map<int, ScorePosttest> firstScoresMap = {};
      for (var item in jsonData) {
        ScorePosttest score = ScorePosttest.fromJson(item);
        if (score.idUser == userId) {
          int unitId = score.idUnit;
          if (!firstScoresMap.containsKey(unitId)) {
            firstScoresMap[unitId] = score;
          } else {
            if (score.idScorePosttest < firstScoresMap[unitId]!.idScorePosttest) {
              firstScoresMap[unitId] = score;
            }
          }
        }
      }
      return firstScoresMap.values.toList();
    } else {
      throw Exception('Failed to load posttest scores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futurePretestScores, futurePosttestScores]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<ScorePretest> pretestScores = [];
          List<ScorePosttest> posttestScores = [];

          if (snapshot.data != null) {
            List<dynamic>? data = snapshot.data as List<dynamic>?;

            if (data != null && data.length == 2) {
              pretestScores = data[0] as List<ScorePretest>;
              posttestScores = data[1] as List<ScorePosttest>;
            }
          }

          return SingleChildScrollView(
            child: Container(
              height: 400,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Skor Pretest dan Posttest'),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<dynamic, String>>[
                  LineSeries<ScorePretest, String>(
                    dataSource: pretestScores,
                    xValueMapper: (ScorePretest score, _) => score.idUnit.toString(),
                    yValueMapper: (ScorePretest score, _) => score.scorePretest.toDouble(),
                    name: 'Skor Pretest',
                    color: Colors.blue,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                  LineSeries<ScorePosttest, String>(
                    dataSource: posttestScores,
                    xValueMapper: (ScorePosttest score, _) => score.idUnit.toString(),
                    yValueMapper: (ScorePosttest score, _) => score.scorePosttest.toDouble(),
                    name: 'Skor Posttest',
                    color: Colors.red,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
