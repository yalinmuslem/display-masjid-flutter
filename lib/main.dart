import 'package:display_masjid/body/body.dart';
import 'package:display_masjid/waktusholat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _DisplayWaktuSholat()));
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
  const _DisplayWaktuSholat();

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
