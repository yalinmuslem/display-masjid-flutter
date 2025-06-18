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

WaktuSholat getWaktuSholatTerdekat(List<WaktuSholat> waktuList) {
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