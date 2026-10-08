/// 1Panel V2 统一响应结构
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResponse({
    required this.code,
    required this.message,
    this.data,
  });

  /// 1Panel V2 规范：code == 200 或 0 代表成功
  bool get isSuccess => code == 200 || code == 0;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic rawData)? fromData,
  ) {
    final code = json['code'] as int? ?? 0;
    final message = json['message'] as String? ?? '';
    final rawData = json['data'];

    T? parsedData;
    if (rawData != null && fromData != null) {
      parsedData = fromData(rawData);
    } else if (rawData is T) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      code: code,
      message: message,
      data: parsedData,
    );
  }

  @override
  String toString() => 'ApiResponse(code: $code, message: $message, data: $data)';
}
