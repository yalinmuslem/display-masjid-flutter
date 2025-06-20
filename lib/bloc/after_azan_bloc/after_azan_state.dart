class AfterAzanState {
  final bool isAfterAzan;

  AfterAzanState({required this.isAfterAzan});

  factory AfterAzanState.initial() {
    return AfterAzanState(isAfterAzan: false);
  }
}
