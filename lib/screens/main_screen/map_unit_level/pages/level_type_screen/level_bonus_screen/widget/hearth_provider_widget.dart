import 'dart:async';
import 'package:flutter/material.dart';

class HeartProvider with ChangeNotifier {
  late int _hearts = 3;
  int get hearts => _hearts;

  late Timer _timer;

  HeartProvider() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 5), (timer) { // Ubah durasi menjadi 5 menit
      if (_hearts < 3) { // Pastikan hati tidak melebihi jumlah maksimal
        _hearts++; // Tambah satu hati setiap 5 menit
        notifyListeners();
      }
    });
  }

  void deductHeart() {
    if (_hearts > 0) {
      _hearts--;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
