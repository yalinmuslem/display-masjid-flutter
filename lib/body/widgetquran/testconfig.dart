import 'dart:convert';
import 'dart:io';

Future<List> printPlaylistHariIni() async {
  try {
    final file = File('assets/playlist_quran.json');
    final jsonString = await file.readAsString();
    final Map<String, dynamic> data = json.decode(jsonString);

    // Ambil hari ini (misal Senin)
    final now = DateTime.now();
    final namaHari = _namaHari(now.weekday); // "Senin", "Selasa", dst

    if (data.containsKey(namaHari)) {
      final List<dynamic> daftarSurah = data[namaHari];

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

void main() async {
  var surah = await printPlaylistHariIni();
  if (surah.isEmpty) {
    print('Tidak ada playlist Quran untuk hari ini.');
    return;
  }
  print('📖 Playlist Quran hari ini:');
  for (var s in surah) {
    print('   🔊 Surah ${s['nomor_surat']}: ${s['nama']} (${s['durasi']})');
  }
  print('✅ Selesai mencetak playlist hari ini.');
}
