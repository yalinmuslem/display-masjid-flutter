import 'package:display_masjid/bloc/quran_bloc/quran_event.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc()
    : super(
        QuranState(
          surahName: null,
          surahNumber: null,
          ayahCount: null,
          audioUrl: null,
          isPlaying: null,
        ),
      ) {
    on<QuranFetchEvent>((event, emit) async {
      // Simulate fetching Quran data
      await Future.delayed(const Duration(seconds: 1));

      // Emit the fetched state
      emit(
        QuranState(
          surahName: 'Al-Fatiha',
          surahNumber: event.surahNumber,
          ayahCount: 7,
          audioUrl: 'https://example.com/audio/${event.surahNumber}.mp3',
          isPlaying: false,
        ),
      );
    });
  }
}
