import 'dart:async';
import 'dart:convert';

import 'package:display_masjid/services/quran_playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;
import 'package:carousel_slider_x/carousel_slider_x.dart';

class DisplayWidgetQuran extends StatefulWidget {
  final List<dynamic> waktuSholat;
  final List<dynamic> waktuAzan;

  const DisplayWidgetQuran({
    super.key,
    required this.waktuSholat,
    required this.waktuAzan,
  });

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
  late Future<List<String>> _mosqueImagesFuture;
  int currentSurahIndex = 0;
  int surahNumber = 1;
  int ayatNumber = 1;
  late int jumlahAyat;

  @override
  void initState() {
    super.initState();
    _mosqueImagesFuture = getMosqueImages(); // hanya dipanggil sekali

    // Mendapatkan playlist Quran
    getQuranPlaylist().then((playlist) {
      setState(() {
        quranPlaylist = playlist;
        if (quranPlaylist.isNotEmpty) {
          // Ambil surah pertama dari playlist
          surahHariIni = quranPlaylist[currentSurahIndex];
          surahNumber = surahHariIni!['nomor_surat'];
          ayatNumber = 1; // Mulai dari ayat pertama
          jumlahAyat = quran.getVerseCount(surahNumber);

          print(
            '📖 Playlist Quran hari ini: ${surahHariIni!['nama']} jumlah ayat: $jumlahAyat',
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
          // player.dispose(); // Dispose the previous player instance
          _playAudio();
        } else {
          // Jika sudah mencapai akhir surah, reset ke ayat pertama
          setState(() {
            ayatNumber = 1;
            currentSurahIndex++;
            if (currentSurahIndex >= quranPlaylist.length) {
              currentSurahIndex = 0; // ulang dari awal playlist
            }
            surahHariIni = quranPlaylist[currentSurahIndex];
            surahNumber = surahHariIni!['nomor_surat'];
            jumlahAyat = quran.getVerseCount(surahNumber);
          });
          // player.dispose(); // Dispose the previous player instance
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

  // list mosque_images from folder assets/mosque_images dynamically
  Future<List<String>> getMosqueImages() async {
    final images = <String>[];

    for (int i = 1; i <= 10; i++) {
      try {
        final imagePath = 'assets/mosque_images/images-$i.jpg';
        // Check if the file exists in the assets
        await rootBundle.load(imagePath);
        images.add(imagePath);
      } catch (e) {
        // Log the error if the file does not exist
        // print('Error loading image: $imagePath - $e');
      }
    }

    if (images.isEmpty) {
      // If no images found, add a default image
      images.add('assets/mosque_images/default.jpg');
    }

    // print('Loaded mosque images: ${images.length}');

    return images;
  }

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

    for (var waktu in widget.waktuAzan) {
      print('Waktu Azan: ${waktu.waktu} ${waktu.waktuSholat}');
    }

    return Row(
      children: [
        Expanded(
          key: const Key('widget_mosque_image'),
          flex: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(2),
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
                  child: FutureBuilder<List<String>>(
                    future: _mosqueImagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Gagal memuat gambar'));
                      } else {
                        mosqueImages = snapshot.data ?? [];
                        return CarouselSlider.builder(
                          itemCount: mosqueImages.length,
                          itemBuilder: (context, index, realIndex) {
                            return Image.asset(
                              mosqueImages[index],
                              fit: BoxFit.fitWidth,
                              width: double.infinity,
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 1 / 1,
                            enlargeCenterPage: false,
                            viewportFraction: 1.0,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(2),
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
                  child: Center(
                    child: Text(
                      'Surah Hari Ini:\n$surah',
                      style: GoogleFonts.getFont(
                        'Amiri Quran',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          key: const Key('widget_quran_surah'),
          flex: 8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                  top: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(flex: 6, child: Container()),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: TabWidget(
                          childContent: Column(
                            children: [
                              // Text(
                              //   '$waktuAzan',
                              //   textAlign: TextAlign.center,
                              //   style: GoogleFonts.bebasNeue(
                              //     fontSize: 24,
                              //     color: Colors.black,
                              //     height: 0.8,
                              //   ),
                              // ),
                              // StreamBuilder<DateTime>(
                              //   stream: Stream.periodic(
                              //     const Duration(seconds: 1),
                              //     (_) => DateTime.now(),
                              //   ),
                              //   builder: (context, snapshot) {
                              //     final currentTime =
                              //         snapshot.data ?? DateTime.now();
                              //     final parts = targetWaktu.waktuSholat.split(
                              //       ':',
                              //     );
                              //     final jam = int.parse(parts[0]);
                              //     final menit = int.parse(parts[1]);
                              //     final targetTime = DateTime(
                              //       currentTime.year,
                              //       currentTime.month,
                              //       currentTime.day,
                              //       jam,
                              //       menit,
                              //     );
                              //     final durasi = targetTime.difference(
                              //       currentTime,
                              //     );
                              //     print('Target waktu sholat: $targetTime');
                              //     print('Durasi menuju sholat: $durasi');
                              //     if (durasi.isNegative) {
                              //       // perbarui targetWaktu jika sudah lewat dengan mengambil waktu sholat setelahnya
                              //       final nextWaktu = widget.waktuSholat
                              //           .firstWhere(
                              //             (waktu) {
                              //               final parts = waktu.waktuSholat
                              //                   .split(':');
                              //               final jamWaktu = int.parse(
                              //                 parts[0],
                              //               );
                              //               final menitWaktu = int.parse(
                              //                 parts[1],
                              //               );
                              //               final waktuSholatTime = DateTime(
                              //                 currentTime.year,
                              //                 currentTime.month,
                              //                 currentTime.day,
                              //                 jamWaktu,
                              //                 menitWaktu,
                              //               );
                              //               return waktuSholatTime.isAfter(
                              //                 currentTime,
                              //               );
                              //             },
                              //             orElse: () =>
                              //                 widget.waktuSholat.first,
                              //           );
                              //       targetWaktu = nextWaktu;
                              //       waktuTiba = true; // Set waktuTiba ke true
                              //     }
                              //     final formattedTime =
                              //         '${durasi.inHours.remainder(60).toString().padLeft(2, '0')}:${durasi.inMinutes.remainder(60).toString().padLeft(2, '0')}:${durasi.inSeconds.remainder(60).toString().padLeft(2, '0')}';
                              //     return Text(
                              //       formattedTime,
                              //       style: GoogleFonts.bebasNeue(
                              //         fontSize: 24,
                              //         color: Colors.black,
                              //       ),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ), // Add gap between Expanded widgets
                    Expanded(
                      flex: 2,
                      child: StreamBuilder<DateTime>(
                        stream: Stream.periodic(
                          const Duration(seconds: 1),
                          (_) => DateTime.now(),
                        ),
                        builder: (context, snapshot) {
                          final currentTime = snapshot.data ?? DateTime.now();
                          final formattedTime =
                              '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}:${currentTime.second.toString().padLeft(2, '0')}';
                          return TabWidget(
                            childContent: Text(
                              formattedTime,
                              style: GoogleFonts.bebasNeue(
                                fontSize: 32,
                                color: Colors.blueAccent[200],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Container(
                  height: 550,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/background/thomas-vimare-IZ01rjX0XQA-unsplash.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'QS. $surah : $ayatNumber',
                            style: GoogleFonts.bebasNeue(
                              fontSize: 48,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Center(
                            child: Text(
                              quran.getVerse(surahNumber, ayatNumber),
                              style: GoogleFonts.getFont(
                                'Amiri Quran',
                                fontSize: 36,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: FutureBuilder<String>(
                              future: _getTerjemahan(surahNumber, ayatNumber),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text('Gagal memuat terjemahan');
                                } else {
                                  return Text(
                                    snapshot.data ??
                                        'Terjemahan tidak tersedia',
                                    style: GoogleFonts.bebasNeue(
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2.0, 2.0),
                                          blurRadius: 4.0,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Reset ayatNumber to 1 to start from the beginning
                                ayatNumber = 1;
                                _playAudio();
                              });
                            },
                            child: const Text('Mulai dari Awal'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabWidget extends StatelessWidget {
  final dynamic childContent;

  const TabWidget({super.key, required this.childContent});

  get content => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(0, 0, 0, 0)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: const Color.fromARGB(155, 255, 255, 255),
      ),
      child: Center(
        child:
            childContent ??
            const Text(
              'Tidak ada data',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
      ),
    );
  }
}
