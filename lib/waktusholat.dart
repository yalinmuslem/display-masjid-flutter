// class list waktu sholat hari ini
import 'package:display_masjid/model/waktusholat.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_bloc.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayWaktuSholat extends StatelessWidget {
  const DisplayWaktuSholat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(0, 0, 0, 0),
        ), // Add border
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<WaktusholatBloc, WaktuSholatState>(
            builder: (context, state) {
              final List<WaktuSholat> waktuSholatList = state.waktuSholatList;

              return ListView.builder(
                itemBuilder: (context, index) {
                  final WaktuSholat waktuSholat = waktuSholatList[index];
                  return _WidgetWaktuSholat(waktuSholat: waktuSholat);
                },
                itemCount: waktuSholatList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WidgetWaktuSholat extends StatelessWidget {
  final WaktuSholat waktuSholat;

  const _WidgetWaktuSholat({required this.waktuSholat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0), // lancip
          topLeft: Radius.circular(16), // melengkung
          bottomRight: Radius.circular(16), // melengkung
          bottomLeft: Radius.circular(0), // lancip
        ),
      ),
      elevation: 4.0, // Add shadow elevation
      shadowColor: Colors.black.withOpacity(0.5), // Set shadow color
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (waktuSholat.color ?? Colors.white).withOpacity(
                0.8,
              ), // Start color with alpha
              Colors.white.withOpacity(0.9), // End color with alpha
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(0),
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(0),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        width: double.infinity, // Set width to fill the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              waktuSholat.waktu,
              style: GoogleFonts.bebasNeue(
                fontSize: 40,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
                height: 0.8,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              waktuSholat.waktuSholat,
              style: GoogleFonts.protestStrike(
                fontSize: 50,
                color: Colors.yellow,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
