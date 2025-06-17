import 'package:display_masjid/body/body.dart';
import 'package:display_masjid/waktusholat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return MaterialApp(home: Scaffold(body: _DisplayWaktuSholat()));
  }
}

List<WaktuSholat> loadWaktuSholatFromAsset() {
  return [
    WaktuSholat(
      waktu: "Subuh",
      waktuSholat: "04:30",
      color: Color(0xFFFFD1DC), // Pastel pink
    ),
    WaktuSholat(
      waktu: "Fajar",
      waktuSholat: "10:00",
      color: Color(0xFFFFE0B2),
    ), // Pastel orange
    WaktuSholat(
      waktu: "Dzuhur",
      waktuSholat: "12:00",
      color: Color(0xFFB2F7EF), // Pastel teal
    ),
    WaktuSholat(
      waktu: "Ashar",
      waktuSholat: "15:30",
      color: Color(0xFFFFF5BA), // Pastel yellow
    ),
    WaktuSholat(
      waktu: "Maghrib",
      waktuSholat: "18:00",
      color: Color(0xFFB9FBC0), // Pastel green
    ),
    WaktuSholat(
      waktu: "Isya",
      waktuSholat: "18:47",
      color: Color(0xFFB5B9FC), // Pastel blue
    ),
  ];
}

WaktuSholat? getWaktuSholatTerdekat(List<WaktuSholat> waktuList) {
  final now = DateTime.now();
  final nowMinutes = now.hour * 60 + now.minute;

  for (final waktu in waktuList) {
    final parts = waktu.waktuSholat.split(':');
    final jam = int.parse(parts[0]);
    final menit = int.parse(parts[1]);
    final waktuMinutes = jam * 60 + menit;

    if (waktuMinutes >= nowMinutes) {
      return waktu;
    }
  }

  // Jika sudah lewat semua, bisa kembali ke yang pertama
  return waktuList.first;
}

class _DisplayWaktuSholat extends StatelessWidget {
  const _DisplayWaktuSholat();

  @override
  Widget build(BuildContext context) {
    // Load WaktuSholat data from asset
    final List<WaktuSholat> loadWaktuSholat = loadWaktuSholatFromAsset();
    final WaktuSholat? terdekat = getWaktuSholatTerdekat(loadWaktuSholat);

    print(
      'Waktu sholat terdekat: ${terdekat?.waktuSholat} (${terdekat?.waktu})',
    );
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
            child: DisplayBody(
              waktuSholatList: loadWaktuSholat,
              waktuAzan: terdekat?.waktu,
              jamAzan: terdekat?.waktuSholat,
            ),
          ),
          Expanded(
            flex: 2, // 30% of the screen
            child: DisplayWaktuSholat(
              waktuSholatList: loadWaktuSholat.toList(),
            ),
          ),
        ],
      ),
    );
  }
}
