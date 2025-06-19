import 'dart:async';

import 'package:display_masjid/bloc/azan_bloc/azan_bloc.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_event.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_bloc.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_event.dart';
import 'package:display_masjid/services/quran_playlist_service.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_bloc.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

class DisplayWidgetQuran extends StatefulWidget {
  const DisplayWidgetQuran({super.key});

  @override
  State<DisplayWidgetQuran> createState() => _DisplayWidgetQuranState();
}

class _DisplayWidgetQuranState extends State<DisplayWidgetQuran> {
  final randomVerse = quran.RandomVerse();
  final hariIni = DateTime.now().weekday;
  final AudioPlayer player = AudioPlayer();
  List<Map<String, dynamic>> quranPlaylist = [];
  Map<String, dynamic>? surahHariIni;
  List<String> mosqueImages = [];
  int currentSurahIndex = 0;
  int surahNumber = 1;
  int ayatNumber = 1;
  late int jumlahAyat = 1;
  bool isAzan = false;
  bool isRandom = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

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

          debugPrint(
            '📖 Playlist Quran hari ini: ${surahHariIni!['nama']} jumlah ayat: $jumlahAyat',
          );
        } else {
          // random surah jika tidak ada playlist untuk hari ini
          jumlahAyat = quran.getVerseCount(randomVerse.surahNumber);
          surahNumber = randomVerse.surahNumber;
          ayatNumber = 1; // Mulai dari ayat pertama
          isRandom = true;
          debugPrint('Tidak ada playlist Quran untuk hari ini.');
        }
      });
    });

    // _playAudio();

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!isRandom) {
          if (ayatNumber < jumlahAyat) {
            setState(() {
              // Increment ayatNumber to play the next ayat
              ayatNumber++;
            });
            // player.dispose(); // Dispose the previous player instance
            playAudio(surahNumber, ayatNumber, player);
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
            playAudio(surahNumber, ayatNumber, player);
          }
        } else {
          setState(() {
            ayatNumber++;
          });
          playAudio(surahNumber, ayatNumber, player);
        }
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surah = quran.getSurahName(surahNumber);
    final bool isAzanPlaying = context.watch<AzanBloc>().state.isAzanPlaying;
    final quranBloc = context.read<QuranBloc>();
    quranBloc.add(
      QuranFetchEvent(
        surahNumber: surahNumber,
        ayahNumber: ayatNumber,
        ayahCount: jumlahAyat,
        isPlaying: isPlaying,
      ),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          child: Row(
            children: [
              Expanded(flex: 6, child: Container()),
              Expanded(
                flex: 2,
                child: Center(
                  child: TabWidget(
                    childContent: BlocBuilder<WaktusholatBloc, WaktuSholatState>(
                      builder: (context, state) {
                        final String waktuAzan =
                            state.waktuSholatTerdekat.waktu;
                        final String jamAzan =
                            state.waktuSholatTerdekat.waktuSholat;

                        return Column(
                          children: [
                            Text(
                              waktuAzan,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.bebasNeue(
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            StreamBuilder<DateTime>(
                              stream: Stream.periodic(
                                const Duration(seconds: 1),
                                (_) => DateTime.now(),
                              ),
                              builder: (context, snapshot) {
                                if (jamAzan.isEmpty) {
                                  return Text(
                                    'Loading...',
                                    style: GoogleFonts.bebasNeue(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  );
                                }

                                final currentTime =
                                    snapshot.data ?? DateTime.now();
                                final parts = jamAzan.split(':');
                                final jam = parts[0];
                                final menit = parts[1];
                                final targetTime = DateTime(
                                  currentTime.year,
                                  currentTime.month,
                                  currentTime.day,
                                  int.parse(jam),
                                  int.parse(menit),
                                );
                                final durasi = targetTime.difference(
                                  currentTime,
                                );

                                // debugPrint('Durasi: ${durasi.inSeconds}');

                                if (durasi.inSeconds == 0 && !isAzanPlaying) {
                                  context.read<AzanBloc>().add(
                                    AzanBerkumandang(waktuAzan),
                                  );
                                }

                                final formattedTime =
                                    '-${durasi.inHours.toString().padLeft(2, '0')}:${(durasi.inMinutes % 60).toString().padLeft(2, '0')}:${(durasi.inSeconds % 60).toString().padLeft(2, '0')}';
                                return Text(
                                  formattedTime,
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Add gap between Expanded widgets
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
                        future: getTerjemahan(surahNumber, ayatNumber),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('Gagal memuat terjemahan');
                          } else {
                            return Text(
                              snapshot.data ?? 'Terjemahan tidak tersedia',
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
                          isPlaying = true;
                          playAudio(surahNumber, ayatNumber, player);
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
