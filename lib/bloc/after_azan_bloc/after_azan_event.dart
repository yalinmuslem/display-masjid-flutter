abstract class AfterAzanEvent {}

class AfterAzanStarted extends AfterAzanEvent {
  late bool isAfterAzan;
  AfterAzanStarted({this.isAfterAzan = false});
}

class AfterAzanReset extends AfterAzanEvent {
  AfterAzanReset();
}
