import 'package:display_masjid/bloc/after_azan_bloc/after_azan_bloc.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_event.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

class AfterAzanPage extends StatefulWidget {
  const AfterAzanPage({super.key});

  @override
  State createState() => _AfterAzanPageState();
}

class _AfterAzanPageState extends State<AfterAzanPage> {
  int _remainingTime = 300; // 5 minutes in seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_remainingTime <= 0) {
      context.read<AfterAzanBloc>().add(AfterAzanReset());
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Waktu menuju Iqamah:', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Text(
            _formatTime(_remainingTime),
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
