// class list waktu sholat hari ini
import 'package:flutter/material.dart';

class WaktuSholatList {
  final List<WaktuSholat> waktuSholats;

  WaktuSholatList({required this.waktuSholats});

  factory WaktuSholatList.fromJson(List<dynamic> json) {
    return WaktuSholatList(
      waktuSholats: json.map((e) => WaktuSholat.fromJson(e)).toList(),
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

class _WidgetWaktuSholat extends StatelessWidget {
  final WaktuSholat waktuSholat;

  const _WidgetWaktuSholat({required this.waktuSholat});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: waktuSholat.color, // Use the color if provided
        margin: const EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0), // lancip
            topLeft: Radius.circular(16), // melengkung
            bottomRight: Radius.circular(16), // melengkung
            bottomLeft: Radius.circular(0), // lancip
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity, // Set width to fill the screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                waktuSholat.waktu,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Add space between texts
              Text(waktuSholat.waktuSholat, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayWaktuSholat extends StatelessWidget {
  DisplayWaktuSholat({super.key});
  // example data for WaktuSholatList
  final WaktuSholatList waktuSholatList = WaktuSholatList.fromJson([
    {'waktu': '05:00', 'waktu_sholat': 'Subuh', 'color': Colors.purple[100]},
    {'waktu': '06:30', 'waktu_sholat': 'Terbit', 'color': Colors.red[100]},
    {
      'waktu': '12:00',
      'waktu_sholat': 'Dhuhr',
      'color': const Color.fromRGBO(255, 224, 178, 1),
    },
    {'waktu': '15:00', 'waktu_sholat': 'Asar', 'color': Colors.green[100]},
    {'waktu': '18:00', 'waktu_sholat': 'Maghrib', 'color': Colors.pink[100]},
    {'waktu': '19:30', 'waktu_sholat': 'Isya', 'color': Colors.blue[100]},
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Add border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: waktuSholatList.waktuSholats.map((waktu) {
          return _WidgetWaktuSholat(waktuSholat: waktu);
        }).toList(),
      ),
    );
  }
}
