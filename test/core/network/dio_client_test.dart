import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_deck/core/network/api_exception.dart';
import 'package:one_deck/core/network/api_response.dart';
import 'package:one_deck/core/network/dio_client.dart';

void main() {
  group('ApiResponse Tests', () {
    test('正确解析成功响应 (code: 200)', () {
      final json = {
        'code': 200,
        'message': 'success',
        'data': {'username': 'admin', 'token': 'fake_token'}
      };

      final response = ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (data) => data as Map<String, dynamic>,
      );

      expect(response.isSuccess, isTrue);
      expect(response.code, 200);
      expect(response.message, 'success');
      expect(response.data?['username'], 'admin');
    });

    test('正确识别业务失败响应 (code: 500)', () {
      final json = {
        'code': 500,
        'message': '用户名或密码不正确',
        'data': null,
      };

      final response = ApiResponse<dynamic>.fromJson(json, null);

      expect(response.isSuccess, isFalse);
      expect(response.code, 500);
      expect(response.message, '用户名或密码不正确');
      expect(response.data, isNull);
    });
  });

  group('ApiException Tests', () {
    test('异常属性与字符串表示', () {
      const exception = ApiException(code: 401, message: '登录凭证已过期');
      expect(exception.code, 401);
      expect(exception.message, '登录凭证已过期');
      expect(exception.isUnauthorized, isTrue);
      expect(exception.toString(), '登录凭证已过期');
    });
  });

  group('DioClient 各种网络连接场景测试（无安全入口 / HTTP / HTTPS / 反代域名 / IP+端口）', () {
    late DioClient client;

    setUp(() {
      client = DioClient();
    });

    test('场景 1: 纯 IP + 自定义端口（无安全入口, HTTP）', () {
      client.updateServer(
        host: '192.168.1.100',
        port: 9999,
        isHttps: false,
        entryPath: null,
      );
      expect(client.baseUrl, 'http://192.168.1.100:9999/api/v2/');
    });

    test('场景 2: 纯 IP + 自定义端口（无安全入口, HTTPS）', () {
      client.updateServer(
        host: '1.2.3.4',
        port: 8888,
        isHttps: true,
        entryPath: '',
      );
      expect(client.baseUrl, 'https://1.2.3.4:8888/api/v2/');
    });

    test('场景 3: 反代域名（HTTPS 标准 443 端口, 无安全入口）自动省略 :443', () {
      client.updateServer(
        host: 'panel.myvps.com',
        port: 443,
        isHttps: true,
        entryPath: null,
      );
      expect(client.baseUrl, 'https://panel.myvps.com/api/v2/');
    });

    test('场景 4: 反代域名（HTTP 标准 80 端口, 无安全入口）自动省略 :80', () {
      client.updateServer(
        host: 'panel.internal.lan',
        port: 80,
        isHttps: false,
        entryPath: '',
      );
      expect(client.baseUrl, 'http://panel.internal.lan/api/v2/');
    });

    test('场景 5: 反代域名 + 自定义高防/映射端口（HTTPS, 无安全入口）', () {
      client.updateServer(
        host: 'panel.myvps.com',
        port: 8443,
        isHttps: true,
        entryPath: '',
      );
      expect(client.baseUrl, 'https://panel.myvps.com:8443/api/v2/');
    });

    test('场景 6: 用户输入包含协议与末尾斜杠的容错测试 (如误贴完整 URL)', () {
      client.updateServer(
        host: 'https://10.0.0.1:9999/',
        port: 9999,
        isHttps: true,
      );
      expect(client.baseUrl, 'https://10.0.0.1:9999/api/v2/');

      client.updateServer(
        host: 'http://panel.example.com/',
        port: 80,
        isHttps: false,
      );
      expect(client.baseUrl, 'http://panel.example.com/api/v2/');
    });

    test('场景 7: 安全入口斜杠容错测试（空斜杠/多斜杠不产生多余 //）', () {
      // 只有斜杠视为无安全入口
      client.updateServer(
        host: '192.168.1.1',
        port: 8888,
        isHttps: false,
        entryPath: '  /  ',
      );
      expect(client.baseUrl, 'http://192.168.1.1:8888/api/v2/');

      // 多斜杠正常去除
      client.updateServer(
        host: 'panel.com',
        port: 443,
        isHttps: true,
        entryPath: '///my_safe_path///',
      );
      expect(client.baseUrl, 'https://panel.com/my_safe_path/api/v2/');
    });

    test('场景 8: 路径规范化（防止冲刷 BaseURL 子路径）', () {
      expect(client.normalizePath('/core/auth/login'), 'core/auth/login');
      expect(client.normalizePath('core/auth/login'), 'core/auth/login');
      expect(client.normalizePath('/dashboard/base/os'), 'dashboard/base/os');
    });
  });

  group('DioClient Mock Network Request Tests', () {
    late Dio mockDio;
    late DioClient client;

    setUp(() {
      mockDio = Dio(BaseOptions(baseUrl: 'https://test.1panel.com/api/v2/'));
      client = DioClient(customDio: mockDio);
    });

    test('GET 成功请求能够正常解析泛型数据', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'code': 200,
                  'message': 'success',
                  'data': {'os': 'Ubuntu 22.04', 'uptime': 3600}
                },
              ),
            );
          },
        ),
      );

      final response = await client.get<Map<String, dynamic>>(
        '/dashboard/base/os',
        fromData: (data) => data as Map<String, dynamic>,
      );

      expect(response.isSuccess, isTrue);
      expect(response.data?['os'], 'Ubuntu 22.04');
    });

    test('POST 业务错误返回 (code: 500) 自动转化为 ApiException', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'code': 500,
                  'message': '验证码已失效',
                  'data': null,
                },
              ),
            );
          },
        ),
      );

      expect(
        () async => await client.post('/core/auth/login', data: {}),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 500)
              .having((e) => e.message, 'message', '验证码已失效'),
        ),
      );
    });

    test('HTTP 401 响应正确转化为 ApiException 并标记 isUnauthorized', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                  data: {
                    'code': 401,
                    'message': 'Token expired',
                  },
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      expect(
        () async => await client.get('/core/auth/current'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 401)
              .having((e) => e.isUnauthorized, 'isUnauthorized', isTrue),
        ),
      );
    });
  });
}
