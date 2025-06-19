import 'package:display_masjid/bloc/quran_bloc/quran_event.dart';
import 'package:display_masjid/bloc/quran_bloc/quran_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc()
    : super(
        QuranState(
          surahName: 'Al-Fatiha',
          surahNumber: 1,
          ayahCount: 7,
          isPlaying: true,
        ),
      ) {
    on<QuranFetchEvent>((event, emit) async {
      // Simulate fetching Quran data
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('Fetching Quran data for Surah ${event.surahNumber}');

      // Emit the fetched state
      emit(
        QuranState(
          surahName: event.surahNumber == 1
              ? 'Al-Fatiha'
              : 'Surah ${event.surahNumber}',
          surahNumber: event.surahNumber,
          ayahCount: event.ayahCount,
          isPlaying: false,
        ),
      );
    });
  }
}
