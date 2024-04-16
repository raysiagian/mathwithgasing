import 'package:flutter/material.dart';
import 'package:mathgasing/models/materi/materi.dart';
import 'package:mathgasing/screens/main_screen/map_unit_level/pages/after_level_screen/widget/button_to_map_widget.dart';

class FinalScore extends StatelessWidget {
  const FinalScore({Key? key, required this.materi, required this.score_pretest}) : super(key: key);

  final Materi materi;
  final int score_pretest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calon Juara!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Kamu baru saja menyelesaikan levelmu',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nilai Kamu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    // Nilai
                    score_pretest.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            BackToMap(materi: materi),
          ],
        ),
      ),
    );
  }
}