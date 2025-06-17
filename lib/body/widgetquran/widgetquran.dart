import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

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

// list mosque_images from folder assets/mosque_images dynamically
Future<List<String>> getMosqueImages() async {
  final imageFolder = 'mosque_images';
  final images = <String>[];

  for (int i = 1; i <= 10; i++) {
    // if file exists in assets/mosque_images/mosque_i.jpg
    try {
      final imagePath = '$imageFolder/images-$i.jpg';
      // Check if the file exists in the assets
      rootBundle
          .load(imagePath)
          .then((_) {
            images.add(imagePath);
          })
          .catchError((error) {
            // If the file does not exist, we can ignore it
            // print('File tidak ditemukan: $imagePath');
          });
    } catch (e) {
      // print('Error loading image: $e');
    }
  }

  // if no images found, return a default image
  if (images.isEmpty) {
    images.add('mosque_images/default.jpg'); // Add a default image
  }

  return images;
}

class DisplayWidgetQuran extends StatefulWidget {
  const DisplayWidgetQuran({super.key});

  @override
  State<DisplayWidgetQuran> createState() => _DisplayWidgetQuranState();
}

class _DisplayWidgetQuranState extends State<DisplayWidgetQuran> {
  final randomVerse = quran.RandomVerse();
  final hariIni = DateTime.now().weekday;
  final AudioPlayer player = AudioPlayer();
  List<dynamic> quranPlaylist = [];
  Map<String, dynamic>? surahHariIni;
  List<String> mosqueImages = [];

  int surahNumber = 1;
  int ayatNumber = 1;
  late int jumlahAyat;

  @override
  void initState() {
    super.initState();

    // Mendapatkan playlist Quran
    getQuranPlaylist().then((playlist) {
      setState(() {
        quranPlaylist = playlist;
        if (quranPlaylist.isNotEmpty) {
          // Ambil surah pertama dari playlist
          surahHariIni = quranPlaylist[0];
          surahNumber = surahHariIni!['nomor_surat'];
          ayatNumber = 1; // Mulai dari ayat pertama
          jumlahAyat = quran.getVerseCount(surahNumber);

          print(
            '📖 Playlist Quran hari ini: ${surahHariIni!['nama']} jumlah ayat: ${jumlahAyat}',
          );
        } else {
          // random surah jika tidak ada playlist untuk hari ini
          jumlahAyat = quran.getVerseCount(randomVerse.surahNumber);
          surahNumber = randomVerse.surahNumber;
          ayatNumber = 1; // Mulai dari ayat pertama
          debugPrint('Tidak ada playlist Quran untuk hari ini.');
        }
      });
    });

    // mendapatkan images dari folder assets/mosque_images
    getMosqueImages().then((images) {
      // Do something with the images if needed
      setState(() {
        mosqueImages = images;
      });
      print('Images loaded: ${images.length} ${mosqueImages.length}');
    });

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
            surahNumber++;
            if (surahNumber > quranPlaylist.length) {
              surahNumber =
                  1; // Reset ke surah pertama jika sudah melewati jumlah surah
            }
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
      print('Memutar audio: $audioPath');
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
          key: const Key('widget_mosque_image'),
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 450, // Set the height of the container
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    mosqueImages.isNotEmpty
                        ? mosqueImages[0] // Display the first image
                        : 'mosque_images/default.jpg', // Default image if none available
                  ),
                  fit: BoxFit.cover,
                ),
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
            ),
          ),
        ),
        Expanded(
          key: const Key('widget_quran_surah'),
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 450,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 150),
                        child: Text(
                          quran.getVerse(surahNumber, ayatNumber),
                          style: GoogleFonts.getFont(
                            'Amiri Quran',
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Image.asset(
                    //   _getImageAssetPath(surahNumber, ayatNumber),
                    //   fit: BoxFit.contain,
                    //   width: double.infinity,
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       const Text('Gambar tidak ditemukan!!'),
                    // ),),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0),
                      child: FutureBuilder<String>(
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
