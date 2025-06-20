import 'dart:async';

import 'package:display_masjid/after_azan.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_bloc.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_state.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_bloc.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_state.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_bloc.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_state.dart';
import 'package:display_masjid/body/azan.dart';
import 'package:display_masjid/body/body.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_bloc.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_event.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_state.dart';
import 'package:display_masjid/waktusholat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late bool isAzan = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => WaktusholatBloc()),
          BlocProvider(create: (context) => AzanBloc()),
          BlocProvider(create: (context) => QuranBloc()),
          BlocProvider(create: (context) => AfterAzanBloc()),
        ],
        child: Scaffold(body: _DisplayWaktuSholat()),
      ),
    );
  }
}

class _DisplayWaktuSholat extends StatefulWidget {
  const _DisplayWaktuSholat();

  @override
  State<_DisplayWaktuSholat> createState() => _DisplayWaktuSholatState();
}

class _DisplayWaktuSholatState extends State<_DisplayWaktuSholat> {
  bool isAzan = false;

  @override
  Widget build(BuildContext context) {
    context.read<WaktusholatBloc>().add(LoadWaktuSholatFromApi());

    return MultiBlocListener(
      listeners: [
        BlocListener<WaktusholatBloc, WaktuSholatState>(
          listener: (context, state) {
            // Handle WaktusholatBloc state changes if needed
          },
        ),
        BlocListener<AzanBloc, AzanState>(
          listener: (context, state) {
            if (state.isAzanPlaying) {
              setState(() {
                isAzan = true; // Update the isAzan state
              });

              if (isAzan) {
                Timer? azanTimer;

                azanTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  debugPrint('Elapsed seconds: ${timer.tick}');

                  // If the timer has reached 60 seconds, cancel it
                  if (timer.tick >= 60) {
                    isAzan = false; // Reset the isAzan state
                    timer.cancel(); // Cancel the periodic timer
                    debugPrint('Azan has stopped after 60 seconds');

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AfterAzanPage()),
                    ); // Navigate to AfterAzanPage
                  }
                });

                // Stop the timer if another page is pushed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AzanPage(namaAzan: state.namaAzan),
                  ),
                ).then((_) {
                  azanTimer?.cancel();
                  debugPrint('Timer canceled due to navigation');
                });
              }
              // Print the elapsed seconds every second
            }
          },
        ),
        BlocListener<QuranBloc, QuranState>(
          listener: (context, state) {
            // Handle QuranBloc state changes if needed
          },
        ),
        BlocListener<AfterAzanBloc, AfterAzanState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<WaktusholatBloc, WaktuSholatState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/background/guillaume-galtier-3YrppYQPoCI-unsplash.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8, // 70% of the screen
                  child: DisplayBody(),
                ),
                Expanded(
                  flex: 2, // 30% of the screen
                  child: DisplayWaktuSholat(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
