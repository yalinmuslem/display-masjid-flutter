import 'dart:convert';

import 'package:flutter/services.dart';

Future<List> getQuranPlaylist() async {
  try {
    final jsonString = await rootBundle.loadString(
      'assets/playlist_quran.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    // Ambil hari ini (misal Senin)
    final now = DateTime.now();
    final namaHari = _namaHari(now.weekday); // "Senin", "Selasa", dst

    if (data.containsKey(namaHari)) {
      final List<dynamic> daftarSurah = data[namaHari];

      print(daftarSurah);

      return daftarSurah; // Mengembalikan daftar surah
    } else {
      print('Tidak ada playlist untuk hari $namaHari.');
    }
  } catch (e) {
    print('Terjadi kesalahan saat membaca file: $e');
  }
  return []; // Return an empty list if no playlist is found or an error occurs
}

String _namaHari(int weekday) {
  const hari = {
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu',
    7: 'Minggu',
  };
  return hari[weekday]!;
}

Future<String> getTerjemahan(int surah, int ayat) async {
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
    return 'Terjemahan tidak tersedia';
  }
}

Future<void> playAudio(int surah, int ayat, dynamic player) async {
  final audioPath =
      'quran_audio/$surah/${surah.toString().padLeft(3, '0')}${ayat.toString().padLeft(3, '0')}.mp3';
  try {
    print('Memutar audio: $audioPath');
    await player.setAsset(audioPath);
    await player.play();
  } catch (e) {
    print('Gagal memutar audio: $e');
  }
}
