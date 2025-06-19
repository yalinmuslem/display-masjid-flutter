abstract class QuranEvent {}

class QuranFetchEvent extends QuranEvent {
  final int surahNumber;
  final int ayahNumber;

  QuranFetchEvent({required this.surahNumber, required this.ayahNumber});
}
