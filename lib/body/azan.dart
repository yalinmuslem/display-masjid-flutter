import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AzanPage extends StatelessWidget {

  const AzanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volume_up, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Waktu Azan:',
              style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Mohon tenang, azan sedang dikumandangkan',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(fontSize: 24, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );
  }
}
