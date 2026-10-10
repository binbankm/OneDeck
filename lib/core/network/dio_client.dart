import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'api_exception.dart';
import 'api_response.dart';

/// 1Panel V2 专用的核心网络客户端
class DioClient {
  final Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  String? _token;
  bool _allowSelfSigned;

  DioClient({
    Dio? customDio,
    String baseUrl = '',
    this._allowSelfSigned = true,
    Duration timeout = const Duration(seconds: 15),
  }) : _dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: timeout,
                receiveTimeout: timeout,
                sendTimeout: timeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    if (customDio == null) {
      _setupCertificateAdapter();
      _setupInterceptors();
    }
  }

  Dio get dio => _dio;
  String get baseUrl => _dio.options.baseUrl;
  String? get token => _token;
  bool get allowSelfSigned => _allowSelfSigned;

  /// 规范化请求路径，避免 leading slash 冲掉 baseUrl 中的子路径（如 /secret_entry/api/v2）
  String normalizePath(String path) {
    if (path.startsWith('/')) {
      return path.substring(1);
    }
    return path;
  }

  /// 更新服务器地址（自动适配反向代理域名、纯 IP、标准/自定义端口与安全入口）
  void updateServer({
    required String host,
    required int port,
    bool isHttps = true,
    String? entryPath,
    bool? allowSelfSigned,
  }) {
    if (allowSelfSigned != null) {
      _allowSelfSigned = allowSelfSigned;
      _setupCertificateAdapter();
    }

    // 1. 清理 host 中可能误粘的协议前缀和结尾斜杠
    String cleanHost = host.trim();
    if (cleanHost.startsWith('https://')) {
      cleanHost = cleanHost.substring(8);
      isHttps = true;
    } else if (cleanHost.startsWith('http://')) {
      cleanHost = cleanHost.substring(7);
      isHttps = false;
    }
    if (cleanHost.endsWith('/')) {
      cleanHost = cleanHost.substring(0, cleanHost.length - 1);
    }

    // 若 host 中已经包含了端口 (如 panel.com:8443)，提取出来
    int effectivePort = port;
    if (cleanHost.contains(':')) {
      final parts = cleanHost.split(':');
      cleanHost = parts[0];
      final parsedPort = int.tryParse(parts[1]);
      if (parsedPort != null && parsedPort > 0) {
        effectivePort = parsedPort;
      }
    }

    final scheme = isHttps ? 'https' : 'http';

    // 2. 智能处理端口（反代标准端口 443/80 或无效端口 0 时自动省略冒号端口）
    String portPart = '';
    final isDefaultPort = (isHttps && effectivePort == 443) || (!isHttps && effectivePort == 80) || effectivePort <= 0;
    if (!isDefaultPort) {
      portPart = ':$effectivePort';
    }

    // 3. 处理安全入口（没有安全入口时绝不产生多余斜杠）
    String cleanEntry = entryPath?.trim() ?? '';
    while (cleanEntry.startsWith('/')) {
      cleanEntry = cleanEntry.substring(1);
    }
    while (cleanEntry.endsWith('/')) {
      cleanEntry = cleanEntry.substring(0, cleanEntry.length - 1);
    }
    final entryPart = cleanEntry.isNotEmpty ? '/$cleanEntry' : '';

    // 4. 拼装 1Panel V2 统一 API 根路径（若未变更则静默跳过，避免全平台轮询时日志爆炸与重复配置）
    final targetBaseUrl = '$scheme://$cleanHost$portPart$entryPart/api/v2/';
    if (_dio.options.baseUrl != targetBaseUrl) {
      _dio.options.baseUrl = targetBaseUrl;
      _logger.i('1Panel 基础服务已切换: ${_dio.options.baseUrl}');
    }
  }

  /// 更新 JWT 鉴权 Token
  void setToken(String? token) {
    if (_token != token) {
      _token = token;
    }
  }

  void _setupCertificateAdapter() {
    if (kIsWeb) return;
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        if (_allowSelfSigned) {
          // 豁免自签名与局域网无 CA 证书拦截
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        }
        return client;
      },
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && _token!.isNotEmpty) {
            // 1Panel V2 规范鉴权签名：
            // 1Panel-Timestamp: 秒级时间戳
            // 1Panel-Token: md5("1panel" + APIKey + Timestamp)
            final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            final rawSign = '1panel$_token$timestamp';
            final md5Token = md5.convert(utf8.encode(rawSign)).toString();

            options.headers['1Panel-Timestamp'] = timestamp.toString();
            options.headers['1Panel-Token'] = md5Token;
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final apiException = _handleDioError(error);
          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: apiException,
              message: apiException.message,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    );
  }

  ApiException _handleDioError(DioException error) {
    final errStr = '${error.error ?? ""} ${error.message ?? ""}';
    if (error.error is HandshakeException ||
        errStr.contains('HandshakeException') ||
        errStr.contains('WRONG_VERSION_NUMBER') ||
        errStr.contains('alert protocol version') ||
        errStr.contains('CERTIFICATE_VERIFY_FAILED') ||
        errStr.contains('TlsException')) {
      return const ApiException(
        code: ApiException.sslError,
        message: 'SSL/TLS 握手失败：目标端口可能未开启 HTTPS（请关闭“启用 HTTPS”）或证书不匹配',
      );
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(code: ApiException.networkError, message: '连接服务器超时，请检查网络或端口');
    }

    if (error.type == DioExceptionType.badCertificate) {
      return const ApiException(code: ApiException.sslError, message: '证书校验失败，若使用自签名证书请开启“允许自签名”');
    }

    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(code: ApiException.networkError, message: '无法连接到服务器，请检查地址与端口是否开放');
    }

    final resp = error.response;
    if (resp != null) {
      final statusCode = resp.statusCode ?? ApiException.serverError;
      if (resp.data is Map<String, dynamic>) {
        final map = resp.data as Map<String, dynamic>;
        final msg = map['message'] as String? ?? '服务器返回错误 ($statusCode)';
        final code = map['code'] as int? ?? statusCode;
        return ApiException(code: code, message: msg, details: map);
      }
      return ApiException(code: statusCode, message: '服务器异常 ($statusCode)');
    }

    return ApiException(code: ApiException.networkError, message: error.message ?? '未知网络错误');
  }

  /// 统一 GET 请求
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromData,
  }) async {
    try {
      final cleanPath = normalizePath(path);
      final response = await _dio.get(cleanPath, queryParameters: queryParameters, options: options);
      return _parseResponse<T>(response, fromData);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleDioError(e);
    }
  }

  /// 统一 POST 请求
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? fromData,
  }) async {
    try {
      final cleanPath = normalizePath(path);
      final response = await _dio.post(cleanPath, data: data, queryParameters: queryParameters, options: options);
      return _parseResponse<T>(response, fromData);
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw _handleDioError(e);
    }
  }

  ApiResponse<T> _parseResponse<T>(Response response, T Function(dynamic data)? fromData) {
    if (response.data is Map<String, dynamic>) {
      final apiResp = ApiResponse<T>.fromJson(response.data as Map<String, dynamic>, fromData);
      if (!apiResp.isSuccess) {
        throw ApiException(code: apiResp.code, message: apiResp.message);
      }
      return apiResp;
    }
    return ApiResponse<T>(code: 200, message: 'OK', data: response.data as T?);
  }
}
