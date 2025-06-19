import 'dart:async';

import 'package:display_masjid/bloc/azan_bloc/azan_bloc.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_event.dart';
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => WaktusholatBloc()),
          BlocProvider(create: (context) => AzanBloc()),
          BlocProvider(create: (context) => QuranBloc()),
        ],
        child: Scaffold(body: _DisplayWaktuSholat()),
      ),
    );
  }
}

class _DisplayWaktuSholat extends StatelessWidget {
  const _DisplayWaktuSholat();

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzanPage(namaAzan: state.namaAzan),
                ),
              );

              // Print the elapsed seconds every second
              Timer? periodicTimer;

              periodicTimer = Timer.periodic(const Duration(seconds: 1), (
                timer,
              ) {
                debugPrint('Elapsed seconds: ${timer.tick}');

                // If the timer has reached 60 seconds, cancel it
                if (timer.tick >= 60) {
                  periodicTimer?.cancel(); // Cancel the periodic timer
                  Navigator.pop(context); // Close AzanPage after 60 seconds

                  context.read<AzanBloc>().add(AzanReset()); // Reset Azan state
                  debugPrint('Azan has stopped after 60 seconds');
                }
              });
            }
          },
        ),
        BlocListener<QuranBloc, QuranState>(
          listener: (context, state) {
            // Handle QuranBloc state changes if needed
          },
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
