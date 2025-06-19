abstract class AzanEvent {}

class AzanBerkumandang extends AzanEvent {
  final String namaAzan;

  AzanBerkumandang(this.namaAzan);
}

class AzanReset extends AzanEvent {
  AzanReset();
}
