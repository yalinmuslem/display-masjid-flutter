import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

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

class HijriahDate {
  late final int day;
  late final String monthName;
  late final int year;

  HijriahDate() {
    final hijriDate = HijriCalendar.now();
    day = hijriDate.hDay;
    monthName = hijriDate.longMonthName; // Replace with actual month name logic
    year = hijriDate.hYear;
  }
}

class DisplayWaktuSaatini extends StatelessWidget {
  DisplayWaktuSaatini({super.key});

  final WaktuSaatIni waktuSaatIni = WaktuSaatIni();
  final HijriahDate hijriahDate = HijriahDate();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Add border
      ),
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ), // Add padding left and right
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: double.infinity, // Set width to match the screen width
                  child: Text(
                    waktuSaatIni.hariIni,
                    textAlign: TextAlign.center, // Center the text
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    '${waktuSaatIni.tanggalHariIni.day} ${waktuSaatIni.bulanIni}\n${waktuSaatIni.tanggalHariIni.year}',
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    '${hijriahDate.day} ${hijriahDate.monthName} ${hijriahDate.year} H',
                    textAlign: TextAlign.right, // Align text to the right
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Add space between texts
            Text(
              '${waktuSaatIni.jamHariIni.hour}:${waktuSaatIni.jamHariIni.minute}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
