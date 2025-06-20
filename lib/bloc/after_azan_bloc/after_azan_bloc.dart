import 'package:display_masjid/bloc/after_azan_bloc/after_azan_event.dart';
import 'package:display_masjid/bloc/after_azan_bloc/after_azan_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfterAzanBloc extends Bloc<AfterAzanEvent, AfterAzanState> {
  AfterAzanBloc() : super(AfterAzanState(isAfterAzan: false)) {
    on<AfterAzanStarted>((event, emit) {
      debugPrint('After Azan started');
      emit(AfterAzanState(isAfterAzan: true));
    });
    on<AfterAzanReset>((event, emit) {
      debugPrint('After Azan reset');
      emit(AfterAzanState(isAfterAzan: false));
    });
  }
}
