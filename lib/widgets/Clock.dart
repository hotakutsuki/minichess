import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minichess/utils/Enums.dart';

class Clock extends StatefulWidget {
  Clock({Key? key, required this.player, required this.gameOver}) : super(key: key);
  final GlobalKey<ClockState> _myClockState = GlobalKey<ClockState>();
  final player;
  final gameOver;
  @override
  Widget build(BuildContext context) {
    return Clock(key: _myClockState, player: player, gameOver: gameOver,);
  }

  @override
  State<Clock> createState() => ClockState();
}

class ClockState extends State<Clock> {
  static const gameMinutes = 2;
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: gameMinutes);

  void initState() {
    super.initState();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) => setCountDown());
  }

  stopTimer() {
    if (countdownTimer != null){
      setState(() => countdownTimer!.cancel());
    }
  }

  resetTimer() {
    if (countdownTimer != null){
      stopTimer();
      setState(() => myDuration = const Duration(minutes: gameMinutes));
    }
  }

  setCountDown() {
    const reduceMillisecondsBy = 100;
    setState(() {
      final mSeconds = myDuration.inMilliseconds - reduceMillisecondsBy;
      if (mSeconds < 0) {
        widget.gameOver(widget.player == player.white ? player.black : player.white);
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(milliseconds: mSeconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    final milliseconds = strDigits((myDuration.inMilliseconds.remainder(1000)/100).floor());
    return Text(
      '$minutes:$seconds:$milliseconds',
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 32),
    );
  }
}
