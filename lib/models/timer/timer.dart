import 'dart:async';

class TimerModel {
  late int _durationInSeconds;
  late Timer _timer;
  late Function(int) _onTimerUpdate;
  late Function() _onTimerFinish;

  TimerModel({
    required int durationInSeconds,
    required Function(int) onTimerUpdate,
    required Function() onTimerFinish,
  }) {
    _durationInSeconds = durationInSeconds;
    _onTimerUpdate = onTimerUpdate;
    _onTimerFinish = onTimerFinish;
  }

  int get remainingTime => _durationInSeconds;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_durationInSeconds > 0) {
        _durationInSeconds--;
        _onTimerUpdate(_durationInSeconds);
      } else {
        _timer.cancel();
        _onTimerFinish();
      }
    });
  }

  void dispose() {
    _timer.cancel();
  }
}
