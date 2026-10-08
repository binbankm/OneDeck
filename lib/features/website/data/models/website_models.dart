// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AppResource {
  final String name;
  final String type;

  const AppResource({
    this.name = '',
    this.type = '',
  });

  factory AppResource.fromJson(Map<String, dynamic> json) {
    return AppResource(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'type': type,
  };
}

class NginxAuth {
  final String remark;
  final String username;

  const NginxAuth({
    this.remark = '',
    this.username = '',
  });

  factory NginxAuth.fromJson(Map<String, dynamic> json) {
    return NginxAuth(
      remark: json['remark'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'remark': remark,
      'username': username,
  };
}

class NginxKey {

  const NginxKey();

  factory NginxKey.fromJson(Map<String, dynamic> json) {
    return NginxKey(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class NginxModuleArtifact {
  final String checksum;
  final String name;
  final String path;

  const NginxModuleArtifact({
    this.checksum = '',
    this.name = '',
    this.path = '',
  });

  factory NginxModuleArtifact.fromJson(Map<String, dynamic> json) {
    return NginxModuleArtifact(
      checksum: json['checksum'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'checksum': checksum,
      'name': name,
      'path': path,
  };
}

class NginxUpstream {
  final String algorithm;
  final String content;
  final String name;
  final List<NginxUpstreamServer> servers;

  const NginxUpstream({
    this.algorithm = '',
    this.content = '',
    this.name = '',
    this.servers = const [],
  });

  factory NginxUpstream.fromJson(Map<String, dynamic> json) {
    return NginxUpstream(
      algorithm: json['algorithm'] as String? ?? '',
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'algorithm': algorithm,
      'content': content,
      'name': name,
      'servers': servers.map((e) => e.toJson()).toList(),
  };
}

class NginxUpstreamServer {
  final int failTimeout;
  final String failTimeoutUnit;
  final String flag;
  final int maxConns;
  final int maxFails;
  final String server;
  final int weight;

  const NginxUpstreamServer({
    this.failTimeout = 0,
    this.failTimeoutUnit = '',
    this.flag = '',
    this.maxConns = 0,
    this.maxFails = 0,
    this.server = '',
    this.weight = 0,
  });

  factory NginxUpstreamServer.fromJson(Map<String, dynamic> json) {
    return NginxUpstreamServer(
      failTimeout: (json['failTimeout'] as num?)?.toInt() ?? 0,
      failTimeoutUnit: json['failTimeoutUnit'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      maxConns: (json['maxConns'] as num?)?.toInt() ?? 0,
      maxFails: (json['maxFails'] as num?)?.toInt() ?? 0,
      server: json['server'] as String? ?? '',
      weight: (json['weight'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'failTimeout': failTimeout,
      'failTimeoutUnit': failTimeoutUnit,
      'flag': flag,
      'maxConns': maxConns,
      'maxFails': maxFails,
      'server': server,
      'weight': weight,
  };
}

class OperateByID {
  final int id;

  const OperateByID({
    this.id = 0,
  });

  factory OperateByID.fromJson(Map<String, dynamic> json) {
    return OperateByID(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class PageInfo {
  final int page;
  final int pageSize;

  const PageInfo({
    this.page = 0,
    this.pageSize = 0,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'page': page,
      'pageSize': pageSize,
  };
}

class PageResult {
  final dynamic items;
  final int total;

  const PageResult({
    this.items,
    this.total = 0,
  });

  factory PageResult.fromJson(Map<String, dynamic> json) {
    return PageResult(
      items: json['items'],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items,
      'total': total,
  };
}

class UpdateGroup {
  final int group;
  final int newGroup;

  const UpdateGroup({
    this.group = 0,
    this.newGroup = 0,
  });

  factory UpdateGroup.fromJson(Map<String, dynamic> json) {
    return UpdateGroup(
      group: (json['group'] as num?)?.toInt() ?? 0,
      newGroup: (json['newGroup'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'group': group,
      'newGroup': newGroup,
  };
}

class FilesFileinfo {
  final String content;
  final String extension;
  final int favoriteID;
  final String gid;
  final String group;
  final bool isAppendOnly;
  final bool isDetail;
  final bool isDir;
  final bool isHidden;
  final bool isImmutable;
  final bool isSymlink;
  final int itemTotal;
  final List<FilesFileinfo> items;
  final String linkPath;
  final String mimeType;
  final String modTime;
  final String mode;
  final String name;
  final String path;
  final String shareCode;
  final int size;
  final String type;
  final String uid;
  final String updateTime;
  final String user;

  const FilesFileinfo({
    this.content = '',
    this.extension = '',
    this.favoriteID = 0,
    this.gid = '',
    this.group = '',
    this.isAppendOnly = false,
    this.isDetail = false,
    this.isDir = false,
    this.isHidden = false,
    this.isImmutable = false,
    this.isSymlink = false,
    this.itemTotal = 0,
    this.items = const [],
    this.linkPath = '',
    this.mimeType = '',
    this.modTime = '',
    this.mode = '',
    this.name = '',
    this.path = '',
    this.shareCode = '',
    this.size = 0,
    this.type = '',
    this.uid = '',
    this.updateTime = '',
    this.user = '',
  });

  factory FilesFileinfo.fromJson(Map<String, dynamic> json) {
    return FilesFileinfo(
      content: json['content'] as String? ?? '',
      extension: json['extension'] as String? ?? '',
      favoriteID: (json['favoriteID'] as num?)?.toInt() ?? 0,
      gid: json['gid'] as String? ?? '',
      group: json['group'] as String? ?? '',
      isAppendOnly: json['isAppendOnly'] as bool? ?? false,
      isDetail: json['isDetail'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      isImmutable: json['isImmutable'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      itemTotal: (json['itemTotal'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((e) => FilesFileinfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      linkPath: json['linkPath'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      modTime: json['modTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      shareCode: json['shareCode'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'extension': extension,
      'favoriteID': favoriteID,
      'gid': gid,
      'group': group,
      'isAppendOnly': isAppendOnly,
      'isDetail': isDetail,
      'isDir': isDir,
      'isHidden': isHidden,
      'isImmutable': isImmutable,
      'isSymlink': isSymlink,
      'itemTotal': itemTotal,
      'items': items.map((e) => e.toJson()).toList(),
      'linkPath': linkPath,
      'mimeType': mimeType,
      'modTime': modTime,
      'mode': mode,
      'name': name,
      'path': path,
      'shareCode': shareCode,
      'size': size,
      'type': type,
      'uid': uid,
      'updateTime': updateTime,
      'user': user,
  };
}

class Website {
  final bool iPV6;
  final bool accessLog;
  final String alias;
  final int appInstallId;
  final String createdAt;
  final int dbID;
  final String dbType;
  final bool defaultServer;
  final List<WebsiteDomain> domains;
  final bool errorLog;
  final String expireDate;
  final bool favorite;
  final int ftpId;
  final String group;
  final String httpConfig;
  final int id;
  final int parentWebsiteID;
  final String primaryDomain;
  final String protocol;
  final String proxy;
  final String proxyType;
  final String remark;
  final String rewrite;
  final int runtimeID;
  final String siteDir;
  final String status;
  final String streamPorts;
  final String type;
  final String updatedAt;
  final String user;
  final int webSiteGroupId;
  final WebsiteSSL? webSiteSSL;
  final int webSiteSSLId;

  const Website({
    this.iPV6 = false,
    this.accessLog = false,
    this.alias = '',
    this.appInstallId = 0,
    this.createdAt = '',
    this.dbID = 0,
    this.dbType = '',
    this.defaultServer = false,
    this.domains = const [],
    this.errorLog = false,
    this.expireDate = '',
    this.favorite = false,
    this.ftpId = 0,
    this.group = '',
    this.httpConfig = '',
    this.id = 0,
    this.parentWebsiteID = 0,
    this.primaryDomain = '',
    this.protocol = '',
    this.proxy = '',
    this.proxyType = '',
    this.remark = '',
    this.rewrite = '',
    this.runtimeID = 0,
    this.siteDir = '',
    this.status = '',
    this.streamPorts = '',
    this.type = '',
    this.updatedAt = '',
    this.user = '',
    this.webSiteGroupId = 0,
    this.webSiteSSL,
    this.webSiteSSLId = 0,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      iPV6: json['IPV6'] as bool? ?? false,
      accessLog: json['accessLog'] as bool? ?? false,
      alias: json['alias'] as String? ?? '',
      appInstallId: (json['appInstallId'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      dbID: (json['dbID'] as num?)?.toInt() ?? 0,
      dbType: json['dbType'] as String? ?? '',
      defaultServer: json['defaultServer'] as bool? ?? false,
      domains: (json['domains'] as List<dynamic>?)?.map((e) => WebsiteDomain.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      errorLog: json['errorLog'] as bool? ?? false,
      expireDate: json['expireDate'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
      ftpId: (json['ftpId'] as num?)?.toInt() ?? 0,
      group: json['group'] as String? ?? '',
      httpConfig: json['httpConfig'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      parentWebsiteID: (json['parentWebsiteID'] as num?)?.toInt() ?? 0,
      primaryDomain: json['primaryDomain'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      proxyType: json['proxyType'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      rewrite: json['rewrite'] as String? ?? '',
      runtimeID: (json['runtimeID'] as num?)?.toInt() ?? 0,
      siteDir: json['siteDir'] as String? ?? '',
      status: json['status'] as String? ?? '',
      streamPorts: json['streamPorts'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      user: json['user'] as String? ?? '',
      webSiteGroupId: (json['webSiteGroupId'] as num?)?.toInt() ?? 0,
      webSiteSSL: json['webSiteSSL'] != null ? WebsiteSSL.fromJson(json['webSiteSSL'] as Map<String, dynamic>) : null,
      webSiteSSLId: (json['webSiteSSLId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'IPV6': iPV6,
      'accessLog': accessLog,
      'alias': alias,
      'appInstallId': appInstallId,
      'createdAt': createdAt,
      'dbID': dbID,
      'dbType': dbType,
      'defaultServer': defaultServer,
      'domains': domains.map((e) => e.toJson()).toList(),
      'errorLog': errorLog,
      'expireDate': expireDate,
      'favorite': favorite,
      'ftpId': ftpId,
      'group': group,
      'httpConfig': httpConfig,
      'id': id,
      'parentWebsiteID': parentWebsiteID,
      'primaryDomain': primaryDomain,
      'protocol': protocol,
      'proxy': proxy,
      'proxyType': proxyType,
      'remark': remark,
      'rewrite': rewrite,
      'runtimeID': runtimeID,
      'siteDir': siteDir,
      'status': status,
      'streamPorts': streamPorts,
      'type': type,
      'updatedAt': updatedAt,
      'user': user,
      'webSiteGroupId': webSiteGroupId,
      if (webSiteSSL != null) 'webSiteSSL': webSiteSSL!.toJson(),
      'webSiteSSLId': webSiteSSLId,
  };
}

class WebsiteAcmeAccount {
  final String caDirURL;
  final String createdAt;
  final String eabHmacKey;
  final String eabKid;
  final String email;
  final int id;
  final String keyType;
  final String type;
  final String updatedAt;
  final String url;
  final bool useEAB;
  final bool useProxy;

  const WebsiteAcmeAccount({
    this.caDirURL = '',
    this.createdAt = '',
    this.eabHmacKey = '',
    this.eabKid = '',
    this.email = '',
    this.id = 0,
    this.keyType = '',
    this.type = '',
    this.updatedAt = '',
    this.url = '',
    this.useEAB = false,
    this.useProxy = false,
  });

  factory WebsiteAcmeAccount.fromJson(Map<String, dynamic> json) {
    return WebsiteAcmeAccount(
      caDirURL: json['caDirURL'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      eabHmacKey: json['eabHmacKey'] as String? ?? '',
      eabKid: json['eabKid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      keyType: json['keyType'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      url: json['url'] as String? ?? '',
      useEAB: json['useEAB'] as bool? ?? false,
      useProxy: json['useProxy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'caDirURL': caDirURL,
      'createdAt': createdAt,
      'eabHmacKey': eabHmacKey,
      'eabKid': eabKid,
      'email': email,
      'id': id,
      'keyType': keyType,
      'type': type,
      'updatedAt': updatedAt,
      'url': url,
      'useEAB': useEAB,
      'useProxy': useProxy,
  };
}

class WebsiteDnsAccount {
  final String createdAt;
  final int id;
  final String name;
  final String type;
  final String updatedAt;

  const WebsiteDnsAccount({
    this.createdAt = '',
    this.id = 0,
    this.name = '',
    this.type = '',
    this.updatedAt = '',
  });

  factory WebsiteDnsAccount.fromJson(Map<String, dynamic> json) {
    return WebsiteDnsAccount(
      createdAt: json['createdAt'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'id': id,
      'name': name,
      'type': type,
      'updatedAt': updatedAt,
  };
}

class WebsiteDomain {
  final String createdAt;
  final String domain;
  final int id;
  final int port;
  final bool ssl;
  final String updatedAt;
  final int websiteId;

  const WebsiteDomain({
    this.createdAt = '',
    this.domain = '',
    this.id = 0,
    this.port = 0,
    this.ssl = false,
    this.updatedAt = '',
    this.websiteId = 0,
  });

  factory WebsiteDomain.fromJson(Map<String, dynamic> json) {
    return WebsiteDomain(
      createdAt: json['createdAt'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      port: (json['port'] as num?)?.toInt() ?? 0,
      ssl: json['ssl'] as bool? ?? false,
      updatedAt: json['updatedAt'] as String? ?? '',
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'domain': domain,
      'id': id,
      'port': port,
      'ssl': ssl,
      'updatedAt': updatedAt,
      'websiteId': websiteId,
  };
}

class WebsiteSSL {
  final WebsiteAcmeAccount? acmeAccount;
  final int acmeAccountId;
  final bool autoRenew;
  final int caId;
  final String certPath;
  final String certURL;
  final String createdAt;
  final String description;
  final String dir;
  final bool disableCNAME;
  final WebsiteDnsAccount? dnsAccount;
  final int dnsAccountId;
  final String domains;
  final bool execShell;
  final String expireDate;
  final int id;
  final bool isIP;
  final String keyType;
  final int masterSslId;
  final String message;
  final String nameserver1;
  final String nameserver2;
  final String nodes;
  final String organization;
  final String pem;
  final String primaryDomain;
  final String privateKey;
  final String privateKeyPath;
  final String provider;
  final bool pushDir;
  final bool pushNode;
  final String shell;
  final bool skipDNS;
  final String startDate;
  final String status;
  final String type;
  final String updatedAt;
  final List<Website> websites;

  const WebsiteSSL({
    this.acmeAccount,
    this.acmeAccountId = 0,
    this.autoRenew = false,
    this.caId = 0,
    this.certPath = '',
    this.certURL = '',
    this.createdAt = '',
    this.description = '',
    this.dir = '',
    this.disableCNAME = false,
    this.dnsAccount,
    this.dnsAccountId = 0,
    this.domains = '',
    this.execShell = false,
    this.expireDate = '',
    this.id = 0,
    this.isIP = false,
    this.keyType = '',
    this.masterSslId = 0,
    this.message = '',
    this.nameserver1 = '',
    this.nameserver2 = '',
    this.nodes = '',
    this.organization = '',
    this.pem = '',
    this.primaryDomain = '',
    this.privateKey = '',
    this.privateKeyPath = '',
    this.provider = '',
    this.pushDir = false,
    this.pushNode = false,
    this.shell = '',
    this.skipDNS = false,
    this.startDate = '',
    this.status = '',
    this.type = '',
    this.updatedAt = '',
    this.websites = const [],
  });

  factory WebsiteSSL.fromJson(Map<String, dynamic> json) {
    return WebsiteSSL(
      acmeAccount: json['acmeAccount'] != null ? WebsiteAcmeAccount.fromJson(json['acmeAccount'] as Map<String, dynamic>) : null,
      acmeAccountId: (json['acmeAccountId'] as num?)?.toInt() ?? 0,
      autoRenew: json['autoRenew'] as bool? ?? false,
      caId: (json['caId'] as num?)?.toInt() ?? 0,
      certPath: json['certPath'] as String? ?? '',
      certURL: json['certURL'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      disableCNAME: json['disableCNAME'] as bool? ?? false,
      dnsAccount: json['dnsAccount'] != null ? WebsiteDnsAccount.fromJson(json['dnsAccount'] as Map<String, dynamic>) : null,
      dnsAccountId: (json['dnsAccountId'] as num?)?.toInt() ?? 0,
      domains: json['domains'] as String? ?? '',
      execShell: json['execShell'] as bool? ?? false,
      expireDate: json['expireDate'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isIP: json['isIP'] as bool? ?? false,
      keyType: json['keyType'] as String? ?? '',
      masterSslId: (json['masterSslId'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      nameserver1: json['nameserver1'] as String? ?? '',
      nameserver2: json['nameserver2'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      pem: json['pem'] as String? ?? '',
      primaryDomain: json['primaryDomain'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      privateKeyPath: json['privateKeyPath'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      pushDir: json['pushDir'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      shell: json['shell'] as String? ?? '',
      skipDNS: json['skipDNS'] as bool? ?? false,
      startDate: json['startDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      websites: (json['websites'] as List<dynamic>?)?.map((e) => Website.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (acmeAccount != null) 'acmeAccount': acmeAccount!.toJson(),
      'acmeAccountId': acmeAccountId,
      'autoRenew': autoRenew,
      'caId': caId,
      'certPath': certPath,
      'certURL': certURL,
      'createdAt': createdAt,
      'description': description,
      'dir': dir,
      'disableCNAME': disableCNAME,
      if (dnsAccount != null) 'dnsAccount': dnsAccount!.toJson(),
      'dnsAccountId': dnsAccountId,
      'domains': domains,
      'execShell': execShell,
      'expireDate': expireDate,
      'id': id,
      'isIP': isIP,
      'keyType': keyType,
      'masterSslId': masterSslId,
      'message': message,
      'nameserver1': nameserver1,
      'nameserver2': nameserver2,
      'nodes': nodes,
      'organization': organization,
      'pem': pem,
      'primaryDomain': primaryDomain,
      'privateKey': privateKey,
      'privateKeyPath': privateKeyPath,
      'provider': provider,
      'pushDir': pushDir,
      'pushNode': pushNode,
      'shell': shell,
      'skipDNS': skipDNS,
      'startDate': startDate,
      'status': status,
      'type': type,
      'updatedAt': updatedAt,
      'websites': websites.map((e) => e.toJson()).toList(),
  };
}

class BatchWebsiteGroup {
  final int groupID;
  final List<int> ids;

  const BatchWebsiteGroup({
    this.groupID = 0,
    this.ids = const [],
  });

  factory BatchWebsiteGroup.fromJson(Map<String, dynamic> json) {
    return BatchWebsiteGroup(
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'groupID': groupID,
      'ids': ids,
  };
}

class BatchWebsiteHttps {
  final List<String> sSLProtocol;
  final String algorithm;
  final String certificate;
  final String certificatePath;
  final bool hsts;
  final bool hstsIncludeSubDomains;
  final bool http3;
  final String httpConfig;
  final List<int> httpsPorts;
  final List<int> ids;
  final String importType;
  final String privateKey;
  final String privateKeyPath;
  final String taskID;
  final String type;
  final int websiteSSLId;

  const BatchWebsiteHttps({
    this.sSLProtocol = const [],
    this.algorithm = '',
    this.certificate = '',
    this.certificatePath = '',
    this.hsts = false,
    this.hstsIncludeSubDomains = false,
    this.http3 = false,
    this.httpConfig = '',
    this.httpsPorts = const [],
    this.ids = const [],
    this.importType = '',
    this.privateKey = '',
    this.privateKeyPath = '',
    this.taskID = '',
    this.type = '',
    this.websiteSSLId = 0,
  });

  factory BatchWebsiteHttps.fromJson(Map<String, dynamic> json) {
    return BatchWebsiteHttps(
      sSLProtocol: (json['SSLProtocol'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      algorithm: json['algorithm'] as String? ?? '',
      certificate: json['certificate'] as String? ?? '',
      certificatePath: json['certificatePath'] as String? ?? '',
      hsts: json['hsts'] as bool? ?? false,
      hstsIncludeSubDomains: json['hstsIncludeSubDomains'] as bool? ?? false,
      http3: json['http3'] as bool? ?? false,
      httpConfig: json['httpConfig'] as String? ?? '',
      httpsPorts: (json['httpsPorts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      importType: json['importType'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      privateKeyPath: json['privateKeyPath'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      websiteSSLId: (json['websiteSSLId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'SSLProtocol': sSLProtocol,
      'algorithm': algorithm,
      'certificate': certificate,
      'certificatePath': certificatePath,
      'hsts': hsts,
      'hstsIncludeSubDomains': hstsIncludeSubDomains,
      'http3': http3,
      'httpConfig': httpConfig,
      'httpsPorts': httpsPorts,
      'ids': ids,
      'importType': importType,
      'privateKey': privateKey,
      'privateKeyPath': privateKeyPath,
      'taskID': taskID,
      'type': type,
      'websiteSSLId': websiteSSLId,
  };
}

class BatchWebsiteOp {
  final List<int> ids;
  final String operate;
  final String taskID;

  const BatchWebsiteOp({
    this.ids = const [],
    this.operate = '',
    this.taskID = '',
  });

  factory BatchWebsiteOp.fromJson(Map<String, dynamic> json) {
    return BatchWebsiteOp(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      operate: json['operate'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
      'operate': operate,
      'taskID': taskID,
  };
}

class ChangeDatabase {
  final int databaseID;
  final String databaseType;
  final int websiteID;

  const ChangeDatabase({
    this.databaseID = 0,
    this.databaseType = '',
    this.websiteID = 0,
  });

  factory ChangeDatabase.fromJson(Map<String, dynamic> json) {
    return ChangeDatabase(
      databaseID: (json['databaseID'] as num?)?.toInt() ?? 0,
      databaseType: json['databaseType'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'databaseID': databaseID,
      'databaseType': databaseType,
      'websiteID': websiteID,
  };
}

class CorsConfig {
  final bool allowCredentials;
  final String allowHeaders;
  final String allowMethods;
  final String allowOrigins;
  final bool cors;
  final bool preflight;

  const CorsConfig({
    this.allowCredentials = false,
    this.allowHeaders = '',
    this.allowMethods = '',
    this.allowOrigins = '',
    this.cors = false,
    this.preflight = false,
  });

  factory CorsConfig.fromJson(Map<String, dynamic> json) {
    return CorsConfig(
      allowCredentials: json['allowCredentials'] as bool? ?? false,
      allowHeaders: json['allowHeaders'] as String? ?? '',
      allowMethods: json['allowMethods'] as String? ?? '',
      allowOrigins: json['allowOrigins'] as String? ?? '',
      cors: json['cors'] as bool? ?? false,
      preflight: json['preflight'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'allowCredentials': allowCredentials,
      'allowHeaders': allowHeaders,
      'allowMethods': allowMethods,
      'allowOrigins': allowOrigins,
      'cors': cors,
      'preflight': preflight,
  };
}

class CorsConfigReq {
  final bool allowCredentials;
  final String allowHeaders;
  final String allowMethods;
  final String allowOrigins;
  final bool cors;
  final bool preflight;
  final int websiteID;

  const CorsConfigReq({
    this.allowCredentials = false,
    this.allowHeaders = '',
    this.allowMethods = '',
    this.allowOrigins = '',
    this.cors = false,
    this.preflight = false,
    this.websiteID = 0,
  });

  factory CorsConfigReq.fromJson(Map<String, dynamic> json) {
    return CorsConfigReq(
      allowCredentials: json['allowCredentials'] as bool? ?? false,
      allowHeaders: json['allowHeaders'] as String? ?? '',
      allowMethods: json['allowMethods'] as String? ?? '',
      allowOrigins: json['allowOrigins'] as String? ?? '',
      cors: json['cors'] as bool? ?? false,
      preflight: json['preflight'] as bool? ?? false,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'allowCredentials': allowCredentials,
      'allowHeaders': allowHeaders,
      'allowMethods': allowMethods,
      'allowOrigins': allowOrigins,
      'cors': cors,
      'preflight': preflight,
      'websiteID': websiteID,
  };
}

class CrossSiteAccessOp {
  final String operation;
  final int websiteID;

  const CrossSiteAccessOp({
    this.operation = '',
    this.websiteID = 0,
  });

  factory CrossSiteAccessOp.fromJson(Map<String, dynamic> json) {
    return CrossSiteAccessOp(
      operation: json['operation'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
      'websiteID': websiteID,
  };
}

class CustomRewriteOperate {
  final String content;
  final String name;
  final String operate;

  const CustomRewriteOperate({
    this.content = '',
    this.name = '',
    this.operate = '',
  });

  factory CustomRewriteOperate.fromJson(Map<String, dynamic> json) {
    return CustomRewriteOperate(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
      'operate': operate,
  };
}

class ExecComposerReq {
  final String command;
  final String dir;
  final String extCommand;
  final String mirror;
  final String taskID;
  final String user;
  final int websiteID;

  const ExecComposerReq({
    this.command = '',
    this.dir = '',
    this.extCommand = '',
    this.mirror = '',
    this.taskID = '',
    this.user = '',
    this.websiteID = 0,
  });

  factory ExecComposerReq.fromJson(Map<String, dynamic> json) {
    return ExecComposerReq(
      command: json['command'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      extCommand: json['extCommand'] as String? ?? '',
      mirror: json['mirror'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      user: json['user'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'command': command,
      'dir': dir,
      'extCommand': extCommand,
      'mirror': mirror,
      'taskID': taskID,
      'user': user,
      'websiteID': websiteID,
  };
}

class NewAppInstall {
  final bool advanced;
  final bool allowPort;
  final int appDetailID;
  final String containerName;
  final double cpuQuota;
  final String dockerCompose;
  final bool editCompose;
  final bool gpuConfig;
  final bool hostMode;
  final double memoryLimit;
  final String memoryUnit;
  final String name;
  final Map<String, dynamic> params;
  final bool pullImage;
  final String restartPolicy;
  final String specifyIP;
  final String type;
  final String webUI;

  const NewAppInstall({
    this.advanced = false,
    this.allowPort = false,
    this.appDetailID = 0,
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dockerCompose = '',
    this.editCompose = false,
    this.gpuConfig = false,
    this.hostMode = false,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.name = '',
    this.params = const {},
    this.pullImage = false,
    this.restartPolicy = '',
    this.specifyIP = '',
    this.type = '',
    this.webUI = '',
  });

  factory NewAppInstall.fromJson(Map<String, dynamic> json) {
    return NewAppInstall(
      advanced: json['advanced'] as bool? ?? false,
      allowPort: json['allowPort'] as bool? ?? false,
      appDetailID: (json['appDetailID'] as num?)?.toInt() ?? 0,
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      gpuConfig: json['gpuConfig'] as bool? ?? false,
      hostMode: json['hostMode'] as bool? ?? false,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      name: json['name'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      pullImage: json['pullImage'] as bool? ?? false,
      restartPolicy: json['restartPolicy'] as String? ?? '',
      specifyIP: json['specifyIP'] as String? ?? '',
      type: json['type'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advanced': advanced,
      'allowPort': allowPort,
      'appDetailID': appDetailID,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'gpuConfig': gpuConfig,
      'hostMode': hostMode,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'name': name,
      'params': params,
      'pullImage': pullImage,
      'restartPolicy': restartPolicy,
      'specifyIP': specifyIP,
      'type': type,
      'webUI': webUI,
  };
}

class NginxAntiLeechUpdate {
  final bool blocked;
  final bool cache;
  final int cacheTime;
  final String cacheUint;
  final bool enable;
  final String $extends;
  final bool logEnable;
  final bool noneRef;
  final String $return;
  final List<String> serverNames;
  final int websiteID;

  const NginxAntiLeechUpdate({
    this.blocked = false,
    this.cache = false,
    this.cacheTime = 0,
    this.cacheUint = '',
    this.enable = false,
    this.$extends = '',
    this.logEnable = false,
    this.noneRef = false,
    this.$return = '',
    this.serverNames = const [],
    this.websiteID = 0,
  });

  factory NginxAntiLeechUpdate.fromJson(Map<String, dynamic> json) {
    return NginxAntiLeechUpdate(
      blocked: json['blocked'] as bool? ?? false,
      cache: json['cache'] as bool? ?? false,
      cacheTime: (json['cacheTime'] as num?)?.toInt() ?? 0,
      cacheUint: json['cacheUint'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      $extends: json['extends'] as String? ?? '',
      logEnable: json['logEnable'] as bool? ?? false,
      noneRef: json['noneRef'] as bool? ?? false,
      $return: json['return'] as String? ?? '',
      serverNames: (json['serverNames'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'blocked': blocked,
      'cache': cache,
      'cacheTime': cacheTime,
      'cacheUint': cacheUint,
      'enable': enable,
      'extends': $extends,
      'logEnable': logEnable,
      'noneRef': noneRef,
      'return': $return,
      'serverNames': serverNames,
      'websiteID': websiteID,
  };
}

class NginxAuthReq {
  final int websiteID;

  const NginxAuthReq({
    this.websiteID = 0,
  });

  factory NginxAuthReq.fromJson(Map<String, dynamic> json) {
    return NginxAuthReq(
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'websiteID': websiteID,
  };
}

class NginxAuthUpdate {
  final String operate;
  final String password;
  final String remark;
  final String username;
  final int websiteID;

  const NginxAuthUpdate({
    this.operate = '',
    this.password = '',
    this.remark = '',
    this.username = '',
    this.websiteID = 0,
  });

  factory NginxAuthUpdate.fromJson(Map<String, dynamic> json) {
    return NginxAuthUpdate(
      operate: json['operate'] as String? ?? '',
      password: json['password'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      username: json['username'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'operate': operate,
      'password': password,
      'remark': remark,
      'username': username,
      'websiteID': websiteID,
  };
}

class NginxBuildReq {
  final bool force;
  final String mirror;
  final List<String> modules;
  final String taskID;

  const NginxBuildReq({
    this.force = false,
    this.mirror = '',
    this.modules = const [],
    this.taskID = '',
  });

  factory NginxBuildReq.fromJson(Map<String, dynamic> json) {
    return NginxBuildReq(
      force: json['force'] as bool? ?? false,
      mirror: json['mirror'] as String? ?? '',
      modules: (json['modules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'force': force,
      'mirror': mirror,
      'modules': modules,
      'taskID': taskID,
  };
}

class NginxCommonReq {
  final int websiteID;

  const NginxCommonReq({
    this.websiteID = 0,
  });

  factory NginxCommonReq.fromJson(Map<String, dynamic> json) {
    return NginxCommonReq(
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'websiteID': websiteID,
  };
}

class NginxConfigFileUpdate {
  final bool backup;
  final String content;

  const NginxConfigFileUpdate({
    this.backup = false,
    this.content = '',
  });

  factory NginxConfigFileUpdate.fromJson(Map<String, dynamic> json) {
    return NginxConfigFileUpdate(
      backup: json['backup'] as bool? ?? false,
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backup': backup,
      'content': content,
  };
}

class NginxConfigUpdate {
  final String operate;
  final dynamic params;
  final NginxKey? scope;
  final int websiteId;

  const NginxConfigUpdate({
    this.operate = '',
    this.params,
    this.scope,
    this.websiteId = 0,
  });

  factory NginxConfigUpdate.fromJson(Map<String, dynamic> json) {
    return NginxConfigUpdate(
      operate: json['operate'] as String? ?? '',
      params: json['params'],
      scope: json['scope'] != null ? NginxKey.fromJson(json['scope'] as Map<String, dynamic>) : null,
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'operate': operate,
      'params': params,
      if (scope != null) 'scope': scope!.toJson(),
      'websiteId': websiteId,
  };
}

class NginxDefaultHTTPSUpdate {
  final String operate;
  final bool sslRejectHandshake;

  const NginxDefaultHTTPSUpdate({
    this.operate = '',
    this.sslRejectHandshake = false,
  });

  factory NginxDefaultHTTPSUpdate.fromJson(Map<String, dynamic> json) {
    return NginxDefaultHTTPSUpdate(
      operate: json['operate'] as String? ?? '',
      sslRejectHandshake: json['sslRejectHandshake'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'operate': operate,
      'sslRejectHandshake': sslRejectHandshake,
  };
}

class NginxModuleUpdate {
  final String buildMode;
  final bool enable;
  final int loadOrder;
  final String name;
  final String operate;
  final String packages;
  final String params;
  final String provider;
  final String script;

  const NginxModuleUpdate({
    this.buildMode = '',
    this.enable = false,
    this.loadOrder = 0,
    this.name = '',
    this.operate = '',
    this.packages = '',
    this.params = '',
    this.provider = '',
    this.script = '',
  });

  factory NginxModuleUpdate.fromJson(Map<String, dynamic> json) {
    return NginxModuleUpdate(
      buildMode: json['buildMode'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      loadOrder: (json['loadOrder'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      packages: json['packages'] as String? ?? '',
      params: json['params'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      script: json['script'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'buildMode': buildMode,
      'enable': enable,
      'loadOrder': loadOrder,
      'name': name,
      'operate': operate,
      'packages': packages,
      'params': params,
      'provider': provider,
      'script': script,
  };
}

class NginxPathAuthUpdate {
  final String name;
  final String operate;
  final String password;
  final String path;
  final String remark;
  final String username;
  final int websiteID;

  const NginxPathAuthUpdate({
    this.name = '',
    this.operate = '',
    this.password = '',
    this.path = '',
    this.remark = '',
    this.username = '',
    this.websiteID = 0,
  });

  factory NginxPathAuthUpdate.fromJson(Map<String, dynamic> json) {
    return NginxPathAuthUpdate(
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      password: json['password'] as String? ?? '',
      path: json['path'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      username: json['username'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'operate': operate,
      'password': password,
      'path': path,
      'remark': remark,
      'username': username,
      'websiteID': websiteID,
  };
}

class NginxProxyCacheUpdate {
  final int cacheExpire;
  final String cacheExpireUnit;
  final int cacheLimit;
  final String cacheLimitUnit;
  final bool open;
  final int shareCache;
  final String shareCacheUnit;
  final int websiteID;

  const NginxProxyCacheUpdate({
    this.cacheExpire = 0,
    this.cacheExpireUnit = '',
    this.cacheLimit = 0,
    this.cacheLimitUnit = '',
    this.open = false,
    this.shareCache = 0,
    this.shareCacheUnit = '',
    this.websiteID = 0,
  });

  factory NginxProxyCacheUpdate.fromJson(Map<String, dynamic> json) {
    return NginxProxyCacheUpdate(
      cacheExpire: (json['cacheExpire'] as num?)?.toInt() ?? 0,
      cacheExpireUnit: json['cacheExpireUnit'] as String? ?? '',
      cacheLimit: (json['cacheLimit'] as num?)?.toInt() ?? 0,
      cacheLimitUnit: json['cacheLimitUnit'] as String? ?? '',
      open: json['open'] as bool? ?? false,
      shareCache: (json['shareCache'] as num?)?.toInt() ?? 0,
      shareCacheUnit: json['shareCacheUnit'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'cacheExpire': cacheExpire,
      'cacheExpireUnit': cacheExpireUnit,
      'cacheLimit': cacheLimit,
      'cacheLimitUnit': cacheLimitUnit,
      'open': open,
      'shareCache': shareCache,
      'shareCacheUnit': shareCacheUnit,
      'websiteID': websiteID,
  };
}

class NginxProxyUpdate {
  final String content;
  final String name;
  final int websiteID;

  const NginxProxyUpdate({
    this.content = '',
    this.name = '',
    this.websiteID = 0,
  });

  factory NginxProxyUpdate.fromJson(Map<String, dynamic> json) {
    return NginxProxyUpdate(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
      'websiteID': websiteID,
  };
}

class NginxRedirectReq {
  final List<String> domains;
  final bool enable;
  final bool keepPath;
  final String name;
  final String operate;
  final String path;
  final String redirect;
  final bool redirectRoot;
  final String target;
  final String type;
  final int websiteID;

  const NginxRedirectReq({
    this.domains = const [],
    this.enable = false,
    this.keepPath = false,
    this.name = '',
    this.operate = '',
    this.path = '',
    this.redirect = '',
    this.redirectRoot = false,
    this.target = '',
    this.type = '',
    this.websiteID = 0,
  });

  factory NginxRedirectReq.fromJson(Map<String, dynamic> json) {
    return NginxRedirectReq(
      domains: (json['domains'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      enable: json['enable'] as bool? ?? false,
      keepPath: json['keepPath'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      path: json['path'] as String? ?? '',
      redirect: json['redirect'] as String? ?? '',
      redirectRoot: json['redirectRoot'] as bool? ?? false,
      target: json['target'] as String? ?? '',
      type: json['type'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'domains': domains,
      'enable': enable,
      'keepPath': keepPath,
      'name': name,
      'operate': operate,
      'path': path,
      'redirect': redirect,
      'redirectRoot': redirectRoot,
      'target': target,
      'type': type,
      'websiteID': websiteID,
  };
}

class NginxRedirectUpdate {
  final String content;
  final String name;
  final int websiteID;

  const NginxRedirectUpdate({
    this.content = '',
    this.name = '',
    this.websiteID = 0,
  });

  factory NginxRedirectUpdate.fromJson(Map<String, dynamic> json) {
    return NginxRedirectUpdate(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
      'websiteID': websiteID,
  };
}

class NginxRewriteReq {
  final String name;
  final int websiteId;

  const NginxRewriteReq({
    this.name = '',
    this.websiteId = 0,
  });

  factory NginxRewriteReq.fromJson(Map<String, dynamic> json) {
    return NginxRewriteReq(
      name: json['name'] as String? ?? '',
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'websiteId': websiteId,
  };
}

class NginxRewriteUpdate {
  final String content;
  final String name;
  final int websiteId;

  const NginxRewriteUpdate({
    this.content = '',
    this.name = '',
    this.websiteId = 0,
  });

  factory NginxRewriteUpdate.fromJson(Map<String, dynamic> json) {
    return NginxRewriteUpdate(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
      'websiteId': websiteId,
  };
}

class NginxScopeReq {
  final NginxKey? scope;
  final int websiteId;

  const NginxScopeReq({
    this.scope,
    this.websiteId = 0,
  });

  factory NginxScopeReq.fromJson(Map<String, dynamic> json) {
    return NginxScopeReq(
      scope: json['scope'] != null ? NginxKey.fromJson(json['scope'] as Map<String, dynamic>) : null,
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      if (scope != null) 'scope': scope!.toJson(),
      'websiteId': websiteId,
  };
}

class PHPExtensionsCreate {
  final String extensions;
  final String name;

  const PHPExtensionsCreate({
    this.extensions = '',
    this.name = '',
  });

  factory PHPExtensionsCreate.fromJson(Map<String, dynamic> json) {
    return PHPExtensionsCreate(
      extensions: json['extensions'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'extensions': extensions,
      'name': name,
  };
}

class PHPExtensionsDelete {
  final int id;

  const PHPExtensionsDelete({
    this.id = 0,
  });

  factory PHPExtensionsDelete.fromJson(Map<String, dynamic> json) {
    return PHPExtensionsDelete(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class PHPExtensionsSearch {
  final bool all;
  final int page;
  final int pageSize;

  const PHPExtensionsSearch({
    this.all = false,
    this.page = 0,
    this.pageSize = 0,
  });

  factory PHPExtensionsSearch.fromJson(Map<String, dynamic> json) {
    return PHPExtensionsSearch(
      all: json['all'] as bool? ?? false,
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'all': all,
      'page': page,
      'pageSize': pageSize,
  };
}

class PHPExtensionsUpdate {
  final String extensions;
  final int id;

  const PHPExtensionsUpdate({
    this.extensions = '',
    this.id = 0,
  });

  factory PHPExtensionsUpdate.fromJson(Map<String, dynamic> json) {
    return PHPExtensionsUpdate(
      extensions: json['extensions'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'extensions': extensions,
      'id': id,
  };
}

class RuntimeDelete {
  final bool deleteImage;
  final bool forceDelete;
  final int id;
  final String taskID;

  const RuntimeDelete({
    this.deleteImage = false,
    this.forceDelete = false,
    this.id = 0,
    this.taskID = '',
  });

  factory RuntimeDelete.fromJson(Map<String, dynamic> json) {
    return RuntimeDelete(
      deleteImage: json['deleteImage'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'deleteImage': deleteImage,
      'forceDelete': forceDelete,
      'id': id,
      'taskID': taskID,
  };
}

class StreamUpdate {
  final String algorithm;
  final String name;
  final List<NginxUpstreamServer> servers;
  final String streamPorts;
  final bool udp;
  final int websiteID;

  const StreamUpdate({
    this.algorithm = '',
    this.name = '',
    this.servers = const [],
    this.streamPorts = '',
    this.udp = false,
    this.websiteID = 0,
  });

  factory StreamUpdate.fromJson(Map<String, dynamic> json) {
    return StreamUpdate(
      algorithm: json['algorithm'] as String? ?? '',
      name: json['name'] as String? ?? '',
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      streamPorts: json['streamPorts'] as String? ?? '',
      udp: json['udp'] as bool? ?? false,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'algorithm': algorithm,
      'name': name,
      'servers': servers.map((e) => e.toJson()).toList(),
      'streamPorts': streamPorts,
      'udp': udp,
      'websiteID': websiteID,
  };
}

class WebsiteAcmeAccountCreate {
  final String caDirURL;
  final String eabHmacKey;
  final String eabKid;
  final String email;
  final String keyType;
  final String type;
  final bool useEAB;
  final bool useProxy;

  const WebsiteAcmeAccountCreate({
    this.caDirURL = '',
    this.eabHmacKey = '',
    this.eabKid = '',
    this.email = '',
    this.keyType = '',
    this.type = '',
    this.useEAB = false,
    this.useProxy = false,
  });

  factory WebsiteAcmeAccountCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteAcmeAccountCreate(
      caDirURL: json['caDirURL'] as String? ?? '',
      eabHmacKey: json['eabHmacKey'] as String? ?? '',
      eabKid: json['eabKid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      keyType: json['keyType'] as String? ?? '',
      type: json['type'] as String? ?? '',
      useEAB: json['useEAB'] as bool? ?? false,
      useProxy: json['useProxy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'caDirURL': caDirURL,
      'eabHmacKey': eabHmacKey,
      'eabKid': eabKid,
      'email': email,
      'keyType': keyType,
      'type': type,
      'useEAB': useEAB,
      'useProxy': useProxy,
  };
}

class WebsiteAcmeAccountUpdate {
  final int id;
  final bool useProxy;

  const WebsiteAcmeAccountUpdate({
    this.id = 0,
    this.useProxy = false,
  });

  factory WebsiteAcmeAccountUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteAcmeAccountUpdate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      useProxy: json['useProxy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'useProxy': useProxy,
  };
}

class WebsiteBatchDelReq {
  final List<int> ids;

  const WebsiteBatchDelReq({
    this.ids = const [],
  });

  factory WebsiteBatchDelReq.fromJson(Map<String, dynamic> json) {
    return WebsiteBatchDelReq(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class WebsiteCACreate {
  final String city;
  final String commonName;
  final String country;
  final String keyType;
  final String name;
  final String organization;
  final String organizationUint;
  final String province;

  const WebsiteCACreate({
    this.city = '',
    this.commonName = '',
    this.country = '',
    this.keyType = '',
    this.name = '',
    this.organization = '',
    this.organizationUint = '',
    this.province = '',
  });

  factory WebsiteCACreate.fromJson(Map<String, dynamic> json) {
    return WebsiteCACreate(
      city: json['city'] as String? ?? '',
      commonName: json['commonName'] as String? ?? '',
      country: json['country'] as String? ?? '',
      keyType: json['keyType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      organizationUint: json['organizationUint'] as String? ?? '',
      province: json['province'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'city': city,
      'commonName': commonName,
      'country': country,
      'keyType': keyType,
      'name': name,
      'organization': organization,
      'organizationUint': organizationUint,
      'province': province,
  };
}

class WebsiteCAObtain {
  final bool autoRenew;
  final String description;
  final String dir;
  final String domains;
  final bool execShell;
  final int id;
  final String keyType;
  final String nodes;
  final bool pushDir;
  final bool pushNode;
  final bool renew;
  final String shell;
  final int sslID;
  final int time;
  final String unit;

  const WebsiteCAObtain({
    this.autoRenew = false,
    this.description = '',
    this.dir = '',
    this.domains = '',
    this.execShell = false,
    this.id = 0,
    this.keyType = '',
    this.nodes = '',
    this.pushDir = false,
    this.pushNode = false,
    this.renew = false,
    this.shell = '',
    this.sslID = 0,
    this.time = 0,
    this.unit = '',
  });

  factory WebsiteCAObtain.fromJson(Map<String, dynamic> json) {
    return WebsiteCAObtain(
      autoRenew: json['autoRenew'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      domains: json['domains'] as String? ?? '',
      execShell: json['execShell'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      keyType: json['keyType'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      pushDir: json['pushDir'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      renew: json['renew'] as bool? ?? false,
      shell: json['shell'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      time: (json['time'] as num?)?.toInt() ?? 0,
      unit: json['unit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoRenew': autoRenew,
      'description': description,
      'dir': dir,
      'domains': domains,
      'execShell': execShell,
      'id': id,
      'keyType': keyType,
      'nodes': nodes,
      'pushDir': pushDir,
      'pushNode': pushNode,
      'renew': renew,
      'shell': shell,
      'sslID': sslID,
      'time': time,
      'unit': unit,
  };
}

class WebsiteCASearch {
  final int page;
  final int pageSize;

  const WebsiteCASearch({
    this.page = 0,
    this.pageSize = 0,
  });

  factory WebsiteCASearch.fromJson(Map<String, dynamic> json) {
    return WebsiteCASearch(
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'page': page,
      'pageSize': pageSize,
  };
}

class WebsiteCommonReq {
  final int id;

  const WebsiteCommonReq({
    this.id = 0,
  });

  factory WebsiteCommonReq.fromJson(Map<String, dynamic> json) {
    return WebsiteCommonReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class WebsiteCreate {
  final bool iPV6;
  final String algorithm;
  final String alias;
  final int appID;
  final NewAppInstall? appInstall;
  final int appInstallID;
  final String appType;
  final bool createDb;
  final String dbFormat;
  final String dbHost;
  final String dbName;
  final String dbPassword;
  final String dbUser;
  final List<WebsiteDomain> domains;
  final bool enableSSL;
  final String ftpPassword;
  final String ftpUser;
  final String name;
  final int parentWebsiteID;
  final int port;
  final String proxy;
  final String proxyType;
  final String remark;
  final int runtimeID;
  final List<NginxUpstreamServer> servers;
  final String siteDir;
  final String streamPorts;
  final String taskID;
  final int templateOutputID;
  final String type;
  final bool udp;
  final int webSiteGroupID;
  final int websiteSSLID;

  const WebsiteCreate({
    this.iPV6 = false,
    this.algorithm = '',
    this.alias = '',
    this.appID = 0,
    this.appInstall,
    this.appInstallID = 0,
    this.appType = '',
    this.createDb = false,
    this.dbFormat = '',
    this.dbHost = '',
    this.dbName = '',
    this.dbPassword = '',
    this.dbUser = '',
    this.domains = const [],
    this.enableSSL = false,
    this.ftpPassword = '',
    this.ftpUser = '',
    this.name = '',
    this.parentWebsiteID = 0,
    this.port = 0,
    this.proxy = '',
    this.proxyType = '',
    this.remark = '',
    this.runtimeID = 0,
    this.servers = const [],
    this.siteDir = '',
    this.streamPorts = '',
    this.taskID = '',
    this.templateOutputID = 0,
    this.type = '',
    this.udp = false,
    this.webSiteGroupID = 0,
    this.websiteSSLID = 0,
  });

  factory WebsiteCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteCreate(
      iPV6: json['IPV6'] as bool? ?? false,
      algorithm: json['algorithm'] as String? ?? '',
      alias: json['alias'] as String? ?? '',
      appID: (json['appID'] as num?)?.toInt() ?? 0,
      appInstall: json['appInstall'] != null ? NewAppInstall.fromJson(json['appInstall'] as Map<String, dynamic>) : null,
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
      appType: json['appType'] as String? ?? '',
      createDb: json['createDb'] as bool? ?? false,
      dbFormat: json['dbFormat'] as String? ?? '',
      dbHost: json['dbHost'] as String? ?? '',
      dbName: json['dbName'] as String? ?? '',
      dbPassword: json['dbPassword'] as String? ?? '',
      dbUser: json['dbUser'] as String? ?? '',
      domains: (json['domains'] as List<dynamic>?)?.map((e) => WebsiteDomain.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      enableSSL: json['enableSSL'] as bool? ?? false,
      ftpPassword: json['ftpPassword'] as String? ?? '',
      ftpUser: json['ftpUser'] as String? ?? '',
      name: json['name'] as String? ?? '',
      parentWebsiteID: (json['parentWebsiteID'] as num?)?.toInt() ?? 0,
      port: (json['port'] as num?)?.toInt() ?? 0,
      proxy: json['proxy'] as String? ?? '',
      proxyType: json['proxyType'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      runtimeID: (json['runtimeID'] as num?)?.toInt() ?? 0,
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      siteDir: json['siteDir'] as String? ?? '',
      streamPorts: json['streamPorts'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      templateOutputID: (json['templateOutputID'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      udp: json['udp'] as bool? ?? false,
      webSiteGroupID: (json['webSiteGroupID'] as num?)?.toInt() ?? 0,
      websiteSSLID: (json['websiteSSLID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'IPV6': iPV6,
      'algorithm': algorithm,
      'alias': alias,
      'appID': appID,
      if (appInstall != null) 'appInstall': appInstall!.toJson(),
      'appInstallID': appInstallID,
      'appType': appType,
      'createDb': createDb,
      'dbFormat': dbFormat,
      'dbHost': dbHost,
      'dbName': dbName,
      'dbPassword': dbPassword,
      'dbUser': dbUser,
      'domains': domains.map((e) => e.toJson()).toList(),
      'enableSSL': enableSSL,
      'ftpPassword': ftpPassword,
      'ftpUser': ftpUser,
      'name': name,
      'parentWebsiteID': parentWebsiteID,
      'port': port,
      'proxy': proxy,
      'proxyType': proxyType,
      'remark': remark,
      'runtimeID': runtimeID,
      'servers': servers.map((e) => e.toJson()).toList(),
      'siteDir': siteDir,
      'streamPorts': streamPorts,
      'taskID': taskID,
      'templateOutputID': templateOutputID,
      'type': type,
      'udp': udp,
      'webSiteGroupID': webSiteGroupID,
      'websiteSSLID': websiteSSLID,
  };
}

class WebsiteDNSReq {
  final int acmeAccountId;
  final int websiteSSLId;

  const WebsiteDNSReq({
    this.acmeAccountId = 0,
    this.websiteSSLId = 0,
  });

  factory WebsiteDNSReq.fromJson(Map<String, dynamic> json) {
    return WebsiteDNSReq(
      acmeAccountId: (json['acmeAccountId'] as num?)?.toInt() ?? 0,
      websiteSSLId: (json['websiteSSLId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountId': acmeAccountId,
      'websiteSSLId': websiteSSLId,
  };
}

class WebsiteDefaultUpdate {
  final int id;

  const WebsiteDefaultUpdate({
    this.id = 0,
  });

  factory WebsiteDefaultUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteDefaultUpdate(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class WebsiteDelete {
  final bool deleteApp;
  final bool deleteBackup;
  final bool deleteDB;
  final bool forceDelete;
  final int id;

  const WebsiteDelete({
    this.deleteApp = false,
    this.deleteBackup = false,
    this.deleteDB = false,
    this.forceDelete = false,
    this.id = 0,
  });

  factory WebsiteDelete.fromJson(Map<String, dynamic> json) {
    return WebsiteDelete(
      deleteApp: json['deleteApp'] as bool? ?? false,
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      deleteDB: json['deleteDB'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'deleteApp': deleteApp,
      'deleteBackup': deleteBackup,
      'deleteDB': deleteDB,
      'forceDelete': forceDelete,
      'id': id,
  };
}

class WebsiteDnsAccountCreate {
  final Map<String, dynamic> authorization;
  final String name;
  final String type;

  const WebsiteDnsAccountCreate({
    this.authorization = const {},
    this.name = '',
    this.type = '',
  });

  factory WebsiteDnsAccountCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteDnsAccountCreate(
      authorization: json['authorization'] as Map<String, dynamic>? ?? const {},
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'authorization': authorization,
      'name': name,
      'type': type,
  };
}

class WebsiteDnsAccountUpdate {
  final Map<String, dynamic> authorization;
  final int id;
  final String name;
  final String type;

  const WebsiteDnsAccountUpdate({
    this.authorization = const {},
    this.id = 0,
    this.name = '',
    this.type = '',
  });

  factory WebsiteDnsAccountUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteDnsAccountUpdate(
      authorization: json['authorization'] as Map<String, dynamic>? ?? const {},
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'authorization': authorization,
      'id': id,
      'name': name,
      'type': type,
  };
}

class WebsiteDomainCreate {
  final List<WebsiteDomain> domains;
  final int websiteID;

  const WebsiteDomainCreate({
    this.domains = const [],
    this.websiteID = 0,
  });

  factory WebsiteDomainCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteDomainCreate(
      domains: (json['domains'] as List<dynamic>?)?.map((e) => WebsiteDomain.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'domains': domains.map((e) => e.toJson()).toList(),
      'websiteID': websiteID,
  };
}

class WebsiteDomainDelete {
  final int id;

  const WebsiteDomainDelete({
    this.id = 0,
  });

  factory WebsiteDomainDelete.fromJson(Map<String, dynamic> json) {
    return WebsiteDomainDelete(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class WebsiteDomainUpdate {
  final int id;
  final bool ssl;

  const WebsiteDomainUpdate({
    this.id = 0,
    this.ssl = false,
  });

  factory WebsiteDomainUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteDomainUpdate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ssl: json['ssl'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'ssl': ssl,
  };
}

class WebsiteHTTPSOp {
  final List<String> sSLProtocol;
  final String algorithm;
  final String certificate;
  final String certificatePath;
  final bool enable;
  final bool hsts;
  final bool hstsIncludeSubDomains;
  final bool http3;
  final String httpConfig;
  final List<int> httpsPorts;
  final String importType;
  final String privateKey;
  final String privateKeyPath;
  final String type;
  final int websiteId;
  final int websiteSSLId;

  const WebsiteHTTPSOp({
    this.sSLProtocol = const [],
    this.algorithm = '',
    this.certificate = '',
    this.certificatePath = '',
    this.enable = false,
    this.hsts = false,
    this.hstsIncludeSubDomains = false,
    this.http3 = false,
    this.httpConfig = '',
    this.httpsPorts = const [],
    this.importType = '',
    this.privateKey = '',
    this.privateKeyPath = '',
    this.type = '',
    this.websiteId = 0,
    this.websiteSSLId = 0,
  });

  factory WebsiteHTTPSOp.fromJson(Map<String, dynamic> json) {
    return WebsiteHTTPSOp(
      sSLProtocol: (json['SSLProtocol'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      algorithm: json['algorithm'] as String? ?? '',
      certificate: json['certificate'] as String? ?? '',
      certificatePath: json['certificatePath'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      hsts: json['hsts'] as bool? ?? false,
      hstsIncludeSubDomains: json['hstsIncludeSubDomains'] as bool? ?? false,
      http3: json['http3'] as bool? ?? false,
      httpConfig: json['httpConfig'] as String? ?? '',
      httpsPorts: (json['httpsPorts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      importType: json['importType'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      privateKeyPath: json['privateKeyPath'] as String? ?? '',
      type: json['type'] as String? ?? '',
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
      websiteSSLId: (json['websiteSSLId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'SSLProtocol': sSLProtocol,
      'algorithm': algorithm,
      'certificate': certificate,
      'certificatePath': certificatePath,
      'enable': enable,
      'hsts': hsts,
      'hstsIncludeSubDomains': hstsIncludeSubDomains,
      'http3': http3,
      'httpConfig': httpConfig,
      'httpsPorts': httpsPorts,
      'importType': importType,
      'privateKey': privateKey,
      'privateKeyPath': privateKeyPath,
      'type': type,
      'websiteId': websiteId,
      'websiteSSLId': websiteSSLId,
  };
}

class WebsiteHtmlUpdate {
  final String content;
  final bool $sync;
  final String type;

  const WebsiteHtmlUpdate({
    this.content = '',
    this.$sync = false,
    this.type = '',
  });

  factory WebsiteHtmlUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteHtmlUpdate(
      content: json['content'] as String? ?? '',
      $sync: json['sync'] as bool? ?? false,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'sync': $sync,
      'type': type,
  };
}

class WebsiteInstallCheckReq {
  final List<int> installIds;

  const WebsiteInstallCheckReq({
    this.installIds = const [],
  });

  factory WebsiteInstallCheckReq.fromJson(Map<String, dynamic> json) {
    return WebsiteInstallCheckReq(
      installIds: (json['InstallIds'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'InstallIds': installIds,
  };
}

class WebsiteLBCreate {
  final String algorithm;
  final String name;
  final List<NginxUpstreamServer> servers;
  final int websiteID;

  const WebsiteLBCreate({
    this.algorithm = '',
    this.name = '',
    this.servers = const [],
    this.websiteID = 0,
  });

  factory WebsiteLBCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteLBCreate(
      algorithm: json['algorithm'] as String? ?? '',
      name: json['name'] as String? ?? '',
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'algorithm': algorithm,
      'name': name,
      'servers': servers.map((e) => e.toJson()).toList(),
      'websiteID': websiteID,
  };
}

class WebsiteLBDelete {
  final String name;
  final int websiteID;

  const WebsiteLBDelete({
    this.name = '',
    this.websiteID = 0,
  });

  factory WebsiteLBDelete.fromJson(Map<String, dynamic> json) {
    return WebsiteLBDelete(
      name: json['name'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'websiteID': websiteID,
  };
}

class WebsiteLBUpdate {
  final String algorithm;
  final String name;
  final List<NginxUpstreamServer> servers;
  final int websiteID;

  const WebsiteLBUpdate({
    this.algorithm = '',
    this.name = '',
    this.servers = const [],
    this.websiteID = 0,
  });

  factory WebsiteLBUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteLBUpdate(
      algorithm: json['algorithm'] as String? ?? '',
      name: json['name'] as String? ?? '',
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'algorithm': algorithm,
      'name': name,
      'servers': servers.map((e) => e.toJson()).toList(),
      'websiteID': websiteID,
  };
}

class WebsiteLBUpdateFile {
  final String content;
  final String name;
  final int websiteID;

  const WebsiteLBUpdateFile({
    this.content = '',
    this.name = '',
    this.websiteID = 0,
  });

  factory WebsiteLBUpdateFile.fromJson(Map<String, dynamic> json) {
    return WebsiteLBUpdateFile(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
      'websiteID': websiteID,
  };
}

class WebsiteLogReq {
  final int id;
  final String logType;
  final String operate;

  const WebsiteLogReq({
    this.id = 0,
    this.logType = '',
    this.operate = '',
  });

  factory WebsiteLogReq.fromJson(Map<String, dynamic> json) {
    return WebsiteLogReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
      logType: json['logType'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'logType': logType,
      'operate': operate,
  };
}

class WebsiteLogSearchReq {
  final int id;
  final String logType;
  final int page;
  final int pageSize;

  const WebsiteLogSearchReq({
    this.id = 0,
    this.logType = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory WebsiteLogSearchReq.fromJson(Map<String, dynamic> json) {
    return WebsiteLogSearchReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
      logType: json['logType'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'logType': logType,
      'page': page,
      'pageSize': pageSize,
  };
}

class WebsiteNginxUpdate {
  final String content;
  final int id;

  const WebsiteNginxUpdate({
    this.content = '',
    this.id = 0,
  });

  factory WebsiteNginxUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteNginxUpdate(
      content: json['content'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'id': id,
  };
}

class WebsiteOp {
  final int id;
  final String operate;

  const WebsiteOp({
    this.id = 0,
    this.operate = '',
  });

  factory WebsiteOp.fromJson(Map<String, dynamic> json) {
    return WebsiteOp(
      id: (json['id'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'operate': operate,
  };
}

class WebsitePHPVersionReq {
  final int runtimeID;
  final int websiteID;

  const WebsitePHPVersionReq({
    this.runtimeID = 0,
    this.websiteID = 0,
  });

  factory WebsitePHPVersionReq.fromJson(Map<String, dynamic> json) {
    return WebsitePHPVersionReq(
      runtimeID: (json['runtimeID'] as num?)?.toInt() ?? 0,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'runtimeID': runtimeID,
      'websiteID': websiteID,
  };
}

class WebsitePreviewReq {
  final int templateID;
  final Map<String, dynamic> variableValues;

  const WebsitePreviewReq({
    this.templateID = 0,
    this.variableValues = const {},
  });

  factory WebsitePreviewReq.fromJson(Map<String, dynamic> json) {
    return WebsitePreviewReq(
      templateID: (json['templateID'] as num?)?.toInt() ?? 0,
      variableValues: json['variableValues'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
      'templateID': templateID,
      'variableValues': variableValues,
  };
}

class WebsiteProxyConfig {
  final bool allowCredentials;
  final String allowHeaders;
  final String allowMethods;
  final String allowOrigins;
  final bool cache;
  final int cacheTime;
  final String cacheUnit;
  final String content;
  final bool cors;
  final bool enable;
  final String filePath;
  final int id;
  final String match;
  final String modifier;
  final String name;
  final String operate;
  final bool preflight;
  final String proxyHost;
  final String proxyPass;
  final String proxySSLName;
  final Map<String, dynamic> replaces;
  final int serverCacheTime;
  final String serverCacheUnit;
  final bool sni;
  final bool sslVerify;

  const WebsiteProxyConfig({
    this.allowCredentials = false,
    this.allowHeaders = '',
    this.allowMethods = '',
    this.allowOrigins = '',
    this.cache = false,
    this.cacheTime = 0,
    this.cacheUnit = '',
    this.content = '',
    this.cors = false,
    this.enable = false,
    this.filePath = '',
    this.id = 0,
    this.match = '',
    this.modifier = '',
    this.name = '',
    this.operate = '',
    this.preflight = false,
    this.proxyHost = '',
    this.proxyPass = '',
    this.proxySSLName = '',
    this.replaces = const {},
    this.serverCacheTime = 0,
    this.serverCacheUnit = '',
    this.sni = false,
    this.sslVerify = false,
  });

  factory WebsiteProxyConfig.fromJson(Map<String, dynamic> json) {
    return WebsiteProxyConfig(
      allowCredentials: json['allowCredentials'] as bool? ?? false,
      allowHeaders: json['allowHeaders'] as String? ?? '',
      allowMethods: json['allowMethods'] as String? ?? '',
      allowOrigins: json['allowOrigins'] as String? ?? '',
      cache: json['cache'] as bool? ?? false,
      cacheTime: (json['cacheTime'] as num?)?.toInt() ?? 0,
      cacheUnit: json['cacheUnit'] as String? ?? '',
      content: json['content'] as String? ?? '',
      cors: json['cors'] as bool? ?? false,
      enable: json['enable'] as bool? ?? false,
      filePath: json['filePath'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      match: json['match'] as String? ?? '',
      modifier: json['modifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      preflight: json['preflight'] as bool? ?? false,
      proxyHost: json['proxyHost'] as String? ?? '',
      proxyPass: json['proxyPass'] as String? ?? '',
      proxySSLName: json['proxySSLName'] as String? ?? '',
      replaces: json['replaces'] as Map<String, dynamic>? ?? const {},
      serverCacheTime: (json['serverCacheTime'] as num?)?.toInt() ?? 0,
      serverCacheUnit: json['serverCacheUnit'] as String? ?? '',
      sni: json['sni'] as bool? ?? false,
      sslVerify: json['sslVerify'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'allowCredentials': allowCredentials,
      'allowHeaders': allowHeaders,
      'allowMethods': allowMethods,
      'allowOrigins': allowOrigins,
      'cache': cache,
      'cacheTime': cacheTime,
      'cacheUnit': cacheUnit,
      'content': content,
      'cors': cors,
      'enable': enable,
      'filePath': filePath,
      'id': id,
      'match': match,
      'modifier': modifier,
      'name': name,
      'operate': operate,
      'preflight': preflight,
      'proxyHost': proxyHost,
      'proxyPass': proxyPass,
      'proxySSLName': proxySSLName,
      'replaces': replaces,
      'serverCacheTime': serverCacheTime,
      'serverCacheUnit': serverCacheUnit,
      'sni': sni,
      'sslVerify': sslVerify,
  };
}

class WebsiteProxyDel {
  final int id;
  final String name;

  const WebsiteProxyDel({
    this.id = 0,
    this.name = '',
  });

  factory WebsiteProxyDel.fromJson(Map<String, dynamic> json) {
    return WebsiteProxyDel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
  };
}

class WebsiteProxyReq {
  final int id;

  const WebsiteProxyReq({
    this.id = 0,
  });

  factory WebsiteProxyReq.fromJson(Map<String, dynamic> json) {
    return WebsiteProxyReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class WebsiteProxyStatusUpdate {
  final int id;
  final String name;
  final String status;

  const WebsiteProxyStatusUpdate({
    this.id = 0,
    this.name = '',
    this.status = '',
  });

  factory WebsiteProxyStatusUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteProxyStatusUpdate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'status': status,
  };
}

class WebsiteRealIP {
  final String ipFrom;
  final String ipHeader;
  final String ipOther;
  final bool open;
  final int websiteID;

  const WebsiteRealIP({
    this.ipFrom = '',
    this.ipHeader = '',
    this.ipOther = '',
    this.open = false,
    this.websiteID = 0,
  });

  factory WebsiteRealIP.fromJson(Map<String, dynamic> json) {
    return WebsiteRealIP(
      ipFrom: json['ipFrom'] as String? ?? '',
      ipHeader: json['ipHeader'] as String? ?? '',
      ipOther: json['ipOther'] as String? ?? '',
      open: json['open'] as bool? ?? false,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'ipFrom': ipFrom,
      'ipHeader': ipHeader,
      'ipOther': ipOther,
      'open': open,
      'websiteID': websiteID,
  };
}

class WebsiteResourceReq {
  final int id;

  const WebsiteResourceReq({
    this.id = 0,
  });

  factory WebsiteResourceReq.fromJson(Map<String, dynamic> json) {
    return WebsiteResourceReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class WebsiteSSLApply {
  final int iD;
  final List<String> nameservers;
  final bool skipDNSCheck;

  const WebsiteSSLApply({
    this.iD = 0,
    this.nameservers = const [],
    this.skipDNSCheck = false,
  });

  factory WebsiteSSLApply.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLApply(
      iD: (json['ID'] as num?)?.toInt() ?? 0,
      nameservers: (json['nameservers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      skipDNSCheck: json['skipDNSCheck'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ID': iD,
      'nameservers': nameservers,
      'skipDNSCheck': skipDNSCheck,
  };
}

class WebsiteSSLCreate {
  final int acmeAccountId;
  final bool apply;
  final bool autoRenew;
  final String description;
  final String dir;
  final bool disableCNAME;
  final int dnsAccountId;
  final bool execShell;
  final int id;
  final bool isIp;
  final String keyType;
  final String nameserver1;
  final String nameserver2;
  final String nodes;
  final String otherDomains;
  final String primaryDomain;
  final String provider;
  final bool pushDir;
  final bool pushNode;
  final String shell;
  final bool skipDNS;

  const WebsiteSSLCreate({
    this.acmeAccountId = 0,
    this.apply = false,
    this.autoRenew = false,
    this.description = '',
    this.dir = '',
    this.disableCNAME = false,
    this.dnsAccountId = 0,
    this.execShell = false,
    this.id = 0,
    this.isIp = false,
    this.keyType = '',
    this.nameserver1 = '',
    this.nameserver2 = '',
    this.nodes = '',
    this.otherDomains = '',
    this.primaryDomain = '',
    this.provider = '',
    this.pushDir = false,
    this.pushNode = false,
    this.shell = '',
    this.skipDNS = false,
  });

  factory WebsiteSSLCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLCreate(
      acmeAccountId: (json['acmeAccountId'] as num?)?.toInt() ?? 0,
      apply: json['apply'] as bool? ?? false,
      autoRenew: json['autoRenew'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      disableCNAME: json['disableCNAME'] as bool? ?? false,
      dnsAccountId: (json['dnsAccountId'] as num?)?.toInt() ?? 0,
      execShell: json['execShell'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      isIp: json['isIp'] as bool? ?? false,
      keyType: json['keyType'] as String? ?? '',
      nameserver1: json['nameserver1'] as String? ?? '',
      nameserver2: json['nameserver2'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      otherDomains: json['otherDomains'] as String? ?? '',
      primaryDomain: json['primaryDomain'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      pushDir: json['pushDir'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      shell: json['shell'] as String? ?? '',
      skipDNS: json['skipDNS'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountId': acmeAccountId,
      'apply': apply,
      'autoRenew': autoRenew,
      'description': description,
      'dir': dir,
      'disableCNAME': disableCNAME,
      'dnsAccountId': dnsAccountId,
      'execShell': execShell,
      'id': id,
      'isIp': isIp,
      'keyType': keyType,
      'nameserver1': nameserver1,
      'nameserver2': nameserver2,
      'nodes': nodes,
      'otherDomains': otherDomains,
      'primaryDomain': primaryDomain,
      'provider': provider,
      'pushDir': pushDir,
      'pushNode': pushNode,
      'shell': shell,
      'skipDNS': skipDNS,
  };
}

class WebsiteSSLListReq {
  final String acmeAccountID;

  const WebsiteSSLListReq({
    this.acmeAccountID = '',
  });

  factory WebsiteSSLListReq.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLListReq(
      acmeAccountID: json['acmeAccountID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountID': acmeAccountID,
  };
}

class WebsiteSSLPush {
  final int id;
  final String nodes;
  final bool pushNode;
  final bool $sync;
  final String taskID;

  const WebsiteSSLPush({
    this.id = 0,
    this.nodes = '',
    this.pushNode = false,
    this.$sync = false,
    this.taskID = '',
  });

  factory WebsiteSSLPush.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLPush(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nodes: json['nodes'] as String? ?? '',
      pushNode: json['pushNode'] as bool? ?? false,
      $sync: json['sync'] as bool? ?? false,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'nodes': nodes,
      'pushNode': pushNode,
      'sync': $sync,
      'taskID': taskID,
  };
}

class WebsiteSSLSearch {
  final String acmeAccountID;
  final String domain;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const WebsiteSSLSearch({
    this.acmeAccountID = '',
    this.domain = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory WebsiteSSLSearch.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLSearch(
      acmeAccountID: json['acmeAccountID'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountID': acmeAccountID,
      'domain': domain,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
  };
}

class WebsiteSSLUpdate {
  final int acmeAccountId;
  final bool apply;
  final bool autoRenew;
  final String description;
  final String dir;
  final bool disableCNAME;
  final int dnsAccountId;
  final bool execShell;
  final int id;
  final String keyType;
  final String nameserver1;
  final String nameserver2;
  final String nodes;
  final String otherDomains;
  final String primaryDomain;
  final String provider;
  final bool pushDir;
  final bool pushNode;
  final String shell;
  final bool skipDNS;

  const WebsiteSSLUpdate({
    this.acmeAccountId = 0,
    this.apply = false,
    this.autoRenew = false,
    this.description = '',
    this.dir = '',
    this.disableCNAME = false,
    this.dnsAccountId = 0,
    this.execShell = false,
    this.id = 0,
    this.keyType = '',
    this.nameserver1 = '',
    this.nameserver2 = '',
    this.nodes = '',
    this.otherDomains = '',
    this.primaryDomain = '',
    this.provider = '',
    this.pushDir = false,
    this.pushNode = false,
    this.shell = '',
    this.skipDNS = false,
  });

  factory WebsiteSSLUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLUpdate(
      acmeAccountId: (json['acmeAccountId'] as num?)?.toInt() ?? 0,
      apply: json['apply'] as bool? ?? false,
      autoRenew: json['autoRenew'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      disableCNAME: json['disableCNAME'] as bool? ?? false,
      dnsAccountId: (json['dnsAccountId'] as num?)?.toInt() ?? 0,
      execShell: json['execShell'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      keyType: json['keyType'] as String? ?? '',
      nameserver1: json['nameserver1'] as String? ?? '',
      nameserver2: json['nameserver2'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      otherDomains: json['otherDomains'] as String? ?? '',
      primaryDomain: json['primaryDomain'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      pushDir: json['pushDir'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      shell: json['shell'] as String? ?? '',
      skipDNS: json['skipDNS'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountId': acmeAccountId,
      'apply': apply,
      'autoRenew': autoRenew,
      'description': description,
      'dir': dir,
      'disableCNAME': disableCNAME,
      'dnsAccountId': dnsAccountId,
      'execShell': execShell,
      'id': id,
      'keyType': keyType,
      'nameserver1': nameserver1,
      'nameserver2': nameserver2,
      'nodes': nodes,
      'otherDomains': otherDomains,
      'primaryDomain': primaryDomain,
      'provider': provider,
      'pushDir': pushDir,
      'pushNode': pushNode,
      'shell': shell,
      'skipDNS': skipDNS,
  };
}

class WebsiteSSLUpload {
  final String certificate;
  final String certificatePath;
  final String description;
  final String nodes;
  final String privateKey;
  final String privateKeyPath;
  final bool pushNode;
  final int sslID;
  final String type;

  const WebsiteSSLUpload({
    this.certificate = '',
    this.certificatePath = '',
    this.description = '',
    this.nodes = '',
    this.privateKey = '',
    this.privateKeyPath = '',
    this.pushNode = false,
    this.sslID = 0,
    this.type = '',
  });

  factory WebsiteSSLUpload.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLUpload(
      certificate: json['certificate'] as String? ?? '',
      certificatePath: json['certificatePath'] as String? ?? '',
      description: json['description'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      privateKeyPath: json['privateKeyPath'] as String? ?? '',
      pushNode: json['pushNode'] as bool? ?? false,
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'certificate': certificate,
      'certificatePath': certificatePath,
      'description': description,
      'nodes': nodes,
      'privateKey': privateKey,
      'privateKeyPath': privateKeyPath,
      'pushNode': pushNode,
      'sslID': sslID,
      'type': type,
  };
}

class WebsiteSearch {
  final String name;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;
  final String type;
  final int websiteGroupId;

  const WebsiteSearch({
    this.name = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
    this.websiteGroupId = 0,
  });

  factory WebsiteSearch.fromJson(Map<String, dynamic> json) {
    return WebsiteSearch(
      name: json['name'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      websiteGroupId: (json['websiteGroupId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'type': type,
      'websiteGroupId': websiteGroupId,
  };
}

class WebsiteTemplateCreate {
  final String content;
  final String filePath;
  final String name;
  final String remark;
  final String type;
  final String variables;

  const WebsiteTemplateCreate({
    this.content = '',
    this.filePath = '',
    this.name = '',
    this.remark = '',
    this.type = '',
    this.variables = '',
  });

  factory WebsiteTemplateCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateCreate(
      content: json['content'] as String? ?? '',
      filePath: json['filePath'] as String? ?? '',
      name: json['name'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      type: json['type'] as String? ?? '',
      variables: json['variables'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'filePath': filePath,
      'name': name,
      'remark': remark,
      'type': type,
      'variables': variables,
  };
}

class WebsiteTemplateOutputCreate {
  final String name;
  final int templateID;
  final Map<String, dynamic> variableValues;

  const WebsiteTemplateOutputCreate({
    this.name = '',
    this.templateID = 0,
    this.variableValues = const {},
  });

  factory WebsiteTemplateOutputCreate.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateOutputCreate(
      name: json['name'] as String? ?? '',
      templateID: (json['templateID'] as num?)?.toInt() ?? 0,
      variableValues: json['variableValues'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'templateID': templateID,
      'variableValues': variableValues,
  };
}

class WebsiteTemplateOutputSearch {
  final int page;
  final int pageSize;
  final int templateID;

  const WebsiteTemplateOutputSearch({
    this.page = 0,
    this.pageSize = 0,
    this.templateID = 0,
  });

  factory WebsiteTemplateOutputSearch.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateOutputSearch(
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      templateID: (json['templateID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'page': page,
      'pageSize': pageSize,
      'templateID': templateID,
  };
}

class WebsiteTemplateSearch {
  final String name;
  final int page;
  final int pageSize;
  final String type;

  const WebsiteTemplateSearch({
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
  });

  factory WebsiteTemplateSearch.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateSearch(
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'type': type,
  };
}

class WebsiteTemplateUpdate {
  final String content;
  final String filePath;
  final int id;
  final String name;
  final String remark;
  final String type;
  final String variables;

  const WebsiteTemplateUpdate({
    this.content = '',
    this.filePath = '',
    this.id = 0,
    this.name = '',
    this.remark = '',
    this.type = '',
    this.variables = '',
  });

  factory WebsiteTemplateUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateUpdate(
      content: json['content'] as String? ?? '',
      filePath: json['filePath'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      type: json['type'] as String? ?? '',
      variables: json['variables'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'filePath': filePath,
      'id': id,
      'name': name,
      'remark': remark,
      'type': type,
      'variables': variables,
  };
}

class WebsiteUpdate {
  final bool iPV6;
  final String expireDate;
  final bool favorite;
  final int id;
  final String primaryDomain;
  final String remark;
  final int webSiteGroupID;

  const WebsiteUpdate({
    this.iPV6 = false,
    this.expireDate = '',
    this.favorite = false,
    this.id = 0,
    this.primaryDomain = '',
    this.remark = '',
    this.webSiteGroupID = 0,
  });

  factory WebsiteUpdate.fromJson(Map<String, dynamic> json) {
    return WebsiteUpdate(
      iPV6: json['IPV6'] as bool? ?? false,
      expireDate: json['expireDate'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      primaryDomain: json['primaryDomain'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      webSiteGroupID: (json['webSiteGroupID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'IPV6': iPV6,
      'expireDate': expireDate,
      'favorite': favorite,
      'id': id,
      'primaryDomain': primaryDomain,
      'remark': remark,
      'webSiteGroupID': webSiteGroupID,
  };
}

class WebsiteUpdateDir {
  final int id;
  final String siteDir;

  const WebsiteUpdateDir({
    this.id = 0,
    this.siteDir = '',
  });

  factory WebsiteUpdateDir.fromJson(Map<String, dynamic> json) {
    return WebsiteUpdateDir(
      id: (json['id'] as num?)?.toInt() ?? 0,
      siteDir: json['siteDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'siteDir': siteDir,
  };
}

class WebsiteUpdateDirPermission {
  final String group;
  final int id;
  final String user;

  const WebsiteUpdateDirPermission({
    this.group = '',
    this.id = 0,
    this.user = '',
  });

  factory WebsiteUpdateDirPermission.fromJson(Map<String, dynamic> json) {
    return WebsiteUpdateDirPermission(
      group: json['group'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'group': group,
      'id': id,
      'user': user,
  };
}

class Database {
  final String databaseName;
  final String from;
  final int id;
  final String name;
  final String type;

  const Database({
    this.databaseName = '',
    this.from = '',
    this.id = 0,
    this.name = '',
    this.type = '',
  });

  factory Database.fromJson(Map<String, dynamic> json) {
    return Database(
      databaseName: json['databaseName'] as String? ?? '',
      from: json['from'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'databaseName': databaseName,
      'from': from,
      'id': id,
      'name': name,
      'type': type,
  };
}

class FileInfo {
  final String content;
  final String extension;
  final int favoriteID;
  final String gid;
  final String group;
  final bool isAppendOnly;
  final bool isDetail;
  final bool isDir;
  final bool isHidden;
  final bool isImmutable;
  final bool isSymlink;
  final int itemTotal;
  final List<FilesFileinfo> items;
  final String linkPath;
  final String mimeType;
  final String modTime;
  final String mode;
  final String name;
  final String path;
  final String shareCode;
  final int size;
  final String type;
  final String uid;
  final String updateTime;
  final String user;

  const FileInfo({
    this.content = '',
    this.extension = '',
    this.favoriteID = 0,
    this.gid = '',
    this.group = '',
    this.isAppendOnly = false,
    this.isDetail = false,
    this.isDir = false,
    this.isHidden = false,
    this.isImmutable = false,
    this.isSymlink = false,
    this.itemTotal = 0,
    this.items = const [],
    this.linkPath = '',
    this.mimeType = '',
    this.modTime = '',
    this.mode = '',
    this.name = '',
    this.path = '',
    this.shareCode = '',
    this.size = 0,
    this.type = '',
    this.uid = '',
    this.updateTime = '',
    this.user = '',
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      content: json['content'] as String? ?? '',
      extension: json['extension'] as String? ?? '',
      favoriteID: (json['favoriteID'] as num?)?.toInt() ?? 0,
      gid: json['gid'] as String? ?? '',
      group: json['group'] as String? ?? '',
      isAppendOnly: json['isAppendOnly'] as bool? ?? false,
      isDetail: json['isDetail'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      isImmutable: json['isImmutable'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      itemTotal: (json['itemTotal'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((e) => FilesFileinfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      linkPath: json['linkPath'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      modTime: json['modTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      shareCode: json['shareCode'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'extension': extension,
      'favoriteID': favoriteID,
      'gid': gid,
      'group': group,
      'isAppendOnly': isAppendOnly,
      'isDetail': isDetail,
      'isDir': isDir,
      'isHidden': isHidden,
      'isImmutable': isImmutable,
      'isSymlink': isSymlink,
      'itemTotal': itemTotal,
      'items': items.map((e) => e.toJson()).toList(),
      'linkPath': linkPath,
      'mimeType': mimeType,
      'modTime': modTime,
      'mode': mode,
      'name': name,
      'path': path,
      'shareCode': shareCode,
      'size': size,
      'type': type,
      'uid': uid,
      'updateTime': updateTime,
      'user': user,
  };
}

class NginxAntiLeechRes {
  final bool blocked;
  final bool cache;
  final int cacheTime;
  final String cacheUint;
  final bool enable;
  final String $extends;
  final bool logEnable;
  final bool noneRef;
  final String $return;
  final List<String> serverNames;

  const NginxAntiLeechRes({
    this.blocked = false,
    this.cache = false,
    this.cacheTime = 0,
    this.cacheUint = '',
    this.enable = false,
    this.$extends = '',
    this.logEnable = false,
    this.noneRef = false,
    this.$return = '',
    this.serverNames = const [],
  });

  factory NginxAntiLeechRes.fromJson(Map<String, dynamic> json) {
    return NginxAntiLeechRes(
      blocked: json['blocked'] as bool? ?? false,
      cache: json['cache'] as bool? ?? false,
      cacheTime: (json['cacheTime'] as num?)?.toInt() ?? 0,
      cacheUint: json['cacheUint'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      $extends: json['extends'] as String? ?? '',
      logEnable: json['logEnable'] as bool? ?? false,
      noneRef: json['noneRef'] as bool? ?? false,
      $return: json['return'] as String? ?? '',
      serverNames: (json['serverNames'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'blocked': blocked,
      'cache': cache,
      'cacheTime': cacheTime,
      'cacheUint': cacheUint,
      'enable': enable,
      'extends': $extends,
      'logEnable': logEnable,
      'noneRef': noneRef,
      'return': $return,
      'serverNames': serverNames,
  };
}

class NginxAuthRes {
  final bool enable;
  final List<NginxAuth> items;

  const NginxAuthRes({
    this.enable = false,
    this.items = const [],
  });

  factory NginxAuthRes.fromJson(Map<String, dynamic> json) {
    return NginxAuthRes(
      enable: json['enable'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)?.map((e) => NginxAuth.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'enable': enable,
      'items': items.map((e) => e.toJson()).toList(),
  };
}

class NginxBuildConfig {
  final bool dynamicSupported;
  final String mirror;
  final List<NginxModule> modules;

  const NginxBuildConfig({
    this.dynamicSupported = false,
    this.mirror = '',
    this.modules = const [],
  });

  factory NginxBuildConfig.fromJson(Map<String, dynamic> json) {
    return NginxBuildConfig(
      dynamicSupported: json['dynamicSupported'] as bool? ?? false,
      mirror: json['mirror'] as String? ?? '',
      modules: (json['modules'] as List<dynamic>?)?.map((e) => NginxModule.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'dynamicSupported': dynamicSupported,
      'mirror': mirror,
      'modules': modules.map((e) => e.toJson()).toList(),
  };
}

class NginxConfigRes {
  final bool https;
  final bool sslRejectHandshake;

  const NginxConfigRes({
    this.https = false,
    this.sslRejectHandshake = false,
  });

  factory NginxConfigRes.fromJson(Map<String, dynamic> json) {
    return NginxConfigRes(
      https: json['https'] as bool? ?? false,
      sslRejectHandshake: json['sslRejectHandshake'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'https': https,
      'sslRejectHandshake': sslRejectHandshake,
  };
}

class NginxFile {
  final String content;

  const NginxFile({
    this.content = '',
  });

  factory NginxFile.fromJson(Map<String, dynamic> json) {
    return NginxFile(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class NginxModule {
  final List<NginxModuleArtifact> artifacts;
  final String buildMode;
  final String buildStatus;
  final bool custom;
  final bool enable;
  final String lastError;
  final int loadOrder;
  final String loadStatus;
  final String name;
  final String packages;
  final String params;
  final String provider;
  final String script;

  const NginxModule({
    this.artifacts = const [],
    this.buildMode = '',
    this.buildStatus = '',
    this.custom = false,
    this.enable = false,
    this.lastError = '',
    this.loadOrder = 0,
    this.loadStatus = '',
    this.name = '',
    this.packages = '',
    this.params = '',
    this.provider = '',
    this.script = '',
  });

  factory NginxModule.fromJson(Map<String, dynamic> json) {
    return NginxModule(
      artifacts: (json['artifacts'] as List<dynamic>?)?.map((e) => NginxModuleArtifact.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      buildMode: json['buildMode'] as String? ?? '',
      buildStatus: json['buildStatus'] as String? ?? '',
      custom: json['custom'] as bool? ?? false,
      enable: json['enable'] as bool? ?? false,
      lastError: json['lastError'] as String? ?? '',
      loadOrder: (json['loadOrder'] as num?)?.toInt() ?? 0,
      loadStatus: json['loadStatus'] as String? ?? '',
      name: json['name'] as String? ?? '',
      packages: json['packages'] as String? ?? '',
      params: json['params'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      script: json['script'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'artifacts': artifacts.map((e) => e.toJson()).toList(),
      'buildMode': buildMode,
      'buildStatus': buildStatus,
      'custom': custom,
      'enable': enable,
      'lastError': lastError,
      'loadOrder': loadOrder,
      'loadStatus': loadStatus,
      'name': name,
      'packages': packages,
      'params': params,
      'provider': provider,
      'script': script,
  };
}

class NginxParam {
  final String name;
  final List<String> params;

  const NginxParam({
    this.name = '',
    this.params = const [],
  });

  factory NginxParam.fromJson(Map<String, dynamic> json) {
    return NginxParam(
      name: json['name'] as String? ?? '',
      params: (json['params'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'params': params,
  };
}

class NginxPathAuthRes {
  final String name;
  final String path;
  final String remark;
  final String username;

  const NginxPathAuthRes({
    this.name = '',
    this.path = '',
    this.remark = '',
    this.username = '',
  });

  factory NginxPathAuthRes.fromJson(Map<String, dynamic> json) {
    return NginxPathAuthRes(
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'path': path,
      'remark': remark,
      'username': username,
  };
}

class NginxProxyCache {
  final int cacheExpire;
  final String cacheExpireUnit;
  final double cacheLimit;
  final String cacheLimitUnit;
  final bool open;
  final int shareCache;
  final String shareCacheUnit;

  const NginxProxyCache({
    this.cacheExpire = 0,
    this.cacheExpireUnit = '',
    this.cacheLimit = 0.0,
    this.cacheLimitUnit = '',
    this.open = false,
    this.shareCache = 0,
    this.shareCacheUnit = '',
  });

  factory NginxProxyCache.fromJson(Map<String, dynamic> json) {
    return NginxProxyCache(
      cacheExpire: (json['cacheExpire'] as num?)?.toInt() ?? 0,
      cacheExpireUnit: json['cacheExpireUnit'] as String? ?? '',
      cacheLimit: (json['cacheLimit'] as num?)?.toDouble() ?? 0.0,
      cacheLimitUnit: json['cacheLimitUnit'] as String? ?? '',
      open: json['open'] as bool? ?? false,
      shareCache: (json['shareCache'] as num?)?.toInt() ?? 0,
      shareCacheUnit: json['shareCacheUnit'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cacheExpire': cacheExpire,
      'cacheExpireUnit': cacheExpireUnit,
      'cacheLimit': cacheLimit,
      'cacheLimitUnit': cacheLimitUnit,
      'open': open,
      'shareCache': shareCache,
      'shareCacheUnit': shareCacheUnit,
  };
}

class NginxRedirectConfig {
  final String content;
  final List<String> domains;
  final bool enable;
  final String filePath;
  final bool keepPath;
  final String name;
  final String path;
  final String redirect;
  final bool redirectRoot;
  final String target;
  final String type;
  final int websiteID;

  const NginxRedirectConfig({
    this.content = '',
    this.domains = const [],
    this.enable = false,
    this.filePath = '',
    this.keepPath = false,
    this.name = '',
    this.path = '',
    this.redirect = '',
    this.redirectRoot = false,
    this.target = '',
    this.type = '',
    this.websiteID = 0,
  });

  factory NginxRedirectConfig.fromJson(Map<String, dynamic> json) {
    return NginxRedirectConfig(
      content: json['content'] as String? ?? '',
      domains: (json['domains'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      enable: json['enable'] as bool? ?? false,
      filePath: json['filePath'] as String? ?? '',
      keepPath: json['keepPath'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      redirect: json['redirect'] as String? ?? '',
      redirectRoot: json['redirectRoot'] as bool? ?? false,
      target: json['target'] as String? ?? '',
      type: json['type'] as String? ?? '',
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'domains': domains,
      'enable': enable,
      'filePath': filePath,
      'keepPath': keepPath,
      'name': name,
      'path': path,
      'redirect': redirect,
      'redirectRoot': redirectRoot,
      'target': target,
      'type': type,
      'websiteID': websiteID,
  };
}

class NginxRewriteRes {
  final String content;

  const NginxRewriteRes({
    this.content = '',
  });

  factory NginxRewriteRes.fromJson(Map<String, dynamic> json) {
    return NginxRewriteRes(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class NginxStatus {
  final int accepts;
  final int active;
  final int handled;
  final int reading;
  final int requests;
  final int waiting;
  final int writing;

  const NginxStatus({
    this.accepts = 0,
    this.active = 0,
    this.handled = 0,
    this.reading = 0,
    this.requests = 0,
    this.waiting = 0,
    this.writing = 0,
  });

  factory NginxStatus.fromJson(Map<String, dynamic> json) {
    return NginxStatus(
      accepts: (json['accepts'] as num?)?.toInt() ?? 0,
      active: (json['active'] as num?)?.toInt() ?? 0,
      handled: (json['handled'] as num?)?.toInt() ?? 0,
      reading: (json['reading'] as num?)?.toInt() ?? 0,
      requests: (json['requests'] as num?)?.toInt() ?? 0,
      waiting: (json['waiting'] as num?)?.toInt() ?? 0,
      writing: (json['writing'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'accepts': accepts,
      'active': active,
      'handled': handled,
      'reading': reading,
      'requests': requests,
      'waiting': waiting,
      'writing': writing,
  };
}

class Resource {
  final dynamic detail;
  final String name;
  final int resourceID;
  final String type;

  const Resource({
    this.detail,
    this.name = '',
    this.resourceID = 0,
    this.type = '',
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      detail: json['detail'],
      name: json['name'] as String? ?? '',
      resourceID: (json['resourceID'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detail': detail,
      'name': name,
      'resourceID': resourceID,
      'type': type,
  };
}

class WebsiteAcmeAccountDTO {
  final String caDirURL;
  final String createdAt;
  final String eabHmacKey;
  final String eabKid;
  final String email;
  final int id;
  final String keyType;
  final String type;
  final String updatedAt;
  final String url;
  final bool useEAB;
  final bool useProxy;

  const WebsiteAcmeAccountDTO({
    this.caDirURL = '',
    this.createdAt = '',
    this.eabHmacKey = '',
    this.eabKid = '',
    this.email = '',
    this.id = 0,
    this.keyType = '',
    this.type = '',
    this.updatedAt = '',
    this.url = '',
    this.useEAB = false,
    this.useProxy = false,
  });

  factory WebsiteAcmeAccountDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteAcmeAccountDTO(
      caDirURL: json['caDirURL'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      eabHmacKey: json['eabHmacKey'] as String? ?? '',
      eabKid: json['eabKid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      keyType: json['keyType'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      url: json['url'] as String? ?? '',
      useEAB: json['useEAB'] as bool? ?? false,
      useProxy: json['useProxy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'caDirURL': caDirURL,
      'createdAt': createdAt,
      'eabHmacKey': eabHmacKey,
      'eabKid': eabKid,
      'email': email,
      'id': id,
      'keyType': keyType,
      'type': type,
      'updatedAt': updatedAt,
      'url': url,
      'useEAB': useEAB,
      'useProxy': useProxy,
  };
}

class WebsiteCADTO {
  final String city;
  final String commonName;
  final String country;
  final String createdAt;
  final String csr;
  final int id;
  final String keyType;
  final String name;
  final String organization;
  final String organizationUint;
  final String privateKey;
  final String province;
  final String updatedAt;

  const WebsiteCADTO({
    this.city = '',
    this.commonName = '',
    this.country = '',
    this.createdAt = '',
    this.csr = '',
    this.id = 0,
    this.keyType = '',
    this.name = '',
    this.organization = '',
    this.organizationUint = '',
    this.privateKey = '',
    this.province = '',
    this.updatedAt = '',
  });

  factory WebsiteCADTO.fromJson(Map<String, dynamic> json) {
    return WebsiteCADTO(
      city: json['city'] as String? ?? '',
      commonName: json['commonName'] as String? ?? '',
      country: json['country'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      csr: json['csr'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      keyType: json['keyType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      organizationUint: json['organizationUint'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      province: json['province'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'city': city,
      'commonName': commonName,
      'country': country,
      'createdAt': createdAt,
      'csr': csr,
      'id': id,
      'keyType': keyType,
      'name': name,
      'organization': organization,
      'organizationUint': organizationUint,
      'privateKey': privateKey,
      'province': province,
      'updatedAt': updatedAt,
  };
}

class WebsiteDNSRes {
  final String domain;
  final String err;
  final String resolve;
  final String value;

  const WebsiteDNSRes({
    this.domain = '',
    this.err = '',
    this.resolve = '',
    this.value = '',
  });

  factory WebsiteDNSRes.fromJson(Map<String, dynamic> json) {
    return WebsiteDNSRes(
      domain: json['domain'] as String? ?? '',
      err: json['err'] as String? ?? '',
      resolve: json['resolve'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'domain': domain,
      'err': err,
      'resolve': resolve,
      'value': value,
  };
}

class WebsiteDTO {
  final bool iPV6;
  final bool accessLog;
  final String accessLogPath;
  final String algorithm;
  final String alias;
  final int appInstallId;
  final String appName;
  final String createdAt;
  final int dbID;
  final String dbType;
  final bool defaultServer;
  final List<WebsiteDomain> domains;
  final bool errorLog;
  final String errorLogPath;
  final String expireDate;
  final bool favorite;
  final int ftpId;
  final String group;
  final String httpConfig;
  final int id;
  final bool openBaseDir;
  final int parentWebsiteID;
  final String primaryDomain;
  final String protocol;
  final String proxy;
  final String proxyType;
  final String remark;
  final String rewrite;
  final int runtimeID;
  final String runtimeName;
  final String $runtimeType;
  final List<NginxUpstreamServer> servers;
  final String siteDir;
  final String sitePath;
  final String status;
  final String streamPorts;
  final String type;
  final bool udp;
  final String updatedAt;
  final String user;
  final int webSiteGroupId;
  final WebsiteSSL? webSiteSSL;
  final int webSiteSSLId;

  const WebsiteDTO({
    this.iPV6 = false,
    this.accessLog = false,
    this.accessLogPath = '',
    this.algorithm = '',
    this.alias = '',
    this.appInstallId = 0,
    this.appName = '',
    this.createdAt = '',
    this.dbID = 0,
    this.dbType = '',
    this.defaultServer = false,
    this.domains = const [],
    this.errorLog = false,
    this.errorLogPath = '',
    this.expireDate = '',
    this.favorite = false,
    this.ftpId = 0,
    this.group = '',
    this.httpConfig = '',
    this.id = 0,
    this.openBaseDir = false,
    this.parentWebsiteID = 0,
    this.primaryDomain = '',
    this.protocol = '',
    this.proxy = '',
    this.proxyType = '',
    this.remark = '',
    this.rewrite = '',
    this.runtimeID = 0,
    this.runtimeName = '',
    this.$runtimeType = '',
    this.servers = const [],
    this.siteDir = '',
    this.sitePath = '',
    this.status = '',
    this.streamPorts = '',
    this.type = '',
    this.udp = false,
    this.updatedAt = '',
    this.user = '',
    this.webSiteGroupId = 0,
    this.webSiteSSL,
    this.webSiteSSLId = 0,
  });

  factory WebsiteDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteDTO(
      iPV6: json['IPV6'] as bool? ?? false,
      accessLog: json['accessLog'] as bool? ?? false,
      accessLogPath: json['accessLogPath'] as String? ?? '',
      algorithm: json['algorithm'] as String? ?? '',
      alias: json['alias'] as String? ?? '',
      appInstallId: (json['appInstallId'] as num?)?.toInt() ?? 0,
      appName: json['appName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      dbID: (json['dbID'] as num?)?.toInt() ?? 0,
      dbType: json['dbType'] as String? ?? '',
      defaultServer: json['defaultServer'] as bool? ?? false,
      domains: (json['domains'] as List<dynamic>?)?.map((e) => WebsiteDomain.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      errorLog: json['errorLog'] as bool? ?? false,
      errorLogPath: json['errorLogPath'] as String? ?? '',
      expireDate: json['expireDate'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
      ftpId: (json['ftpId'] as num?)?.toInt() ?? 0,
      group: json['group'] as String? ?? '',
      httpConfig: json['httpConfig'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      openBaseDir: json['openBaseDir'] as bool? ?? false,
      parentWebsiteID: (json['parentWebsiteID'] as num?)?.toInt() ?? 0,
      primaryDomain: json['primaryDomain'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      proxyType: json['proxyType'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      rewrite: json['rewrite'] as String? ?? '',
      runtimeID: (json['runtimeID'] as num?)?.toInt() ?? 0,
      runtimeName: json['runtimeName'] as String? ?? '',
      $runtimeType: json['runtimeType'] as String? ?? '',
      servers: (json['servers'] as List<dynamic>?)?.map((e) => NginxUpstreamServer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      siteDir: json['siteDir'] as String? ?? '',
      sitePath: json['sitePath'] as String? ?? '',
      status: json['status'] as String? ?? '',
      streamPorts: json['streamPorts'] as String? ?? '',
      type: json['type'] as String? ?? '',
      udp: json['udp'] as bool? ?? false,
      updatedAt: json['updatedAt'] as String? ?? '',
      user: json['user'] as String? ?? '',
      webSiteGroupId: (json['webSiteGroupId'] as num?)?.toInt() ?? 0,
      webSiteSSL: json['webSiteSSL'] != null ? WebsiteSSL.fromJson(json['webSiteSSL'] as Map<String, dynamic>) : null,
      webSiteSSLId: (json['webSiteSSLId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'IPV6': iPV6,
      'accessLog': accessLog,
      'accessLogPath': accessLogPath,
      'algorithm': algorithm,
      'alias': alias,
      'appInstallId': appInstallId,
      'appName': appName,
      'createdAt': createdAt,
      'dbID': dbID,
      'dbType': dbType,
      'defaultServer': defaultServer,
      'domains': domains.map((e) => e.toJson()).toList(),
      'errorLog': errorLog,
      'errorLogPath': errorLogPath,
      'expireDate': expireDate,
      'favorite': favorite,
      'ftpId': ftpId,
      'group': group,
      'httpConfig': httpConfig,
      'id': id,
      'openBaseDir': openBaseDir,
      'parentWebsiteID': parentWebsiteID,
      'primaryDomain': primaryDomain,
      'protocol': protocol,
      'proxy': proxy,
      'proxyType': proxyType,
      'remark': remark,
      'rewrite': rewrite,
      'runtimeID': runtimeID,
      'runtimeName': runtimeName,
      'runtimeType': $runtimeType,
      'servers': servers.map((e) => e.toJson()).toList(),
      'siteDir': siteDir,
      'sitePath': sitePath,
      'status': status,
      'streamPorts': streamPorts,
      'type': type,
      'udp': udp,
      'updatedAt': updatedAt,
      'user': user,
      'webSiteGroupId': webSiteGroupId,
      if (webSiteSSL != null) 'webSiteSSL': webSiteSSL!.toJson(),
      'webSiteSSLId': webSiteSSLId,
  };
}

class WebsiteDirConfig {
  final List<String> dirs;
  final String msg;
  final String user;
  final String userGroup;

  const WebsiteDirConfig({
    this.dirs = const [],
    this.msg = '',
    this.user = '',
    this.userGroup = '',
  });

  factory WebsiteDirConfig.fromJson(Map<String, dynamic> json) {
    return WebsiteDirConfig(
      dirs: (json['dirs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      msg: json['msg'] as String? ?? '',
      user: json['user'] as String? ?? '',
      userGroup: json['userGroup'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'dirs': dirs,
      'msg': msg,
      'user': user,
      'userGroup': userGroup,
  };
}

class WebsiteHTTPS {
  final WebsiteSSL? sSL;
  final List<String> sSLProtocol;
  final String algorithm;
  final bool enable;
  final bool hsts;
  final bool hstsIncludeSubDomains;
  final bool http3;
  final String httpConfig;
  final String httpsPort;
  final List<int> httpsPorts;

  const WebsiteHTTPS({
    this.sSL,
    this.sSLProtocol = const [],
    this.algorithm = '',
    this.enable = false,
    this.hsts = false,
    this.hstsIncludeSubDomains = false,
    this.http3 = false,
    this.httpConfig = '',
    this.httpsPort = '',
    this.httpsPorts = const [],
  });

  factory WebsiteHTTPS.fromJson(Map<String, dynamic> json) {
    return WebsiteHTTPS(
      sSL: json['SSL'] != null ? WebsiteSSL.fromJson(json['SSL'] as Map<String, dynamic>) : null,
      sSLProtocol: (json['SSLProtocol'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      algorithm: json['algorithm'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      hsts: json['hsts'] as bool? ?? false,
      hstsIncludeSubDomains: json['hstsIncludeSubDomains'] as bool? ?? false,
      http3: json['http3'] as bool? ?? false,
      httpConfig: json['httpConfig'] as String? ?? '',
      httpsPort: json['httpsPort'] as String? ?? '',
      httpsPorts: (json['httpsPorts'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (sSL != null) 'SSL': sSL!.toJson(),
      'SSLProtocol': sSLProtocol,
      'algorithm': algorithm,
      'enable': enable,
      'hsts': hsts,
      'hstsIncludeSubDomains': hstsIncludeSubDomains,
      'http3': http3,
      'httpConfig': httpConfig,
      'httpsPort': httpsPort,
      'httpsPorts': httpsPorts,
  };
}

class WebsiteHtmlRes {
  final String content;

  const WebsiteHtmlRes({
    this.content = '',
  });

  factory WebsiteHtmlRes.fromJson(Map<String, dynamic> json) {
    return WebsiteHtmlRes(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class WebsiteLog {
  final String content;
  final bool enable;
  final bool end;
  final String path;

  const WebsiteLog({
    this.content = '',
    this.enable = false,
    this.end = false,
    this.path = '',
  });

  factory WebsiteLog.fromJson(Map<String, dynamic> json) {
    return WebsiteLog(
      content: json['content'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      end: json['end'] as bool? ?? false,
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'enable': enable,
      'end': end,
      'path': path,
  };
}

class WebsiteNginxConfig {
  final bool enable;
  final List<NginxParam> params;

  const WebsiteNginxConfig({
    this.enable = false,
    this.params = const [],
  });

  factory WebsiteNginxConfig.fromJson(Map<String, dynamic> json) {
    return WebsiteNginxConfig(
      enable: json['enable'] as bool? ?? false,
      params: (json['params'] as List<dynamic>?)?.map((e) => NginxParam.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'enable': enable,
      'params': params.map((e) => e.toJson()).toList(),
  };
}

class WebsiteOption {
  final String alias;
  final int id;
  final String primaryDomain;

  const WebsiteOption({
    this.alias = '',
    this.id = 0,
    this.primaryDomain = '',
  });

  factory WebsiteOption.fromJson(Map<String, dynamic> json) {
    return WebsiteOption(
      alias: json['alias'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      primaryDomain: json['primaryDomain'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'alias': alias,
      'id': id,
      'primaryDomain': primaryDomain,
  };
}

class WebsitePreInstallCheck {
  final String appName;
  final String name;
  final String status;
  final String version;

  const WebsitePreInstallCheck({
    this.appName = '',
    this.name = '',
    this.status = '',
    this.version = '',
  });

  factory WebsitePreInstallCheck.fromJson(Map<String, dynamic> json) {
    return WebsitePreInstallCheck(
      appName: json['appName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appName': appName,
      'name': name,
      'status': status,
      'version': version,
  };
}

class WebsitePreviewDTO {
  final String html;

  const WebsitePreviewDTO({
    this.html = '',
  });

  factory WebsitePreviewDTO.fromJson(Map<String, dynamic> json) {
    return WebsitePreviewDTO(
      html: json['html'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'html': html,
  };
}

class WebsiteSSLDTO {
  final WebsiteAcmeAccount? acmeAccount;
  final int acmeAccountId;
  final bool autoRenew;
  final int caId;
  final String certPath;
  final String certURL;
  final String createdAt;
  final String description;
  final String dir;
  final bool disableCNAME;
  final WebsiteDnsAccount? dnsAccount;
  final int dnsAccountId;
  final String domains;
  final bool execShell;
  final String expireDate;
  final int id;
  final bool isIP;
  final String keyType;
  final String logPath;
  final int masterSslId;
  final String message;
  final String nameserver1;
  final String nameserver2;
  final String nodes;
  final String organization;
  final String pem;
  final String primaryDomain;
  final String privateKey;
  final String privateKeyPath;
  final String provider;
  final bool pushDir;
  final bool pushNode;
  final String shell;
  final bool skipDNS;
  final String startDate;
  final String status;
  final String type;
  final String updatedAt;
  final List<Website> websites;

  const WebsiteSSLDTO({
    this.acmeAccount,
    this.acmeAccountId = 0,
    this.autoRenew = false,
    this.caId = 0,
    this.certPath = '',
    this.certURL = '',
    this.createdAt = '',
    this.description = '',
    this.dir = '',
    this.disableCNAME = false,
    this.dnsAccount,
    this.dnsAccountId = 0,
    this.domains = '',
    this.execShell = false,
    this.expireDate = '',
    this.id = 0,
    this.isIP = false,
    this.keyType = '',
    this.logPath = '',
    this.masterSslId = 0,
    this.message = '',
    this.nameserver1 = '',
    this.nameserver2 = '',
    this.nodes = '',
    this.organization = '',
    this.pem = '',
    this.primaryDomain = '',
    this.privateKey = '',
    this.privateKeyPath = '',
    this.provider = '',
    this.pushDir = false,
    this.pushNode = false,
    this.shell = '',
    this.skipDNS = false,
    this.startDate = '',
    this.status = '',
    this.type = '',
    this.updatedAt = '',
    this.websites = const [],
  });

  factory WebsiteSSLDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteSSLDTO(
      acmeAccount: json['acmeAccount'] != null ? WebsiteAcmeAccount.fromJson(json['acmeAccount'] as Map<String, dynamic>) : null,
      acmeAccountId: (json['acmeAccountId'] as num?)?.toInt() ?? 0,
      autoRenew: json['autoRenew'] as bool? ?? false,
      caId: (json['caId'] as num?)?.toInt() ?? 0,
      certPath: json['certPath'] as String? ?? '',
      certURL: json['certURL'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      disableCNAME: json['disableCNAME'] as bool? ?? false,
      dnsAccount: json['dnsAccount'] != null ? WebsiteDnsAccount.fromJson(json['dnsAccount'] as Map<String, dynamic>) : null,
      dnsAccountId: (json['dnsAccountId'] as num?)?.toInt() ?? 0,
      domains: json['domains'] as String? ?? '',
      execShell: json['execShell'] as bool? ?? false,
      expireDate: json['expireDate'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isIP: json['isIP'] as bool? ?? false,
      keyType: json['keyType'] as String? ?? '',
      logPath: json['logPath'] as String? ?? '',
      masterSslId: (json['masterSslId'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      nameserver1: json['nameserver1'] as String? ?? '',
      nameserver2: json['nameserver2'] as String? ?? '',
      nodes: json['nodes'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      pem: json['pem'] as String? ?? '',
      primaryDomain: json['primaryDomain'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      privateKeyPath: json['privateKeyPath'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      pushDir: json['pushDir'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      shell: json['shell'] as String? ?? '',
      skipDNS: json['skipDNS'] as bool? ?? false,
      startDate: json['startDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      websites: (json['websites'] as List<dynamic>?)?.map((e) => Website.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (acmeAccount != null) 'acmeAccount': acmeAccount!.toJson(),
      'acmeAccountId': acmeAccountId,
      'autoRenew': autoRenew,
      'caId': caId,
      'certPath': certPath,
      'certURL': certURL,
      'createdAt': createdAt,
      'description': description,
      'dir': dir,
      'disableCNAME': disableCNAME,
      if (dnsAccount != null) 'dnsAccount': dnsAccount!.toJson(),
      'dnsAccountId': dnsAccountId,
      'domains': domains,
      'execShell': execShell,
      'expireDate': expireDate,
      'id': id,
      'isIP': isIP,
      'keyType': keyType,
      'logPath': logPath,
      'masterSslId': masterSslId,
      'message': message,
      'nameserver1': nameserver1,
      'nameserver2': nameserver2,
      'nodes': nodes,
      'organization': organization,
      'pem': pem,
      'primaryDomain': primaryDomain,
      'privateKey': privateKey,
      'privateKeyPath': privateKeyPath,
      'provider': provider,
      'pushDir': pushDir,
      'pushNode': pushNode,
      'shell': shell,
      'skipDNS': skipDNS,
      'startDate': startDate,
      'status': status,
      'type': type,
      'updatedAt': updatedAt,
      'websites': websites.map((e) => e.toJson()).toList(),
  };
}

class WebsiteTemplateDTO {
  final String content;
  final String createdAt;
  final String filePath;
  final int id;
  final String name;
  final String remark;
  final String type;
  final String updatedAt;
  final String variables;

  const WebsiteTemplateDTO({
    this.content = '',
    this.createdAt = '',
    this.filePath = '',
    this.id = 0,
    this.name = '',
    this.remark = '',
    this.type = '',
    this.updatedAt = '',
    this.variables = '',
  });

  factory WebsiteTemplateDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateDTO(
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      filePath: json['filePath'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      variables: json['variables'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'createdAt': createdAt,
      'filePath': filePath,
      'id': id,
      'name': name,
      'remark': remark,
      'type': type,
      'updatedAt': updatedAt,
      'variables': variables,
  };
}

class WebsiteTemplateOutputDTO {
  final String createdAt;
  final int id;
  final String name;
  final String outputPath;
  final int templateID;
  final String templateName;
  final String templateType;
  final String updatedAt;
  final String variableValues;

  const WebsiteTemplateOutputDTO({
    this.createdAt = '',
    this.id = 0,
    this.name = '',
    this.outputPath = '',
    this.templateID = 0,
    this.templateName = '',
    this.templateType = '',
    this.updatedAt = '',
    this.variableValues = '',
  });

  factory WebsiteTemplateOutputDTO.fromJson(Map<String, dynamic> json) {
    return WebsiteTemplateOutputDTO(
      createdAt: json['createdAt'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      outputPath: json['outputPath'] as String? ?? '',
      templateID: (json['templateID'] as num?)?.toInt() ?? 0,
      templateName: json['templateName'] as String? ?? '',
      templateType: json['templateType'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      variableValues: json['variableValues'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'id': id,
      'name': name,
      'outputPath': outputPath,
      'templateID': templateID,
      'templateName': templateName,
      'templateType': templateType,
      'updatedAt': updatedAt,
      'variableValues': variableValues,
  };
}
