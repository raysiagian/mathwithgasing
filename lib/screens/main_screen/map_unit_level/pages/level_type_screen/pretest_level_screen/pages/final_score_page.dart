import 'package:flutter/material.dart';
import 'package:mathgasing/screens/main_screen/home_screen/pages/home_page.dart';


class FinalScorePage extends StatelessWidget {
  final int score_pretest;

  const FinalScorePage({Key? key, required this.score_pretest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Score'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            ); // Navigate back to the previous page
          },
        ),
      ),
      body: Center(
        child: Text(
          'Your final score: $score_pretest',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

