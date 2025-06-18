import 'package:display_masjid/model/waktusholat.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_event.dart';
import 'package:display_masjid/waktusholat_bloc/waktusholat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaktusholatBloc extends Bloc<WaktuSholatEvent, WaktuSholatState> {
  WaktusholatBloc() : super(WaktuSholatState(true, waktuSholatList: loadWaktuSholatFromAsset(), waktuSholatTerdekat: [getWaktuSholatTerdekat(loadWaktuSholatFromAsset())])) {
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
      emit(WaktuSholatState(false, waktuSholatList: loadWaktuSholatFromAsset(), waktuSholatTerdekat: [getWaktuSholatTerdekat(loadWaktuSholatFromAsset())]));
    });
    on<UpdateWaktuSholat>((event, emit) {
      // Handle the update event, for example, reloading the data
      print("Updating Waktu Sholat data...");
      // You can reload the data or perform any other update logic here
      // For simplicity, we will just reload the data from the asset
      emit(WaktuSholatState(true, waktuSholatList: loadWaktuSholatFromAsset(), waktuSholatTerdekat: [getWaktuSholatTerdekat(loadWaktuSholatFromAsset())]));
    });
  }
  
}
