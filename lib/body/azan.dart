import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AzanPage extends StatefulWidget {
  final String namaAzan;
  const AzanPage({super.key, required this.namaAzan});

  @override
  _AzanPageState createState() => _AzanPageState();
}

class _AzanPageState extends State<AzanPage> {
  @override
  void dispose() {
    // Ensure the stream is properly disposed
    super.dispose();
  }

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
              'Waktu Azan: ${widget.namaAzan}',
              style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Mohon tenang, azan sedang dikumandangkan',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 24,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
