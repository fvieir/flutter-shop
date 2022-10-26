class HttpException implements Exception {
  final String msg;
  final int? statusCode;

  HttpException({
    required this.msg,
    this.statusCode = 400,
  });

  @override
  String toString() {
    return msg.toString();
  }
}
