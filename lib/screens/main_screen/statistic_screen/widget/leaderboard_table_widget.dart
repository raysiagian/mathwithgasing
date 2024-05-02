import 'package:flutter/material.dart';

class LeaderboardTableWidget extends StatefulWidget {
  const LeaderboardTableWidget({super.key});

  @override
  State<LeaderboardTableWidget> createState() => _LeaderboardTableWidgetState();
}

class _LeaderboardTableWidgetState extends State<LeaderboardTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Table(
            border: TableBorder.all(
              color: Colors.black,
              style: BorderStyle.solid,
              width: 2
            ),
            children: [
              TableRow(
                children: [
                  Column(children:[Text('Nama', style: TextStyle(fontSize: 16.0))]),  
                  Column(children:[Text('Poin Pretest', style: TextStyle(fontSize: 16.0))]),  
                  Column(children:[Text('Poin Posttest', style: TextStyle(fontSize: 16.0))]),  
                ]),
              TableRow(
                children: [
                  Column(children:[Text('User 1')]),  
                  Column(children:[Text('100')]),  
                  Column(children:[Text('100')]),  
              ]),
              TableRow(
                children: [
                  Column(children:[Text('User 2')]),  
                  Column(children:[Text('100')]),  
                  Column(children:[Text('100')]),  
              ]),
              TableRow(
                children: [
                  Column(children:[Text('User 3')]),  
                  Column(children:[Text('100')]),  
                  Column(children:[Text('100')]),  
              ]),
            ],
          ),
        )
      ]),
    );
  }
}