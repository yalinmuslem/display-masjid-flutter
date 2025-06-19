import 'package:carousel_slider_x/carousel_slider_x.dart';
import 'package:display_masjid/body/header/header.dart';
import 'package:display_masjid/body/widgetquran/widgetquran.dart';
import 'package:display_masjid/services/mosque_image_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/surah_data.dart';

class DisplayBody extends StatefulWidget {
  const DisplayBody({super.key});

  @override
  State<DisplayBody> createState() => _DisplayBodyState();
}

class _DisplayBodyState extends State<DisplayBody> {
  late Future<List<String>> _mosqueImagesFuture;

  @override
  void initState() {
    super.initState();
    _mosqueImagesFuture = getMosqueImages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DisplayHeader(),
        Expanded(
          child: Row(
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
                          border: Border.all(
                            color: const Color.fromARGB(0, 0, 0, 0),
                          ),
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text('Gagal memuat gambar'),
                              );
                            } else {
                              var mosqueImages = snapshot.data ?? [];
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
                          border: Border.all(
                            color: const Color.fromARGB(0, 0, 0, 0),
                          ),
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
                            'Surah Hari Ini:\n',
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
              SingleChildScrollView(child: DisplayWidgetQuran()),
            ],
          ),
        ),
      ],
    );
  }
}
