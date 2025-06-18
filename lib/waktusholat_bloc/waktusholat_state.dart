import 'package:display_masjid/model/waktusholat.dart';

class WaktuSholatState {
  final bool isUpdate;
  final List<WaktuSholat> waktuSholatList;
  final List<dynamic> waktuSholatTerdekat;

  WaktuSholatState(
    this.isUpdate, {
    required this.waktuSholatList,
    required this.waktuSholatTerdekat,
  });
}
