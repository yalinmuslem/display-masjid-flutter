import 'dart:async';

import 'package:display_masjid/bloc/after_azan_bloc/after_azan_event.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfterAzanBloc extends Bloc<AfterAzanEvent, AfterAzanState> {
  Timer? timer;
  AfterAzanBloc() : super(AfterAzanState(isAfterAzan: false, isDone: false)) {
    on<AfterAzanStarted>((event, emit) {
      debugPrint('After Azan started');
      emit(AfterAzanState(isAfterAzan: true, isDone: false));

      // Start a timer to reset after 60 seconds
      timer?.cancel(); // Cancel any existing timer
      timer = Timer(const Duration(seconds: 60), () {
        debugPrint('After Azan has reset after 60 seconds');
        add(AfterAzanReset());
      });
    });
    on<AfterAzanReset>((event, emit) {
      debugPrint('After Azan reset');
      emit(AfterAzanState(isAfterAzan: false, isDone: true));
    });
  }
}
