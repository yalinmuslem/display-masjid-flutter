abstract class QuranEvent {}

class QuranFetchEvent extends QuranEvent {
  final int surahNumber;
  final int ayahNumber;
  final int ayahCount;
  final bool isPlaying;

  QuranFetchEvent({
    required this.surahNumber,
    required this.ayahNumber,
    required this.ayahCount,
    required this.isPlaying,
  });
}
