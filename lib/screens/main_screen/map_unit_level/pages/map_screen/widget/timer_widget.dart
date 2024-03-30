import 'package:flutter/material.dart';
import 'package:mathgasing/models/timer/timer.dart';

class TimerWidget extends StatefulWidget {
  final TimerModel timerModel;

  const TimerWidget({Key? key, required this.timerModel}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late String timerLabelText;

  @override
  void initState() {
    super.initState();
    timerLabelText = _formatTime(widget.timerModel.remainingTime);
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    timerLabelText = _formatTime(widget.timerModel.remainingTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        timerLabelText,
        style: TextStyle(
          fontSize: 24.0,  // Ubah ukuran font sesuai kebutuhan
          color: Colors.black,
          // Atau tambahkan properti lain sesuai kebutuhan
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.timerModel.dispose();
    super.dispose();
  }

  void updateTimerUI(int remainingTime) {
    setState(() {
      timerLabelText = _formatTime(remainingTime);
    });
  }

  String _formatTime(int remainingTime) {
    int minutes = (remainingTime / 60).floor();
    int seconds = remainingTime % 60;

    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    return '$minutesStr:$secondsStr';
  }
}
