import 'package:display_masjid/waktusholat_bloc/waktusholat_bloc.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_state.dart';
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
    return MaterialApp(home: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WaktusholatBloc(),
        ),
      ],
      child: Scaffold(body: _DisplayWaktuSholat()),
    ));
  }
}

class _DisplayWaktuSholat extends StatelessWidget {
  const _DisplayWaktuSholat();

  @override
  Widget build(BuildContext context) {
    final waktuSholatList = context.read<WaktusholatBloc>();

    for (final waktu in waktuSholatList.state.waktuSholatList) {
      if (kDebugMode) {
        print(
          'Waktu sholat: ${waktu.waktuSholat} (${waktu.waktu})',
        );
      }
    }
    
    // Load WaktuSholat data from asset
    // final List<WaktuSholat> loadWaktuSholat = loadWaktuSholatFromAsset();
    // final WaktuSholat? terdekat = getWaktuSholatTerdekat(loadWaktuSholat);

    // print(
    //   'Waktu sholat terdekat: ${terdekat?.waktuSholat} (${terdekat?.waktu})',
    // );
    return BlocBuilder<WaktusholatBloc, WaktuSholatState>(
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
            child: Container(),
            // child: DisplayBody(
            //   waktuSholatList: loadWaktuSholat,
            //   waktuAzan: terdekat?.waktu,
            //   jamAzan: terdekat?.waktuSholat,
            // ),
          ),
          Expanded(
            flex: 2, // 30% of the screen
            // child: Container(),
            child: DisplayWaktuSholat(
              waktuSholatList: state.waktuSholatList, // Use the loaded data from the state
            ),
          ),
        ],
      ),
    );
      } 
      );
  }
}
