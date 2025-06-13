import 'package:flutter/material.dart';

class DisplayLogoMasjid extends StatelessWidget {
  const DisplayLogoMasjid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // Add border
      ),
      height: 150,
      child: Image.asset(
        'assets/logo_masjid.png', // Path to your logo image
        fit: BoxFit.cover, // Adjust the fit as needed
      ),
    );
  }
}
