import 'dart:math';

import 'package:display_masjid/model/waktusholat.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_event.dart';
import 'package:display_masjid/bloc/waktusholat_bloc/waktusholat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaktusholatBloc extends Bloc<WaktuSholatEvent, WaktuSholatState> {
  WaktusholatBloc()
    : super(
        WaktuSholatState(
          waktuSholatList: [],
          waktuSholatTerdekat: WaktuSholat(waktu: '', waktuSholat: ''),
        ),
      ) {
    on<LoadWaktuSholatFromApi>((event, emit) async {
      try {
        emit(WaktuSholatState.loading());
        // final rawData = await WaktuSholatApiService.fetchJadwalSholat();

        // sample rawData
        final Map<String, String> rawData = {
          'Subuh': '04:30',
          'Dzuhur': '12:00',
          'Ashar': '15:30',
          'Maghrib': '18:00',
          'Isya': '19:30',
        };

        // print (rawData);
        print('Waktu Sholat Data: $rawData');

        final List<WaktuSholat> data = rawData.entries.map((e) {
          return WaktuSholat(waktu: e.key, waktuSholat: e.value);
        }).toList();

        final terdekat = getWaktuSholatTerdekat(data);

        emit(
          WaktuSholatState(
            waktuSholatList: data,
            waktuSholatTerdekat: terdekat,
          ),
        );
      } catch (e) {
        emit(
          WaktuSholatState(
            waktuSholatList: [],
            waktuSholatTerdekat: WaktuSholat(waktu: '', waktuSholat: ''),
          ),
        ); // atau state error custom
      }
    });
  }
}
