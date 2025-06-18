import 'package:display_masjid/bloc/azan_bloc/azan_event.dart';
import 'package:display_masjid/bloc/azan_bloc/azan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AzanBloc extends Bloc<AzanEvent, AzanState> {
  AzanBloc() : super(AzanState(isAzanPlaying: false)) {
    on<AzanBerkumandang>((event, emit) async {
      // Simulate loading azan data
      await Future.delayed(const Duration(seconds: 1));

      print('Azan is playing');
      emit(AzanState(isAzanPlaying: true));
    });
  }
}
