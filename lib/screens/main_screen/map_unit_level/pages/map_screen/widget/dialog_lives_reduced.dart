import 'package:flutter/material.dart';
import 'package:mathgasing/models/materi/materi.dart';

class DialogLivesReduced extends StatelessWidget {
  const DialogLivesReduced({
     Key? key,
    required this.materi,
    required this.lives,
  }) : super(key: key);

  final Materi materi;
  final int lives;

 @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/custom_dialog_image_for_close_question.png',
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 20),
          Text(
            'Jawaban Kamu\nSalah',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sisa Nyawa: $lives',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}