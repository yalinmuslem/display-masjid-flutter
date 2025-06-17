import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MasjidInfo {
  final String namaMasjid;
  final String alamatMasjid;

  MasjidInfo({required this.namaMasjid, required this.alamatMasjid});

  factory MasjidInfo.fromJson(Map<String, dynamic> json) {
    return MasjidInfo(
      namaMasjid: json['nama_masjid'] ?? 'Masjid Default',
      alamatMasjid: json['alamat_masjid'] ?? 'Alamat Default',
    );
  }
}

Future<MasjidInfo> loadMasjidInfoFromAsset() async {
  final jsonStr = await rootBundle.loadString('assets/masjid_config.json');
  final jsonMap = jsonDecode(jsonStr);
  return MasjidInfo.fromJson(jsonMap);
}

class DisplayInfoMasjid extends StatelessWidget {
  const DisplayInfoMasjid({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MasjidInfo>(
      future: loadMasjidInfoFromAsset(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading masjid info'));
        } else {
          final masjidInfo = snapshot.data!;
          return SizedBox(
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black), // Add border
            // ),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Masjid ', // Use null-aware operator
                      style: GoogleFonts.bebasNeue(
                        fontSize: 48,
                        color: Colors.blueAccent[200],
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      masjidInfo.namaMasjid, // Use null-aware operator
                      style: GoogleFonts.bebasNeue(
                        fontSize: 48,
                        color: Colors.yellow[600],
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
                ), // Add space between texts
                Text(
                  masjidInfo.alamatMasjid, // Use null-aware operator
                  style: GoogleFonts.bebasNeue(
                    fontSize: 26,
                    color: Colors.blueAccent[200],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
