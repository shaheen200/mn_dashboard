import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ChangeNotifier {
  int _seconds;
  final int _initialSeconds;
  final bool autoIncrease;
  Timer? _timer;
  bool _isRunning = false;

  TimerController({
    int initialSeconds = 0,
    this.autoIncrease = true,
  })  : _seconds = initialSeconds,
        _initialSeconds = initialSeconds;

  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  String get formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (autoIncrease) {
        _seconds++;
      } else {
        if (_seconds > 0) {
          _seconds--;
        } else {
          stop(); // stop if we reach zero in countdown mode
        }
      }
      notifyListeners();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset([int? newTime]) {
    stop();
    _seconds = newTime ?? 0;
    notifyListeners();
  }

  void setTime(int seconds) {
    _seconds = seconds;
    notifyListeners();
  }

  void increment(int by) {
    _seconds += by;
    notifyListeners();
  }

  void decrement(int by) {
    _seconds = (_seconds - by).clamp(0, double.infinity).toInt();
    notifyListeners();
  }

  void replay() {
    stop();
    _seconds = _initialSeconds;
    start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerWidget extends StatelessWidget {
  final TimerController controller;

  const TimerWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Text(
          controller.formattedTime,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
