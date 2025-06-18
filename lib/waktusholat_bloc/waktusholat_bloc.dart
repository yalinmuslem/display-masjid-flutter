import 'dart:ui';

import 'package:display_masjid/waktusholat_bloc/waktusholat_event.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_state.dart';
import 'package:display_masjid/waktusholat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaktusholatBloc extends Bloc<WaktuSholatEvent, WaktuSholatState> {
  WaktusholatBloc() : super(WaktuSholatState(true, waktuSholatList: loadWaktuSholatFromAsset())) {
    on<LoadWaktuSholat>((event, emit) {
      List<WaktuSholat> waktuSholatList = loadWaktuSholatFromAsset();

      // Here you can process the waktuSholatList if needed
      // For example, you might want to log the loaded data
      if (waktuSholatList.isEmpty) {
        print("No Waktu Sholat data loaded.");
      } else {
        print("Waktu Sholat data loaded successfully.");
      }
      // Emit the state with the loaded data
      emit(WaktuSholatState(false, waktuSholatList: waktuSholatList));
    });
    on<UpdateWaktuSholat>((event, emit) {
      // Handle the update event, for example, reloading the data
      print("Updating Waktu Sholat data...");
      // You can reload the data or perform any other update logic here
      // For simplicity, we will just reload the data from the asset
      emit(WaktuSholatState(true, waktuSholatList: loadWaktuSholatFromAsset()));
    });
  }
  
}

List<WaktuSholat> loadWaktuSholatFromAsset() {
  return [
    WaktuSholat(
      waktu: "Subuh",
      waktuSholat: "04:30",
      color: Color(0xFFFFD1DC), // Pastel pink
    ),
    WaktuSholat(
      waktu: "Fajar",
      waktuSholat: "10:00",
      color: Color(0xFFFFE0B2),
    ), // Pastel orange
    WaktuSholat(
      waktu: "Dzuhur",
      waktuSholat: "12:00",
      color: Color(0xFFB2F7EF), // Pastel teal
    ),
    WaktuSholat(
      waktu: "Ashar",
      waktuSholat: "15:30",
      color: Color(0xFFFFF5BA), // Pastel yellow
    ),
    WaktuSholat(
      waktu: "Maghrib",
      waktuSholat: "18:00",
      color: Color(0xFFB9FBC0), // Pastel green
    ),
    WaktuSholat(
      waktu: "Isya",
      waktuSholat: "18:47",
      color: Color(0xFFB5B9FC), // Pastel blue
    ),
  ];
}



WaktuSholat? getWaktuSholatTerdekat(List<WaktuSholat> waktuList) {
  final now = DateTime.now();
  final nowMinutes = now.hour * 60 + now.minute;

  for (final waktu in waktuList) {
    final parts = waktu.waktuSholat.split(':');
    final jam = int.parse(parts[0]);
    final menit = int.parse(parts[1]);
    final waktuMinutes = jam * 60 + menit;

    if (waktuMinutes >= nowMinutes) {
      return waktu;
    }
  }

  // Jika sudah lewat semua, bisa kembali ke yang pertama
  return waktuList.first;
}