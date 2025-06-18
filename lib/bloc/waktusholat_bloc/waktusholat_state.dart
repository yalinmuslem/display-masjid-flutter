import 'package:display_masjid/model/waktusholat.dart';

class WaktuSholatState {
  final List<WaktuSholat> waktuSholatList;
  final WaktuSholat waktuSholatTerdekat;

  WaktuSholatState({
    required this.waktuSholatList,
    required this.waktuSholatTerdekat,
  });

  factory WaktuSholatState.loading() {
    return WaktuSholatState(
      waktuSholatList: [],
      waktuSholatTerdekat: WaktuSholat(waktu: '', waktuSholat: ''),
    );
  }
}
