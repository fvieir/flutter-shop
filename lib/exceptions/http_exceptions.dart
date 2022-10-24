class HttpExceptions implements Exception {
  final String msg;
  final int? statusCode;

  HttpExceptions({
    required this.msg,
    this.statusCode = 400,
  });

  @override
  String toString() {
    return msg.toString();
  }
}
