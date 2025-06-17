import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    monthName = _getNamaBulan(
      hijriDate.hMonth,
    ); // Replace with actual month name logic
    year = hijriDate.hYear;
  }

  static String _getNamaBulan(int month) {
    switch (month) {
      case 1:
        return 'Muharram';
      case 2:
        return 'Safar';
      case 3:
        return 'Rabiul Awal';
      case 4:
        return 'Rabiul Akhir';
      case 5:
        return 'Jumada Awal';
      case 6:
        return 'Jumada Akhir';
      case 7:
        return 'Rajab';
      case 8:
        return 'Sya\'ban';
      case 9:
        return 'Ramadhan';
      case 10:
        return 'Syawal';
      case 11:
        return 'Dzulqa\'idah';
      case 12:
        return 'Dzulhijjah';
      default:
        return '';
    }
  }
}

class DisplayWaktuSaatini extends StatelessWidget {
  DisplayWaktuSaatini({super.key});

  final WaktuSaatIni waktuSaatIni = WaktuSaatIni();
  final HijriahDate hijriahDate = HijriahDate();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ), // Add padding left and right
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  '${waktuSaatIni.tanggalHariIni.day}',
                  textAlign: TextAlign.left, // Align text to the left
                  style: GoogleFonts.bebasNeue(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Card(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: double
                          .infinity, // Set width to match the screen width
                      child: Text(
                        waktuSaatIni.hariIni,
                        textAlign: TextAlign.center, // Center the text
                        style: GoogleFonts.bebasNeue(
                          fontSize: 17,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${hijriahDate.day}',
                  textAlign: TextAlign.right, // Align text to the right
                  style: GoogleFonts.bebasNeue(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  '${waktuSaatIni.bulanIni}\n${waktuSaatIni.tanggalHariIni.year} M',
                  textAlign: TextAlign.left, // Align text to the left
                  style: GoogleFonts.bebasNeue(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  '${hijriahDate.monthName}\n${hijriahDate.year} H',
                  textAlign: TextAlign.right, // Align text to the right
                  style: GoogleFonts.bebasNeue(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Add space between texts
          StreamBuilder<DateTime>(
            stream: Stream.periodic(
              const Duration(seconds: 1),
              (_) => DateTime.now(),
            ),
            builder: (context, snapshot) {
              final currentTime = snapshot.data ?? DateTime.now();
              final formattedTime =
                  '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}';
              return Text(formattedTime, style: TextStyle(fontSize: 18));
            },
          ),
        ],
      ),
    );
  }
}
