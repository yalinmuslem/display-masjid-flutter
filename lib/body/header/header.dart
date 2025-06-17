import 'package:display_masjid/body/header/logomasjid.dart';
import 'package:display_masjid/body/header/masjidinfo.dart';
import 'package:display_masjid/body/header/waktusaatini.dart';
import 'package:flutter/material.dart';

class DisplayHeader extends StatelessWidget {
  const DisplayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(70, 187, 222, 251),
              const Color.fromARGB(70, 100, 180, 246),
            ],
          ),
          border: Border.all(
            color: const Color.fromARGB(0, 0, 0, 0),
          ), // Add border
          borderRadius: BorderRadius.circular(2), // Rounded corners
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(flex: 1, child: DisplayLogoMasjid()),
            Expanded(flex: 7, child: DisplayInfoMasjid()),
            Expanded(flex: 2, child: DisplayWaktuSaatini()),
          ],
        ),
      ),
    );
  }
}
