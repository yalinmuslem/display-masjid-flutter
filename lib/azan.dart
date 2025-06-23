import 'dart:async';

import 'package:display_masjid/bloc/after_azan_bloc/after_azan_bloc.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_event.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class AzanPage extends StatefulWidget {
  final String namaAzan;
  const AzanPage({super.key, required this.namaAzan});

  @override
  State<AzanPage> createState() => _AzanPageState();
}

class _AzanPageState extends State<AzanPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AfterAzanBloc>(create: (context) => AfterAzanBloc()),
        BlocProvider<AzanBloc>(create: (context) => AzanBloc()),
      ],
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _BuildAzanPage(namaAzan: widget.namaAzan),
      ),
    );
  }
}

class _BuildAzanPage extends StatefulWidget {
  final String namaAzan;
  const _BuildAzanPage({required this.namaAzan});

  @override
  State<_BuildAzanPage> createState() => _BuildAzanPageState();
}

class _BuildAzanPageState extends State<_BuildAzanPage> {
  int _remainingTime = 300;
  late Timer _timer;
  late String namaAzan;

  @override
  void initState() {
    super.initState();
    namaAzan = widget.namaAzan;
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
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    // Ensure the stream is properly disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // late final afterAzanBloc = context.read<AfterAzanBloc>();
    // Check if the azan has finished
    try {
      if (_remainingTime <= 0) {
        debugPrint('Azan has finished, triggering AfterAzanBloc event');
        context.read<AfterAzanBloc>().add(AfterAzanStarted());
      }
    } catch (e) {
      debugPrint('Error in AfterAzanBloc: $e');
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.volume_up, size: 100, color: Colors.white),
          const SizedBox(height: 20),
          Text(
            'Waktu Azan: $namaAzan',
            style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Mohon tenang, azan sedang dikumandangkan',
            textAlign: TextAlign.center,
            style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.grey[300]),
          ),
        ],
      ),
    );
  }
}
