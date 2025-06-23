class AfterAzanState {
  final bool isAfterAzan;
  final bool isDone;

  AfterAzanState({required this.isAfterAzan, this.isDone = false});

  factory AfterAzanState.initial() {
    return AfterAzanState(isAfterAzan: false, isDone: false);
  }
}
