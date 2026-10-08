import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:one_deck/core/network/dio_client.dart';
import 'package:one_deck/features/auth/data/api/auth_api.dart';
import 'package:one_deck/features/auth/data/models/auth_models.dart';

void main() {
  group('AuthApi Unit Tests', () {
    late Dio mockDio;
    late DioClient dioClient;
    late AuthApi authApi;

    setUp(() {
      mockDio = Dio(BaseOptions(baseUrl: 'https://test.1panel.com/api/v2/'));
      dioClient = DioClient(customDio: mockDio);
      authApi = AuthApi(dioClient);
    });

    test('getCaptcha 能够正确请求并映射 CaptchaResponse', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, 'core/auth/captcha');
            expect(options.method, 'GET');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'code': 200,
                  'message': 'success',
                  'data': {
                    'captchaID': 'captcha_uuid_999',
                    'imagePath': 'data:image/png;base64,...'
                  }
                },
              ),
            );
          },
        ),
      );

      final resp = await authApi.getCaptcha();
      expect(resp.isSuccess, isTrue);
      expect(resp.data?.captchaID, 'captcha_uuid_999');
      expect(resp.data?.imagePath, 'data:image/png;base64,...');
    });

    test('postLogin 能够正确序列化入参并反序列化 UserLoginInfo', () async {
      mockDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.path, 'core/auth/login');
            expect(options.method, 'POST');
            final body = options.data as Map<String, dynamic>;
            expect(body['name'], 'admin');
            expect(body['password'], 'secret_hash_password');
            return handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'code': 200,
                  'message': 'success',
                  'data': {
                    'name': 'admin',
                    'token': 'generated_jwt_token_888',
                    'role': 'Admin',
                    'mfaStatus': 'disable'
                  }
                },
              ),
            );
          },
        ),
      );

      final loginReq = const Login(
        name: 'admin',
        password: 'secret_hash_password',
      );

      final resp = await authApi.postLogin(loginReq);
      expect(resp.isSuccess, isTrue);
      expect(resp.data?.name, 'admin');
      expect(resp.data?.token, 'generated_jwt_token_888');
      expect(resp.data?.role, 'Admin');
    });
  });
}
