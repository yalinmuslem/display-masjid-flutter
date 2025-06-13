import 'package:flutter/material.dart';

class WaktuSaatIni {
  // tanggal hari ini
  final DateTime tanggalHariIni;
  // jam hari ini berikut detiknya
  final TimeOfDay jamHariIni;
  // hari ini
  final String hariIni;
  // bulan ini
  final String bulanIni;

  WaktuSaatIni()
    : tanggalHariIni = DateTime.now(),
      jamHariIni = TimeOfDay.fromDateTime(DateTime.now()),
      hariIni = _getNamaHari(DateTime.now().weekday),
      bulanIni = _getNamaBulan(DateTime.now().month);
  // bulan ini
  static String _getNamaBulan(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  static String _getNamaHari(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
        return 'Minggu';
      default:
        return '';
    }
  }
}

class DisplayWaktuSaatini extends StatelessWidget {
  DisplayWaktuSaatini({super.key});

  final WaktuSaatIni waktuSaatIni = WaktuSaatIni();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Add border
      ),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            waktuSaatIni.hariIni,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10), // Add space between texts
          Text(
            '${waktuSaatIni.tanggalHariIni.day} ${waktuSaatIni.bulanIni} ${waktuSaatIni.tanggalHariIni.year}',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10), // Add space between texts
          Text(
            '${waktuSaatIni.jamHariIni.hour}:${waktuSaatIni.jamHariIni.minute}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
