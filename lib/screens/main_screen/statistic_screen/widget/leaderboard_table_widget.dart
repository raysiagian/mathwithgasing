import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mathgasing/core/color/color.dart';
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
              // border: TableBorder.all(
              //   color: Colors.black,
              //   style: BorderStyle.solid,
              //   width: 2,
              // ),
              children: [
                TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              child: Text('Nama', style: TextStyle(color: AppColors.darkerColor, fontSize: 16.0, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
            ),
          ),  
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              child: Text('Poin Posttest', style: TextStyle(color: AppColors.darkerColor, fontSize: 16.0, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
            ),
          ),  
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              child: Text('Total Lencana', style: TextStyle(color: AppColors.darkerColor, fontSize: 16.0, fontWeight: FontWeight.w500), textAlign: TextAlign.left),
            ),
          ),  
        ],
      ),
                 ...leaderboardData.map((data) => TableRow(
        children: [
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(data['name'] ?? '', textAlign: TextAlign.left),
            ),
          ),  
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(data['total_score_posttest'].toString() ?? '', textAlign: TextAlign.left),
            ),
          ),  
          TableCell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
              ),
              alignment: Alignment.centerLeft,
              child: Text(data['total_badges'].toString() ?? '', textAlign: TextAlign.left),
            ),
          ),  
        ],
      )).toList(),
              ],
            ),
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
