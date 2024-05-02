import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/constants/constants.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/statistic_screen/widget/leaderboard_table_widget.dart';
import 'dart:convert';

import 'package:mathgasing/screens/main_screen/statistic_screen/widget/statistic_widget.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late Future<List<Materi>> futureMateri;

  @override
  void initState() {
    super.initState();
    futureMateri = fetchMateri();
  }

  Future<List<Materi>> fetchMateri() async {
    try {
      final response = await http.get(Uri.parse(baseurl +'api/getMateri'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List<dynamic>;
        return jsonData.map((e) => Materi.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load materi from API: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching materi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Statistik",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Leaderboard
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                                            padding: EdgeInsets.all(15),
                      color: Colors.white,
                    ),


                    Container(
                      padding: EdgeInsets.symmetric(horizontal:16),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Leaderboard",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          LeaderboardTableWidget(),
                        ],
                      )
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),

            ],
          )
        ],
      ),
    );
  }
}