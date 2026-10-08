/// 1Panel 业务与网络统一异常
class ApiException implements Exception {
  final int code;
  final String message;
  final dynamic details;

  const ApiException({
    required this.code,
    required this.message,
    this.details,
  });

  /// 常见 1Panel 错误码定义
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
  static const int networkError = -1;
  static const int sslError = -2;

  bool get isUnauthorized => code == unauthorized;

  @override
  String toString() => message.isNotEmpty ? message : '请求失败 ($code)';
}
