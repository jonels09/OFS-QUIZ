import 'dart:async';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  final VoidCallback onTimeUp;

  const QuizTimer({
    super.key,
    required this.onTimeUp,
  });

  @override
  State<QuizTimer> createState() => QuizTimerState();
}

class QuizTimerState extends State<QuizTimer> {
  static const int _maxSeconds = 30;
  Timer? _timer;
  int _seconds = _maxSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer?.cancel();
          widget.onTimeUp();
        }
      });
    });
  }

  void resetTimer() {
    setState(() {
      _seconds = _maxSeconds;
    });
    _startTimer();
  }

  void stopTimer() {
    _timer?.cancel(); // Arrête le timer
    setState(() {
      _seconds = _maxSeconds; // Réinitialise les secondes si nécessaire
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$_seconds',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
