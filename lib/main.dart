import 'package:display_masjid/masjidinfo.dart';
import 'package:display_masjid/waktusaatini.dart';
import 'package:display_masjid/waktusholat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  // generate waktu sholat example data
  final WaktuSholat waktuSholatExample = WaktuSholat.fromJson({
    'waktu': '12:00',
    'waktu_sholat': 'Dhuhr',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _DisplayWaktuSholat(waktuSholat: waktuSholatExample),
      ),
    );
  }
}

class WaktuSholat {
  final String waktu;
  final String waktuSholat;
  final Color? color; // Add the color property

  WaktuSholat({required this.waktu, required this.waktuSholat, this.color});

  factory WaktuSholat.fromJson(Map<String, dynamic> json) {
    return WaktuSholat(
      waktu: json['waktu'] as String,
      waktuSholat: json['waktu_sholat'] as String,
      color: json['color'], // Parse color if provided
    );
  }
}

class _DisplayWaktuSholat extends StatelessWidget {
  final WaktuSholat waktuSholat;

  const _DisplayWaktuSholat({required this.waktuSholat});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 8, // 70% of the screen
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Add border
                  ),
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        waktuSholat.waktu,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Add space between texts
                      Text(
                        waktuSholat.waktuSholat,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 7, child: DisplayInfoMasjid()),
              Expanded(flex: 2, child: DisplayWaktuSaatini()),
            ],
          ),
        ),
        Expanded(
          flex: 2, // 30% of the screen
          child: DisplayWaktuSholat(),
        ),
      ],
    );
  }
}
