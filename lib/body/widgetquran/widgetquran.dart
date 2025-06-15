import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

class DisplayWidgetQuran extends StatefulWidget {
  const DisplayWidgetQuran({super.key});

  @override
  State<DisplayWidgetQuran> createState() => _DisplayWidgetQuranState();
}

class _DisplayWidgetQuranState extends State<DisplayWidgetQuran> {
  final AudioPlayer player = AudioPlayer();

  final int surahNumber = 2;
  final int ayatNumber = 2;

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  Future<void> _playAudio() async {
    final audioPath =
        'assets/quran_audio/${surahNumber.toString().padLeft(3, '0')}${ayatNumber.toString().padLeft(3, '0')}.mp3';
    try {
      // print('Memutar audio: $audioPath');
      await player.setAsset(audioPath);
      await player.play();
    } catch (e) {
      debugPrint('Gagal memutar audio: $e');
    }
  }

  String _getImageAssetPath(int surah, int ayat) {
    print('Memuat gambar untuk Surah $surah, Ayat $ayat: assets/quran_images/$surah/${surah}_$ayat.png');
    final url = 'assets/quran_images/$surah/${surah}_$ayat.png';
    return url;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surah = quran.getSurahName(surahNumber);
    final terjemahan = _getTerjemahan(surahNumber, ayatNumber);
    print('Memuat widget Quran untuk Surah $surahNumber, Ayat $ayatNumber, $surah');

    return Padding(
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
              Image.asset(
                _getImageAssetPath(surahNumber, ayatNumber),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Gambar tidak ditemukan!!'),
              ),
              const SizedBox(height: 12),
              Text(terjemahan, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  String _getTerjemahan(int surah, int ayat) {
    if (surah == 1 && ayat == 1) {
      return "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.";
    } else if (surah == 1 && ayat == 2) {
      return "Segala puji bagi Allah, Tuhan semesta alam.";
    }
    return "(Terjemahan belum tersedia)";
  }
}
