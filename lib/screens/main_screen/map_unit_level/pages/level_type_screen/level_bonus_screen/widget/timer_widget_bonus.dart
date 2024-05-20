import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidgetBonus extends StatefulWidget {
  final DateTime? lastLeftTime;

  const TimerWidgetBonus({
    Key? key,
    required this.lastLeftTime,
  }) : super(key: key);

  @override
  _TimerWidgetBonusState createState() => _TimerWidgetBonusState();
}

class _TimerWidgetBonusState extends State<TimerWidgetBonus> {
  late Timer _timer;
  Duration _remainingTime = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    if (widget.lastLeftTime != null) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer sebelum widget dihapus
    super.dispose();
  }

  void _startTimer() {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(widget.lastLeftTime!);
    final elapsedDuration = Duration(minutes: 1) - difference;
    if (elapsedDuration <= Duration.zero) {
      setState(() {
        _remainingTime = Duration.zero;
      });
    } else {
      setState(() {
        _remainingTime = elapsedDuration;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime -= const Duration(seconds: 1);
          } else {
            timer.cancel();
          }
        });
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Container(); // atau SizedBox.shrink();
}

}
