import 'dart:convert';
import 'package:http/http.dart' as http;

class WaktuSholatApiService {
  static Future<Map<String, String>> fetchJadwalSholat() async {
    final now = DateTime.now();
    final date =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final url = Uri.parse(
      'https://api.aladhan.com/v1/timings/$date?latitude=6.1944&longitude=106.8229&method=20&shafaq=general&tune=5,3,5,7,9,-1,0,8,-6&timezonestring=Asia/Jakarta&calendarMethod=UAQ',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final timings = jsonBody['data']['timings'];
      return {
        'Subuh': timings['Fajr'],
        'Dzuhur': timings['Dhuhr'],
        'Ashar': timings['Asr'],
        'Maghrib': timings['Maghrib'],
        'Isya': timings['Isha'],
      };
    } else {
      throw Exception('Gagal mengambil jadwal sholat');
    }
  }
}
