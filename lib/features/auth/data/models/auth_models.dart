// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class ApiInterfaceConfig {
  final String apiInterfaceStatus;
  final String apiKey;
  final int apiKeyValidityTime;
  final String apiTrustedProxies;
  final String ipWhiteList;

  const ApiInterfaceConfig({
    this.apiInterfaceStatus = '',
    this.apiKey = '',
    this.apiKeyValidityTime = 0,
    this.apiTrustedProxies = '',
    this.ipWhiteList = '',
  });

  factory ApiInterfaceConfig.fromJson(Map<String, dynamic> json) {
    return ApiInterfaceConfig(
      apiInterfaceStatus: json['apiInterfaceStatus'] as String? ?? '',
      apiKey: json['apiKey'] as String? ?? '',
      apiKeyValidityTime: (json['apiKeyValidityTime'] as num?)?.toInt() ?? 0,
      apiTrustedProxies: json['apiTrustedProxies'] as String? ?? '',
      ipWhiteList: json['ipWhiteList'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiInterfaceStatus': apiInterfaceStatus,
      'apiKey': apiKey,
      'apiKeyValidityTime': apiKeyValidityTime,
      'apiTrustedProxies': apiTrustedProxies,
      'ipWhiteList': ipWhiteList,
  };
}

class CaptchaResponse {
  final String captchaID;
  final String imagePath;

  const CaptchaResponse({
    this.captchaID = '',
    this.imagePath = '',
  });

  factory CaptchaResponse.fromJson(Map<String, dynamic> json) {
    return CaptchaResponse(
      captchaID: json['captchaID'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'captchaID': captchaID,
      'imagePath': imagePath,
  };
}

class CurrentUserInfo {
  final String apiInterfaceStatus;
  final String apiKey;
  final int apiKeyValidityTime;
  final String apiTrustedProxies;
  final String authSource;
  final String authSourceStatus;
  final String complexitySetting;
  final String ipWhiteList;
  final int mfaInterval;
  final String mfaStatus;
  final String name;
  final List<CurrentUserNodeRole> nodeRoles;
  final List<String> permissions;
  final String role;

  const CurrentUserInfo({
    this.apiInterfaceStatus = '',
    this.apiKey = '',
    this.apiKeyValidityTime = 0,
    this.apiTrustedProxies = '',
    this.authSource = '',
    this.authSourceStatus = '',
    this.complexitySetting = '',
    this.ipWhiteList = '',
    this.mfaInterval = 0,
    this.mfaStatus = '',
    this.name = '',
    this.nodeRoles = const [],
    this.permissions = const [],
    this.role = '',
  });

  factory CurrentUserInfo.fromJson(Map<String, dynamic> json) {
    return CurrentUserInfo(
      apiInterfaceStatus: json['apiInterfaceStatus'] as String? ?? '',
      apiKey: json['apiKey'] as String? ?? '',
      apiKeyValidityTime: (json['apiKeyValidityTime'] as num?)?.toInt() ?? 0,
      apiTrustedProxies: json['apiTrustedProxies'] as String? ?? '',
      authSource: json['authSource'] as String? ?? '',
      authSourceStatus: json['authSourceStatus'] as String? ?? '',
      complexitySetting: json['complexitySetting'] as String? ?? '',
      ipWhiteList: json['ipWhiteList'] as String? ?? '',
      mfaInterval: (json['mfaInterval'] as num?)?.toInt() ?? 0,
      mfaStatus: json['mfaStatus'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nodeRoles: (json['nodeRoles'] as List<dynamic>?)?.map((e) => CurrentUserNodeRole.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      role: json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiInterfaceStatus': apiInterfaceStatus,
      'apiKey': apiKey,
      'apiKeyValidityTime': apiKeyValidityTime,
      'apiTrustedProxies': apiTrustedProxies,
      'authSource': authSource,
      'authSourceStatus': authSourceStatus,
      'complexitySetting': complexitySetting,
      'ipWhiteList': ipWhiteList,
      'mfaInterval': mfaInterval,
      'mfaStatus': mfaStatus,
      'name': name,
      'nodeRoles': nodeRoles.map((e) => e.toJson()).toList(),
      'permissions': permissions,
      'role': role,
  };
}

class CurrentUserNodeRole {
  final int nodeId;
  final String nodeName;
  final int roleId;
  final String roleName;

  const CurrentUserNodeRole({
    this.nodeId = 0,
    this.nodeName = '',
    this.roleId = 0,
    this.roleName = '',
  });

  factory CurrentUserNodeRole.fromJson(Map<String, dynamic> json) {
    return CurrentUserNodeRole(
      nodeId: (json['nodeId'] as num?)?.toInt() ?? 0,
      nodeName: json['nodeName'] as String? ?? '',
      roleId: (json['roleId'] as num?)?.toInt() ?? 0,
      roleName: json['roleName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'nodeId': nodeId,
      'nodeName': nodeName,
      'roleId': roleId,
      'roleName': roleName,
  };
}

class CurrentUserUpdate {
  final String name;
  final String oldPassword;
  final String password;

  const CurrentUserUpdate({
    this.name = '',
    this.oldPassword = '',
    this.password = '',
  });

  factory CurrentUserUpdate.fromJson(Map<String, dynamic> json) {
    return CurrentUserUpdate(
      name: json['name'] as String? ?? '',
      oldPassword: json['oldPassword'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'oldPassword': oldPassword,
      'password': password,
  };
}

class Login {
  final String authSource;
  final String captcha;
  final String captchaID;
  final String language;
  final String name;
  final String password;

  const Login({
    this.authSource = '',
    this.captcha = '',
    this.captchaID = '',
    this.language = '',
    this.name = '',
    this.password = '',
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      authSource: json['authSource'] as String? ?? '',
      captcha: json['captcha'] as String? ?? '',
      captchaID: json['captchaID'] as String? ?? '',
      language: json['language'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'authSource': authSource,
      'captcha': captcha,
      'captchaID': captchaID,
      'language': language,
      'name': name,
      'password': password,
  };
}

class LoginSetting {
  final bool isDemo;
  final bool isEnterprise;
  final bool isFxplay;
  final bool isIntl;
  final bool isOffline;
  final String language;
  final String menuAccordion;
  final String menuTabs;
  final bool needCaptcha;
  final String panelName;
  final bool passkeySetting;
  final String theme;

  const LoginSetting({
    this.isDemo = false,
    this.isEnterprise = false,
    this.isFxplay = false,
    this.isIntl = false,
    this.isOffline = false,
    this.language = '',
    this.menuAccordion = '',
    this.menuTabs = '',
    this.needCaptcha = false,
    this.panelName = '',
    this.passkeySetting = false,
    this.theme = '',
  });

  factory LoginSetting.fromJson(Map<String, dynamic> json) {
    return LoginSetting(
      isDemo: json['isDemo'] as bool? ?? false,
      isEnterprise: json['isEnterprise'] as bool? ?? false,
      isFxplay: json['isFxplay'] as bool? ?? false,
      isIntl: json['isIntl'] as bool? ?? false,
      isOffline: json['isOffline'] as bool? ?? false,
      language: json['language'] as String? ?? '',
      menuAccordion: json['menuAccordion'] as String? ?? '',
      menuTabs: json['menuTabs'] as String? ?? '',
      needCaptcha: json['needCaptcha'] as bool? ?? false,
      panelName: json['panelName'] as String? ?? '',
      passkeySetting: json['passkeySetting'] as bool? ?? false,
      theme: json['theme'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'isDemo': isDemo,
      'isEnterprise': isEnterprise,
      'isFxplay': isFxplay,
      'isIntl': isIntl,
      'isOffline': isOffline,
      'language': language,
      'menuAccordion': menuAccordion,
      'menuTabs': menuTabs,
      'needCaptcha': needCaptcha,
      'panelName': panelName,
      'passkeySetting': passkeySetting,
      'theme': theme,
  };
}

class MFALogin {
  final String code;
  final String sessionId;

  const MFALogin({
    this.code = '',
    this.sessionId = '',
  });

  factory MFALogin.fromJson(Map<String, dynamic> json) {
    return MFALogin(
      code: json['code'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'code': code,
      'sessionId': sessionId,
  };
}

class PasskeyBeginResponse {
  final dynamic publicKey;
  final String sessionId;

  const PasskeyBeginResponse({
    this.publicKey,
    this.sessionId = '',
  });

  factory PasskeyBeginResponse.fromJson(Map<String, dynamic> json) {
    return PasskeyBeginResponse(
      publicKey: json['publicKey'],
      sessionId: json['sessionId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'publicKey': publicKey,
      'sessionId': sessionId,
  };
}

class PasskeyInfo {
  final String createdAt;
  final String id;
  final String lastUsedAt;
  final String name;

  const PasskeyInfo({
    this.createdAt = '',
    this.id = '',
    this.lastUsedAt = '',
    this.name = '',
  });

  factory PasskeyInfo.fromJson(Map<String, dynamic> json) {
    return PasskeyInfo(
      createdAt: json['createdAt'] as String? ?? '',
      id: json['id'] as String? ?? '',
      lastUsedAt: json['lastUsedAt'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'id': id,
      'lastUsedAt': lastUsedAt,
      'name': name,
  };
}

class PasskeyRegisterRequest {
  final String name;

  const PasskeyRegisterRequest({
    this.name = '',
  });

  factory PasskeyRegisterRequest.fromJson(Map<String, dynamic> json) {
    return PasskeyRegisterRequest(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
  };
}

class PasswordUpdate {
  final String newPassword;
  final String oldPassword;

  const PasswordUpdate({
    this.newPassword = '',
    this.oldPassword = '',
  });

  factory PasswordUpdate.fromJson(Map<String, dynamic> json) {
    return PasswordUpdate(
      newPassword: json['newPassword'] as String? ?? '',
      oldPassword: json['oldPassword'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'newPassword': newPassword,
      'oldPassword': oldPassword,
  };
}

class UserLoginInfo {
  final String mfaSession;
  final String mfaStatus;
  final String name;
  final String role;
  final String token;

  const UserLoginInfo({
    this.mfaSession = '',
    this.mfaStatus = '',
    this.name = '',
    this.role = '',
    this.token = '',
  });

  factory UserLoginInfo.fromJson(Map<String, dynamic> json) {
    return UserLoginInfo(
      mfaSession: json['mfaSession'] as String? ?? '',
      mfaStatus: json['mfaStatus'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'mfaSession': mfaSession,
      'mfaStatus': mfaStatus,
      'name': name,
      'role': role,
      'token': token,
  };
}
