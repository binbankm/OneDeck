// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/auth_models.dart';

class AuthApi {
  final DioClient client;

  const AuthApi(this.client);

  /// generate api key
  Future<ApiResponse<void>> postGenerate({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/api/generate', queryParameters: queryParameters);
  }

  /// Update api config
  Future<ApiResponse<void>> postUpdate(ApiInterfaceConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/api/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load captcha
  Future<ApiResponse<CaptchaResponse>> getCaptcha({Map<String, dynamic>? queryParameters}) async {
    return client.get<CaptchaResponse>('/core/auth/captcha', queryParameters: queryParameters, fromData: (d) => CaptchaResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Load current user info
  Future<ApiResponse<CurrentUserInfo>> getCurrent({Map<String, dynamic>? queryParameters}) async {
    return client.get<CurrentUserInfo>('/core/auth/current', queryParameters: queryParameters, fromData: (d) => CurrentUserInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Update current user info
  Future<ApiResponse<void>> postCurrentUpdate(CurrentUserUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/current/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Reset system password expired
  Future<ApiResponse<void>> postExpiredReset(PasswordUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/expired/reset', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// User login
  Future<ApiResponse<UserLoginInfo>> postLogin(Login request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<UserLoginInfo>('/core/auth/login', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => UserLoginInfo.fromJson(d as Map<String, dynamic>));
  }

  /// User logout
  Future<ApiResponse<void>> postLogout({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/logout', queryParameters: queryParameters);
  }

  /// User login with mfa
  Future<ApiResponse<UserLoginInfo>> postMfalogin(MFALogin request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<UserLoginInfo>('/core/auth/mfalogin', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => UserLoginInfo.fromJson(d as Map<String, dynamic>));
  }

  /// User login with passkey
  Future<ApiResponse<PasskeyBeginResponse>> postPasskeyBegin({Map<String, dynamic>? queryParameters}) async {
    return client.post<PasskeyBeginResponse>('/core/auth/passkey/begin', queryParameters: queryParameters, fromData: (d) => PasskeyBeginResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Delete passkey
  Future<ApiResponse<void>> postPasskeyDel({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/passkey/del', queryParameters: queryParameters);
  }

  /// User login with passkey
  Future<ApiResponse<UserLoginInfo>> postPasskeyFinish({Map<String, dynamic>? queryParameters}) async {
    return client.post<UserLoginInfo>('/core/auth/passkey/finish', queryParameters: queryParameters, fromData: (d) => UserLoginInfo.fromJson(d as Map<String, dynamic>));
  }

  /// List passkeys
  Future<ApiResponse<void>> getPasskeyList({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/auth/passkey/list', queryParameters: queryParameters);
  }

  /// Begin passkey registration
  Future<ApiResponse<PasskeyBeginResponse>> postPasskeyRegisterBegin(PasskeyRegisterRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PasskeyBeginResponse>('/core/auth/passkey/register/begin', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PasskeyBeginResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Finish passkey registration
  Future<ApiResponse<void>> postPasskeyRegisterFinish({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/passkey/register/finish', queryParameters: queryParameters);
  }

  /// Get Setting For Login
  Future<ApiResponse<LoginSetting>> getSetting({Map<String, dynamic>? queryParameters}) async {
    return client.get<LoginSetting>('/core/auth/setting', queryParameters: queryParameters, fromData: (d) => LoginSetting.fromJson(d as Map<String, dynamic>));
  }

  /// Get welcome page
  Future<ApiResponse<void>> getWelcome({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/auth/welcome', queryParameters: queryParameters);
  }

}