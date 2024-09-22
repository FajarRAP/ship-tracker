class ReceiptException implements Exception {
  final int statusCode;
  final String message;

  ReceiptException({required this.statusCode, required this.message});
}
