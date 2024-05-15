import 'package:flutter/material.dart';

class TimerWidgetBonus extends StatelessWidget {
  final DateTime? lastLeftTime; // Ubah tipe data menjadi DateTime?

  const TimerWidgetBonus({
    Key? key,
    required this.lastLeftTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastLeftTime == null) {
      // Jika lastLeftTime belum diinisialisasi, tampilkan teks kosong atau indikator lainnya
      return Text(
        'Timer: -', // Atau tampilkan indikator lainnya sesuai kebutuhan
        style: TextStyle(
          color: Colors.blue,
        ),
      );
    } else {
      final currentTime = DateTime.now();
      final difference = lastLeftTime!.difference(currentTime); // Ubah lastLeftTime menjadi lastLeftTime!
      final remainingTime = Duration(minutes: 5) + difference;
      final formattedMinutes = remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      final formattedSeconds = remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
      final formattedTime = '$formattedMinutes:$formattedSeconds';
      return Text(
        'Timer: $formattedTime',
        style: TextStyle(
          color: Colors.blue,
        ),
      );
    }
  }
}