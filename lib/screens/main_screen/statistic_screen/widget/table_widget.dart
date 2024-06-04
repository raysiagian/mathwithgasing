import 'package:flutter/material.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/score_type/score_pretest.dart';
import 'package:mathgasing/models/score_type/score_posttest.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/models/materi/materi.dart';

class TableWidget extends StatefulWidget {
  final Materi materi;

  TableWidget({required this.materi});

  @override
  _TableWidgetState createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  late Future<List<ScorePretest>> futurePretestScores;
  late Future<List<ScorePosttest>> futurePosttestScores;
  String? _token;
  User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
     futurePretestScores = Future.value([]);
  futurePosttestScores = Future.value([]);
  }

  _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _token = token;
      });

      // Load user using token
      final user = await fetchUser(token);
      setState(() {
        _loggedInUser = user;
      });

      // Fetch scores after user is loaded
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

      // Buat map untuk menyimpan skor pertama untuk setiap unit
      Map<int, ScorePretest> firstScoresMap = {};
      for (var item in jsonData) {
        ScorePretest score = ScorePretest.fromJson(item);
        int unitId = score.idUnit;
        if (!firstScoresMap.containsKey(unitId)) {
          firstScoresMap[unitId] = score;
        } else {
          if (score.idScorePretest < firstScoresMap[unitId]!.idScorePretest) {
            firstScoresMap[unitId] = score;
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
        int unitId = score.idUnit;
        if (!firstScoresMap.containsKey(unitId)) {
          firstScoresMap[unitId] = score;
        } else {
          if (score.idScorePosttest < firstScoresMap[unitId]!.idScorePosttest) {
            firstScoresMap[unitId] = score;
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
        } else if (snapshot.hasData) {
          List<ScorePretest> pretestScores = [];
          List<ScorePosttest> posttestScores = [];

          if (snapshot.data != null) {
            List<dynamic> data = snapshot.data as List<dynamic>;

            if (data.isNotEmpty && data.length == 2) {
              pretestScores = data[0] as List<ScorePretest>;
              posttestScores = data[1] as List<ScorePosttest>;
            }
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Unit ID')),
                DataColumn(label: Text('Pretest Score')),
                DataColumn(label: Text('Posttest Score')),
              ],
              rows: List<DataRow>.generate(
                pretestScores.length,
                (index) {
                  final pretest = pretestScores[index];
                  final posttest = posttestScores.firstWhere(
                    (posttest) => posttest.idUnit == pretest.idUnit,
                    orElse: () => ScorePosttest(
                      idScorePosttest: 0,
                      idPosttest: 0,
                      idUser: pretest.idUser,
                      idUnit: pretest.idUnit,
                      scorePosttest: 0,
                    ),
                  );

                  return DataRow(
                    cells: [
                      DataCell(Text(pretest.idUnit.toString())),
                      DataCell(Text(pretest.scorePretest.toString())),
                      DataCell(Text(posttest.scorePosttest.toString())),
                    ],
                  );
                },
              ),
            ),
          );
        } else {
          return Center(child: Text('No data found'));
        }
      },
    );
  }
}
