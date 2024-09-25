class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Tidak Ada Koneksi Internet'});
}
