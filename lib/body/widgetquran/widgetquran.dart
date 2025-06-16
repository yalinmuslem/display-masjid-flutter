import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

class DisplayWidgetQuran extends StatefulWidget {
  const DisplayWidgetQuran({super.key});

  @override
  State<DisplayWidgetQuran> createState() => _DisplayWidgetQuranState();
}

class _DisplayWidgetQuranState extends State<DisplayWidgetQuran> {
  final AudioPlayer player = AudioPlayer();

  final int surahNumber = 1;
  int ayatNumber = 1;
  late int jumlahAyat;

  @override
  void initState() {
    super.initState();
    jumlahAyat = quran.getVerseCount(surahNumber);
    // _playAudio();

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Jika audio selesai diputar, lakukan sesuatu
        // Misalnya, kita bisa memutar audio ayat berikutnya
        if (ayatNumber < jumlahAyat) {
          setState(() {
            // Increment ayatNumber to play the next ayat
            ayatNumber++;
          });
          _playAudio();
        } else {
          // Jika sudah mencapai akhir surah, reset ke ayat pertama
          setState(() {
            ayatNumber = 1;
          });
          _playAudio();
        }
      }
    });
  }

  Future<void> _playAudio() async {
    final audioPath =
        'quran_audio/$surahNumber/${surahNumber.toString().padLeft(3, '0')}${ayatNumber.toString().padLeft(3, '0')}.mp3';
    try {
      // print('Memutar audio: $audioPath');
      await player.setAsset(audioPath);
      await player.play();
    } catch (e) {
      debugPrint('Gagal memutar audio: $e');
    }
  }

  // String _getImageAssetPath(int surah, int ayat) {
  //   print(
  //     'Memuat gambar untuk Surah $surah, Ayat $ayat: assets/quran_images/$surah/${surah}_$ayat.png',
  //   );
  //   final url = 'quran_images/$surah/${surah}_$ayat.png';
  //   return url;
  // }

  Future<String> _getTerjemahan(int surah, int ayat) async {
    final terjemahanFile = 'assets/surah/$surah.json';

    try {
      final data = await rootBundle.loadString(terjemahanFile);
      final Map<String, dynamic> terjemahanData = json.decode(data);

      final ayatText =
          terjemahanData['$surah']?['translations']?['id']?['text']?['$ayat'];

      if (ayatText != null) {
        return ayatText;
      } else {
        return 'Terjemahan tidak ditemukan';
      }
    } catch (e) {
      debugPrint('Gagal memuat file terjemahan: $e');
      return 'Terjemahan tidak tersedia';
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surah = quran.getSurahName(surahNumber);

    return Row(
      children: [
        Expanded(
          flex: 2, // 30% of the screen
          child: Container(),
        ), // Placeholder for the left side
        Expanded(
          flex: 8, // 70% of the screen
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'QS. $surah : $ayatNumber',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      quran.getVerse(surahNumber, ayatNumber),
                      style: GoogleFonts.getFont(
                        'Amiri Quran',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Image.asset(
                    //   _getImageAssetPath(surahNumber, ayatNumber),
                    //   fit: BoxFit.contain,
                    //   width: double.infinity,
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       const Text('Gambar tidak ditemukan!!'),
                    // ),
                    const SizedBox(height: 12),
                    FutureBuilder<String>(
                      future: _getTerjemahan(surahNumber, ayatNumber),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Terjemahan tidak tersedia');
                        } else {
                          return Text(
                            snapshot.data ?? 'Terjemahan tidak ditemukan',
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Reset ayatNumber to 1 to start from the beginning
                          ayatNumber = 1;
                          _playAudio();
                        });
                      },
                      child: const Text('Mulai dari Awal'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
