import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mathgasing/core/color/color.dart';
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/level_bonus/level_bonus.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/models/unit_bonus/unit_bonus.dart';
import 'package:mathgasing/models/user/user.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/level_type_screen/level_bonus_screen/pages/level_bonus_page.dart';

class LevelBonusButtonWidget extends StatefulWidget {
  const LevelBonusButtonWidget({
    Key? key,
    required this.levelBonus,
    required this.materi,
    required this.unit_bonus,
  }) : super(key: key);

  final LevelBonus levelBonus;
  final Materi materi;
  final UnitBonus unit_bonus;

  @override
  State<LevelBonusButtonWidget> createState() => _LevelBonusButtonWidgetState();
}

class _LevelBonusButtonWidgetState extends State<LevelBonusButtonWidget> {
  late String _token;
  late User? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUser();
  }

  Future<void> _loadTokenAndFetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        _token = token;
      });

      try {
        // Load user using token
        final user = await fetchUser(token);
        setState(() {
          _loggedInUser = user;
        });
      } catch (e) {
        print('Error fetching user: $e');
        // Handle error fetching user
      }
    } else {
      // Handle case where token is null
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

  Future<List<LevelBonus>> fetchLevelsBonus() async {
    try {
      final response = await http.get(Uri.parse(baseurl + 'api/levelbonus'));

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

  Future<int> fetchUserLives() async {
    try {
      final userId = _loggedInUser?.id_user ?? '';
      final response = await http.get(Uri.parse(baseurl + 'api/user/$userId/lives'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['lives'];
      } else {
        throw Exception('Failed to fetch user lives data');
      }
    } catch (e) {
      throw Exception('Error fetching user lives data: $e');
    }
  }

  Future<void> updateLivesOnServer(int lives) async {
    try {
      final userId = _loggedInUser?.id_user ?? '';
      final response = await http.put(
        Uri.parse(baseurl + 'api/users/$userId/update-lives'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'lives': lives}),
      );

      if (response.statusCode != 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to update user lives on server: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error updating user lives on server: $e');
    }
  }

  Future<Map<String, dynamic>> checkLivesAndTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int userLives = await fetchUserLives();

    if (userLives == 0) {
      final String? lastZeroLivesTimeString = prefs.getString('lastZeroLivesTime');
      final DateTime currentTime = DateTime.now();

      if (lastZeroLivesTimeString != null) {
        final DateTime lastZeroLivesTime = DateTime.parse(lastZeroLivesTimeString);
        final int elapsedMinutes = currentTime.difference(lastZeroLivesTime).inMinutes;
        final int remainingMinutes = 5 - elapsedMinutes;

        if (elapsedMinutes >= 5) {
          // Timer has completed, reset lives
          await prefs.remove('lastZeroLivesTime');
          await updateLivesOnServer(1);
          return {'lives': 1, 'remainingMinutes': 0};
        } else {
          // Timer still running
          return {'lives': 0, 'remainingMinutes': remainingMinutes};
        }
      } else {
        await prefs.setString('lastZeroLivesTime', currentTime.toIso8601String());
        return {'lives': 0, 'remainingMinutes': 5};
      }
    } else {
      return {'lives': userLives, 'remainingMinutes': 0};
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LevelBonusButtonWidget - levelBonus: ${widget.levelBonus}');
    return InkWell(
      onTap: () async {
        try {
          final result = await checkLivesAndTimer();
          final userLives = result['lives'];
          final remainingMinutes = result['remainingMinutes'];

          if (userLives == 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('No Lives'),
                  content: Text('You cannot access LevelBonusPage because your lives are depleted. Please wait $remainingMinutes minutes.'),
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
            return;
          }

          if (widget.levelBonus.level_number == 1) {
            print('Fetching level bonus data...');
            List<LevelBonus> bonuses = await fetchLevelsBonus();
            print('Level Bonus data fetched successfully: $bonuses');

            LevelBonus bonus = bonuses.firstWhere((bonus) => bonus.id_level_bonus == widget.levelBonus.id_level_bonus);
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
                  levelBonus: widget.levelBonus,
                  materi: widget.materi,
                  unit_bonus: widget.unit_bonus,
                ),
              ),
            );
          }
        } catch (e) {
          // Handle error
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
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
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.levelBonus.level_number.toString(),
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