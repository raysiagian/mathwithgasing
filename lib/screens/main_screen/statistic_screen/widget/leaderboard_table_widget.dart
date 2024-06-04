import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mathgasing/core/constants/constants.dart';

class LeaderboardTableWidget extends StatefulWidget {
  const LeaderboardTableWidget({Key? key});

  @override
  State<LeaderboardTableWidget> createState() => _LeaderboardTableWidgetState();
}

class _LeaderboardTableWidgetState extends State<LeaderboardTableWidget> {
  List<Map<String, dynamic>> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(baseurl + 'api/dataLeaderboard'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (mounted) {
        setState(() {
          leaderboardData = List<Map<String, dynamic>>.from(data);
        });
      }
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Table(
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 2,
              ),
              children: [
                TableRow(
                  children: [
                    Column(children:[Text('Nama', style: TextStyle(fontSize: 16.0))]),  
                    Column(children:[Text('Poin Posttest', style: TextStyle(fontSize: 16.0))]),  
                    Column(children:[Text('Total Lencana', style: TextStyle(fontSize: 16.0))]),  
                  ],
                ),
                ...leaderboardData.map((data) => TableRow(
                  children: [
                    Column(children:[Text(data['name'] ?? '')]),  
                    Column(children:[Text(data['total_score_posttest'].toString() ?? '')]),  
                    Column(children:[Text(data['total_badges'].toString() ?? '')]),  
                  ],
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
