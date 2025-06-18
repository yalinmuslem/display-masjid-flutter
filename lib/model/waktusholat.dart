import 'dart:ui';

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