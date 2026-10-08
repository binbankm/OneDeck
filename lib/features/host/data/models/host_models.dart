// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class ChangeGroup {
  final int groupID;
  final int id;

  const ChangeGroup({
    this.groupID = 0,
    this.id = 0,
  });

  factory ChangeGroup.fromJson(Map<String, dynamic> json) {
    return ChangeGroup(
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'groupID': groupID,
      'id': id,
  };
}

class ChangePasswd {
  final String passwd;
  final String user;

  const ChangePasswd({
    this.passwd = '',
    this.user = '',
  });

  factory ChangePasswd.fromJson(Map<String, dynamic> json) {
    return ChangePasswd(
      passwd: json['passwd'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'passwd': passwd,
      'user': user,
  };
}

class Clean {
  final String name;
  final int size;
  final String treeType;

  const Clean({
    this.name = '',
    this.size = 0,
    this.treeType = '',
  });

  factory Clean.fromJson(Map<String, dynamic> json) {
    return Clean(
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      treeType: json['treeType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'size': size,
      'treeType': treeType,
  };
}

class CleanData {
  final List<CleanTree> backupClean;
  final List<CleanTree> containerClean;
  final List<CleanTree> downloadClean;
  final List<CleanTree> systemClean;
  final List<CleanTree> systemLogClean;
  final List<CleanTree> uploadClean;

  const CleanData({
    this.backupClean = const [],
    this.containerClean = const [],
    this.downloadClean = const [],
    this.systemClean = const [],
    this.systemLogClean = const [],
    this.uploadClean = const [],
  });

  factory CleanData.fromJson(Map<String, dynamic> json) {
    return CleanData(
      backupClean: (json['backupClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      containerClean: (json['containerClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      downloadClean: (json['downloadClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      systemClean: (json['systemClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      systemLogClean: (json['systemLogClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      uploadClean: (json['uploadClean'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'backupClean': backupClean.map((e) => e.toJson()).toList(),
      'containerClean': containerClean.map((e) => e.toJson()).toList(),
      'downloadClean': downloadClean.map((e) => e.toJson()).toList(),
      'systemClean': systemClean.map((e) => e.toJson()).toList(),
      'systemLogClean': systemLogClean.map((e) => e.toJson()).toList(),
      'uploadClean': uploadClean.map((e) => e.toJson()).toList(),
  };
}

class CleanTree {
  final bool canDelete;
  final List<CleanTree> children;
  final String id;
  final bool isCheck;
  final bool isRecommend;
  final String label;
  final String name;
  final int size;
  final String type;

  const CleanTree({
    this.canDelete = false,
    this.children = const [],
    this.id = '',
    this.isCheck = false,
    this.isRecommend = false,
    this.label = '',
    this.name = '',
    this.size = 0,
    this.type = '',
  });

  factory CleanTree.fromJson(Map<String, dynamic> json) {
    return CleanTree(
      canDelete: json['canDelete'] as bool? ?? false,
      children: (json['children'] as List<dynamic>?)?.map((e) => CleanTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: json['id'] as String? ?? '',
      isCheck: json['isCheck'] as bool? ?? false,
      isRecommend: json['isRecommend'] as bool? ?? false,
      label: json['label'] as String? ?? '',
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'canDelete': canDelete,
      'children': children.map((e) => e.toJson()).toList(),
      'id': id,
      'isCheck': isCheck,
      'isRecommend': isRecommend,
      'label': label,
      'name': name,
      'size': size,
      'type': type,
  };
}

class DeviceBaseInfo {
  final List<String> dns;
  final String hostname;
  final List<HostHelper> hosts;
  final String localTime;
  final int maxSize;
  final String ntp;
  final List<SwapHelper> swapDetails;
  final int swapMemoryAvailable;
  final int swapMemoryTotal;
  final int swapMemoryUsed;
  final String timeZone;
  final String user;

  const DeviceBaseInfo({
    this.dns = const [],
    this.hostname = '',
    this.hosts = const [],
    this.localTime = '',
    this.maxSize = 0,
    this.ntp = '',
    this.swapDetails = const [],
    this.swapMemoryAvailable = 0,
    this.swapMemoryTotal = 0,
    this.swapMemoryUsed = 0,
    this.timeZone = '',
    this.user = '',
  });

  factory DeviceBaseInfo.fromJson(Map<String, dynamic> json) {
    return DeviceBaseInfo(
      dns: (json['dns'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      hostname: json['hostname'] as String? ?? '',
      hosts: (json['hosts'] as List<dynamic>?)?.map((e) => HostHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      localTime: json['localTime'] as String? ?? '',
      maxSize: (json['maxSize'] as num?)?.toInt() ?? 0,
      ntp: json['ntp'] as String? ?? '',
      swapDetails: (json['swapDetails'] as List<dynamic>?)?.map((e) => SwapHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      swapMemoryAvailable: (json['swapMemoryAvailable'] as num?)?.toInt() ?? 0,
      swapMemoryTotal: (json['swapMemoryTotal'] as num?)?.toInt() ?? 0,
      swapMemoryUsed: (json['swapMemoryUsed'] as num?)?.toInt() ?? 0,
      timeZone: json['timeZone'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'dns': dns,
      'hostname': hostname,
      'hosts': hosts.map((e) => e.toJson()).toList(),
      'localTime': localTime,
      'maxSize': maxSize,
      'ntp': ntp,
      'swapDetails': swapDetails.map((e) => e.toJson()).toList(),
      'swapMemoryAvailable': swapMemoryAvailable,
      'swapMemoryTotal': swapMemoryTotal,
      'swapMemoryUsed': swapMemoryUsed,
      'timeZone': timeZone,
      'user': user,
  };
}

class DiskInfo {
  final String device;
  final int free;
  final int inodesFree;
  final int inodesTotal;
  final int inodesUsed;
  final double inodesUsedPercent;
  final String path;
  final int total;
  final String type;
  final int used;
  final double usedPercent;

  const DiskInfo({
    this.device = '',
    this.free = 0,
    this.inodesFree = 0,
    this.inodesTotal = 0,
    this.inodesUsed = 0,
    this.inodesUsedPercent = 0.0,
    this.path = '',
    this.total = 0,
    this.type = '',
    this.used = 0,
    this.usedPercent = 0.0,
  });

  factory DiskInfo.fromJson(Map<String, dynamic> json) {
    return DiskInfo(
      device: json['device'] as String? ?? '',
      free: (json['free'] as num?)?.toInt() ?? 0,
      inodesFree: (json['inodesFree'] as num?)?.toInt() ?? 0,
      inodesTotal: (json['inodesTotal'] as num?)?.toInt() ?? 0,
      inodesUsed: (json['inodesUsed'] as num?)?.toInt() ?? 0,
      inodesUsedPercent: (json['inodesUsedPercent'] as num?)?.toDouble() ?? 0.0,
      path: json['path'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      used: (json['used'] as num?)?.toInt() ?? 0,
      usedPercent: (json['usedPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
      'device': device,
      'free': free,
      'inodesFree': inodesFree,
      'inodesTotal': inodesTotal,
      'inodesUsed': inodesUsed,
      'inodesUsedPercent': inodesUsedPercent,
      'path': path,
      'total': total,
      'type': type,
      'used': used,
      'usedPercent': usedPercent,
  };
}

class DockerPortGuardBase {
  final String backend;
  final bool bound;
  final bool initialized;
  final DockerPortGuardFamilyStatus? ipv4;
  final DockerPortGuardFamilyStatus? ipv6;
  final String message;
  final String name;

  const DockerPortGuardBase({
    this.backend = '',
    this.bound = false,
    this.initialized = false,
    this.ipv4,
    this.ipv6,
    this.message = '',
    this.name = '',
  });

  factory DockerPortGuardBase.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardBase(
      backend: json['backend'] as String? ?? '',
      bound: json['bound'] as bool? ?? false,
      initialized: json['initialized'] as bool? ?? false,
      ipv4: json['ipv4'] != null ? DockerPortGuardFamilyStatus.fromJson(json['ipv4'] as Map<String, dynamic>) : null,
      ipv6: json['ipv6'] != null ? DockerPortGuardFamilyStatus.fromJson(json['ipv6'] as Map<String, dynamic>) : null,
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backend': backend,
      'bound': bound,
      'initialized': initialized,
      if (ipv4 != null) 'ipv4': ipv4!.toJson(),
      if (ipv6 != null) 'ipv6': ipv6!.toJson(),
      'message': message,
      'name': name,
  };
}

class DockerPortGuardContainer {
  final String application;
  final String compose;
  final List<DockerPortGuardEndpoint> endpoints;
  final String key;
  final String name;
  final List<DockerPortGuardPortGroup> portGroups;

  const DockerPortGuardContainer({
    this.application = '',
    this.compose = '',
    this.endpoints = const [],
    this.key = '',
    this.name = '',
    this.portGroups = const [],
  });

  factory DockerPortGuardContainer.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardContainer(
      application: json['application'] as String? ?? '',
      compose: json['compose'] as String? ?? '',
      endpoints: (json['endpoints'] as List<dynamic>?)?.map((e) => DockerPortGuardEndpoint.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      portGroups: (json['portGroups'] as List<dynamic>?)?.map((e) => DockerPortGuardPortGroup.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'application': application,
      'compose': compose,
      'endpoints': endpoints.map((e) => e.toJson()).toList(),
      'key': key,
      'name': name,
      'portGroups': portGroups.map((e) => e.toJson()).toList(),
  };
}

class DockerPortGuardEndpoint {
  final String application;
  final String compose;
  final String containerID;
  final String containerName;
  final int containerPort;
  final String description;
  final bool effective;
  final String family;
  final String hostIP;
  final int hostPort;
  final String mode;
  final String policyUUID;
  final String protocol;
  final List<String> sources;

  const DockerPortGuardEndpoint({
    this.application = '',
    this.compose = '',
    this.containerID = '',
    this.containerName = '',
    this.containerPort = 0,
    this.description = '',
    this.effective = false,
    this.family = '',
    this.hostIP = '',
    this.hostPort = 0,
    this.mode = '',
    this.policyUUID = '',
    this.protocol = '',
    this.sources = const [],
  });

  factory DockerPortGuardEndpoint.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardEndpoint(
      application: json['application'] as String? ?? '',
      compose: json['compose'] as String? ?? '',
      containerID: json['containerID'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      containerPort: (json['containerPort'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      effective: json['effective'] as bool? ?? false,
      family: json['family'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      hostPort: (json['hostPort'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? '',
      policyUUID: json['policyUUID'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'application': application,
      'compose': compose,
      'containerID': containerID,
      'containerName': containerName,
      'containerPort': containerPort,
      'description': description,
      'effective': effective,
      'family': family,
      'hostIP': hostIP,
      'hostPort': hostPort,
      'mode': mode,
      'policyUUID': policyUUID,
      'protocol': protocol,
      'sources': sources,
  };
}

class DockerPortGuardFamilyStatus {
  final bool bound;
  final bool effective;
  final bool initialized;
  final String reason;
  final String state;

  const DockerPortGuardFamilyStatus({
    this.bound = false,
    this.effective = false,
    this.initialized = false,
    this.reason = '',
    this.state = '',
  });

  factory DockerPortGuardFamilyStatus.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardFamilyStatus(
      bound: json['bound'] as bool? ?? false,
      effective: json['effective'] as bool? ?? false,
      initialized: json['initialized'] as bool? ?? false,
      reason: json['reason'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'bound': bound,
      'effective': effective,
      'initialized': initialized,
      'reason': reason,
      'state': state,
  };
}

class DockerPortGuardList {
  final DockerPortGuardBase? base;
  final List<DockerPortGuardContainer> containers;

  const DockerPortGuardList({
    this.base,
    this.containers = const [],
  });

  factory DockerPortGuardList.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardList(
      base: json['base'] != null ? DockerPortGuardBase.fromJson(json['base'] as Map<String, dynamic>) : null,
      containers: (json['containers'] as List<dynamic>?)?.map((e) => DockerPortGuardContainer.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (base != null) 'base': base!.toJson(),
      'containers': containers.map((e) => e.toJson()).toList(),
  };
}

class DockerPortGuardOperation {
  final String operation;
  final String taskID;

  const DockerPortGuardOperation({
    this.operation = '',
    this.taskID = '',
  });

  factory DockerPortGuardOperation.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardOperation(
      operation: json['operation'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
      'taskID': taskID,
  };
}

class DockerPortGuardPolicy {
  final String description;
  final String family;
  final String hostIP;
  final int hostPort;
  final String mode;
  final String protocol;
  final List<String> sources;

  const DockerPortGuardPolicy({
    this.description = '',
    this.family = '',
    this.hostIP = '',
    this.hostPort = 0,
    this.mode = '',
    this.protocol = '',
    this.sources = const [],
  });

  factory DockerPortGuardPolicy.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardPolicy(
      description: json['description'] as String? ?? '',
      family: json['family'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      hostPort: (json['hostPort'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'family': family,
      'hostIP': hostIP,
      'hostPort': hostPort,
      'mode': mode,
      'protocol': protocol,
      'sources': sources,
  };
}

class DockerPortGuardPolicyBatch {
  final List<DockerPortGuardPolicy> policies;

  const DockerPortGuardPolicyBatch({
    this.policies = const [],
  });

  factory DockerPortGuardPolicyBatch.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardPolicyBatch(
      policies: (json['policies'] as List<dynamic>?)?.map((e) => DockerPortGuardPolicy.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'policies': policies.map((e) => e.toJson()).toList(),
  };
}

class DockerPortGuardPolicyBatchDelete {
  final List<String> uuids;

  const DockerPortGuardPolicyBatchDelete({
    this.uuids = const [],
  });

  factory DockerPortGuardPolicyBatchDelete.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardPolicyBatchDelete(
      uuids: (json['uuids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'uuids': uuids,
  };
}

class DockerPortGuardPortGroup {
  final DockerPortGuardEndpoint? endpoint;
  final List<DockerPortGuardEndpoint> endpoints;
  final String key;
  final String label;

  const DockerPortGuardPortGroup({
    this.endpoint,
    this.endpoints = const [],
    this.key = '',
    this.label = '',
  });

  factory DockerPortGuardPortGroup.fromJson(Map<String, dynamic> json) {
    return DockerPortGuardPortGroup(
      endpoint: json['endpoint'] != null ? DockerPortGuardEndpoint.fromJson(json['endpoint'] as Map<String, dynamic>) : null,
      endpoints: (json['endpoints'] as List<dynamic>?)?.map((e) => DockerPortGuardEndpoint.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (endpoint != null) 'endpoint': endpoint!.toJson(),
      'endpoints': endpoints.map((e) => e.toJson()).toList(),
      'key': key,
      'label': label,
  };
}

class FilePath {
  final String path;

  const FilePath({
    this.path = '',
  });

  factory FilePath.fromJson(Map<String, dynamic> json) {
    return FilePath(
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
  };
}

class FilterChainOperation {
  final String name;
  final String operate;
  final String taskID;

  const FilterChainOperation({
    this.name = '',
    this.operate = '',
    this.taskID = '',
  });

  factory FilterChainOperation.fromJson(Map<String, dynamic> json) {
    return FilterChainOperation(
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'operate': operate,
      'taskID': taskID,
  };
}

class FilterChainOperationResponse {
  final bool queued;
  final String taskID;

  const FilterChainOperationResponse({
    this.queued = false,
    this.taskID = '',
  });

  factory FilterChainOperationResponse.fromJson(Map<String, dynamic> json) {
    return FilterChainOperationResponse(
      queued: json['queued'] as bool? ?? false,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'queued': queued,
      'taskID': taskID,
  };
}

class FirewallBackendFamilyStatus {
  final bool bound;
  final bool initialized;

  const FirewallBackendFamilyStatus({
    this.bound = false,
    this.initialized = false,
  });

  factory FirewallBackendFamilyStatus.fromJson(Map<String, dynamic> json) {
    return FirewallBackendFamilyStatus(
      bound: json['bound'] as bool? ?? false,
      initialized: json['initialized'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'bound': bound,
      'initialized': initialized,
  };
}

class FirewallBackendGroup {
  final String current;
  final List<FirewallBackendOption> options;
  final String selected;

  const FirewallBackendGroup({
    this.current = '',
    this.options = const [],
    this.selected = '',
  });

  factory FirewallBackendGroup.fromJson(Map<String, dynamic> json) {
    return FirewallBackendGroup(
      current: json['current'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => FirewallBackendOption.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      selected: json['selected'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'current': current,
      'options': options.map((e) => e.toJson()).toList(),
      'selected': selected,
  };
}

class FirewallBackendOperation {
  final String backend;
  final String operation;
  final String subsystem;

  const FirewallBackendOperation({
    this.backend = '',
    this.operation = '',
    this.subsystem = '',
  });

  factory FirewallBackendOperation.fromJson(Map<String, dynamic> json) {
    return FirewallBackendOperation(
      backend: json['backend'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      subsystem: json['subsystem'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backend': backend,
      'operation': operation,
      'subsystem': subsystem,
  };
}

class FirewallBackendOption {
  final bool active;
  final bool bound;
  final String implementation;
  final bool initialized;
  final bool installed;
  final FirewallBackendFamilyStatus? ipv4;
  final FirewallBackendFamilyStatus? ipv6;
  final String message;
  final String name;
  final bool supported;

  const FirewallBackendOption({
    this.active = false,
    this.bound = false,
    this.implementation = '',
    this.initialized = false,
    this.installed = false,
    this.ipv4,
    this.ipv6,
    this.message = '',
    this.name = '',
    this.supported = false,
  });

  factory FirewallBackendOption.fromJson(Map<String, dynamic> json) {
    return FirewallBackendOption(
      active: json['active'] as bool? ?? false,
      bound: json['bound'] as bool? ?? false,
      implementation: json['implementation'] as String? ?? '',
      initialized: json['initialized'] as bool? ?? false,
      installed: json['installed'] as bool? ?? false,
      ipv4: json['ipv4'] != null ? FirewallBackendFamilyStatus.fromJson(json['ipv4'] as Map<String, dynamic>) : null,
      ipv6: json['ipv6'] != null ? FirewallBackendFamilyStatus.fromJson(json['ipv6'] as Map<String, dynamic>) : null,
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
      supported: json['supported'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'active': active,
      'bound': bound,
      'implementation': implementation,
      'initialized': initialized,
      'installed': installed,
      if (ipv4 != null) 'ipv4': ipv4!.toJson(),
      if (ipv6 != null) 'ipv6': ipv6!.toJson(),
      'message': message,
      'name': name,
      'supported': supported,
  };
}

class FirewallInitializationTask {
  final String taskID;

  const FirewallInitializationTask({
    this.taskID = '',
  });

  factory FirewallInitializationTask.fromJson(Map<String, dynamic> json) {
    return FirewallInitializationTask(
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'taskID': taskID,
  };
}

class FirewallLifecycleOperation {
  final String operation;
  final bool withDockerRestart;

  const FirewallLifecycleOperation({
    this.operation = '',
    this.withDockerRestart = false,
  });

  factory FirewallLifecycleOperation.fromJson(Map<String, dynamic> json) {
    return FirewallLifecycleOperation(
      operation: json['operation'] as String? ?? '',
      withDockerRestart: json['withDockerRestart'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
      'withDockerRestart': withDockerRestart,
  };
}

class FirewallNativeDetail {
  final String name;
  final dynamic nativeKind;
  final bool permanent;
  final String provider;

  const FirewallNativeDetail({
    this.name = '',
    this.nativeKind,
    this.permanent = false,
    this.provider = '',
  });

  factory FirewallNativeDetail.fromJson(Map<String, dynamic> json) {
    return FirewallNativeDetail(
      name: json['name'] as String? ?? '',
      nativeKind: json['nativeKind'],
      permanent: json['permanent'] as bool? ?? false,
      provider: json['provider'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'nativeKind': nativeKind,
      'permanent': permanent,
      'provider': provider,
  };
}

class FirewallPortWhitelistCreate {
  final PortWhitelist? rule;

  const FirewallPortWhitelistCreate({
    this.rule,
  });

  factory FirewallPortWhitelistCreate.fromJson(Map<String, dynamic> json) {
    return FirewallPortWhitelistCreate(
      rule: json['rule'] != null ? PortWhitelist.fromJson(json['rule'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (rule != null) 'rule': rule!.toJson(),
  };
}

class FirewallPortWhitelistDelete {
  final PortWhitelist? rule;

  const FirewallPortWhitelistDelete({
    this.rule,
  });

  factory FirewallPortWhitelistDelete.fromJson(Map<String, dynamic> json) {
    return FirewallPortWhitelistDelete(
      rule: json['rule'] != null ? PortWhitelist.fromJson(json['rule'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (rule != null) 'rule': rule!.toJson(),
  };
}

class FirewallPortWhitelistUpdate {
  final PortWhitelist? oldRule;
  final PortWhitelist? rule;

  const FirewallPortWhitelistUpdate({
    this.oldRule,
    this.rule,
  });

  factory FirewallPortWhitelistUpdate.fromJson(Map<String, dynamic> json) {
    return FirewallPortWhitelistUpdate(
      oldRule: json['oldRule'] != null ? PortWhitelist.fromJson(json['oldRule'] as Map<String, dynamic>) : null,
      rule: json['rule'] != null ? PortWhitelist.fromJson(json['rule'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (oldRule != null) 'oldRule': oldRule!.toJson(),
      if (rule != null) 'rule': rule!.toJson(),
  };
}

class FirewallRuleAdopt {
  final Scope? scope;
  final String instanceKey;

  const FirewallRuleAdopt({
    this.scope,
    this.instanceKey = '',
  });

  factory FirewallRuleAdopt.fromJson(Map<String, dynamic> json) {
    return FirewallRuleAdopt(
      scope: json['scope'] != null ? Scope.fromJson(json['scope'] as Map<String, dynamic>) : null,
      instanceKey: json['instanceKey'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (scope != null) 'scope': scope!.toJson(),
      'instanceKey': instanceKey,
  };
}

class FirewallRuleCreate {
  final List<FirewallRuleCreateItem> items;

  const FirewallRuleCreate({
    this.items = const [],
  });

  factory FirewallRuleCreate.fromJson(Map<String, dynamic> json) {
    return FirewallRuleCreate(
      items: (json['items'] as List<dynamic>?)?.map((e) => FirewallRuleCreateItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items.map((e) => e.toJson()).toList(),
  };
}

class FirewallRuleCreateFailure {
  final String error;
  final int index;
  final FirewallRule? rule;
  final String status;

  const FirewallRuleCreateFailure({
    this.error = '',
    this.index = 0,
    this.rule,
    this.status = '',
  });

  factory FirewallRuleCreateFailure.fromJson(Map<String, dynamic> json) {
    return FirewallRuleCreateFailure(
      error: json['error'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'error': error,
      'index': index,
      if (rule != null) 'rule': rule!.toJson(),
      'status': status,
  };
}

class FirewallRuleCreateItem {
  final FirewallRule? rule;
  final String sourceID;
  final String sourceKind;

  const FirewallRuleCreateItem({
    this.rule,
    this.sourceID = '',
    this.sourceKind = '',
  });

  factory FirewallRuleCreateItem.fromJson(Map<String, dynamic> json) {
    return FirewallRuleCreateItem(
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
      sourceID: json['sourceID'] as String? ?? '',
      sourceKind: json['sourceKind'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (rule != null) 'rule': rule!.toJson(),
      'sourceID': sourceID,
      'sourceKind': sourceKind,
  };
}

class FirewallRuleCreateResponse {
  final List<FirewallRuleCreateFailure> errors;
  final int failed;
  final bool queued;
  final int skipped;
  final int succeeded;
  final String taskID;

  const FirewallRuleCreateResponse({
    this.errors = const [],
    this.failed = 0,
    this.queued = false,
    this.skipped = 0,
    this.succeeded = 0,
    this.taskID = '',
  });

  factory FirewallRuleCreateResponse.fromJson(Map<String, dynamic> json) {
    return FirewallRuleCreateResponse(
      errors: (json['errors'] as List<dynamic>?)?.map((e) => FirewallRuleCreateFailure.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      queued: json['queued'] as bool? ?? false,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
      succeeded: (json['succeeded'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'errors': errors.map((e) => e.toJson()).toList(),
      'failed': failed,
      'queued': queued,
      'skipped': skipped,
      'succeeded': succeeded,
      'taskID': taskID,
  };
}

class FirewallRuleDelete {
  final List<FirewallRuleDeleteTarget> beforeRules;
  final List<String> uuids;

  const FirewallRuleDelete({
    this.beforeRules = const [],
    this.uuids = const [],
  });

  factory FirewallRuleDelete.fromJson(Map<String, dynamic> json) {
    return FirewallRuleDelete(
      beforeRules: (json['beforeRules'] as List<dynamic>?)?.map((e) => FirewallRuleDeleteTarget.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      uuids: (json['uuids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'beforeRules': beforeRules.map((e) => e.toJson()).toList(),
      'uuids': uuids,
  };
}

class FirewallRuleDeleteFailure {
  final String error;
  final int index;
  final String uuid;

  const FirewallRuleDeleteFailure({
    this.error = '',
    this.index = 0,
    this.uuid = '',
  });

  factory FirewallRuleDeleteFailure.fromJson(Map<String, dynamic> json) {
    return FirewallRuleDeleteFailure(
      error: json['error'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'error': error,
      'index': index,
      'uuid': uuid,
  };
}

class FirewallRuleDeleteResponse {
  final List<FirewallRuleDeleteFailure> errors;
  final int failed;
  final bool queued;
  final int succeeded;
  final String taskID;

  const FirewallRuleDeleteResponse({
    this.errors = const [],
    this.failed = 0,
    this.queued = false,
    this.succeeded = 0,
    this.taskID = '',
  });

  factory FirewallRuleDeleteResponse.fromJson(Map<String, dynamic> json) {
    return FirewallRuleDeleteResponse(
      errors: (json['errors'] as List<dynamic>?)?.map((e) => FirewallRuleDeleteFailure.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      queued: json['queued'] as bool? ?? false,
      succeeded: (json['succeeded'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'errors': errors.map((e) => e.toJson()).toList(),
      'failed': failed,
      'queued': queued,
      'succeeded': succeeded,
      'taskID': taskID,
  };
}

class FirewallRuleDeleteTarget {
  final String instanceKey;
  final Scope? scope;

  const FirewallRuleDeleteTarget({
    this.instanceKey = '',
    this.scope,
  });

  factory FirewallRuleDeleteTarget.fromJson(Map<String, dynamic> json) {
    return FirewallRuleDeleteTarget(
      instanceKey: json['instanceKey'] as String? ?? '',
      scope: json['scope'] != null ? Scope.fromJson(json['scope'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      'instanceKey': instanceKey,
      if (scope != null) 'scope': scope!.toJson(),
  };
}

class FirewallRuleInventory {
  final List<String> actions;
  final bool all;
  final List<String> excludeChains;
  final List<String> families;
  final String info;
  final int page;
  final int pageSize;
  final Scope? scope;
  final List<Scope> scopes;
  final List<String> states;

  const FirewallRuleInventory({
    this.actions = const [],
    this.all = false,
    this.excludeChains = const [],
    this.families = const [],
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
    this.scope,
    this.scopes = const [],
    this.states = const [],
  });

  factory FirewallRuleInventory.fromJson(Map<String, dynamic> json) {
    return FirewallRuleInventory(
      actions: (json['actions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      all: json['all'] as bool? ?? false,
      excludeChains: (json['excludeChains'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      families: (json['families'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      scope: json['scope'] != null ? Scope.fromJson(json['scope'] as Map<String, dynamic>) : null,
      scopes: (json['scopes'] as List<dynamic>?)?.map((e) => Scope.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      states: (json['states'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'actions': actions,
      'all': all,
      'excludeChains': excludeChains,
      'families': families,
      'info': info,
      'page': page,
      'pageSize': pageSize,
      if (scope != null) 'scope': scope!.toJson(),
      'scopes': scopes.map((e) => e.toJson()).toList(),
      'states': states,
  };
}

class FirewallRuleInventoryResponse {
  final int allTotal;
  final List<InventoryItem> items;
  final int managedTotal;
  final List<ScopeNotice> notices;
  final int total;

  const FirewallRuleInventoryResponse({
    this.allTotal = 0,
    this.items = const [],
    this.managedTotal = 0,
    this.notices = const [],
    this.total = 0,
  });

  factory FirewallRuleInventoryResponse.fromJson(Map<String, dynamic> json) {
    return FirewallRuleInventoryResponse(
      allTotal: (json['allTotal'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      managedTotal: (json['managedTotal'] as num?)?.toInt() ?? 0,
      notices: (json['notices'] as List<dynamic>?)?.map((e) => ScopeNotice.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'allTotal': allTotal,
      'items': items.map((e) => e.toJson()).toList(),
      'managedTotal': managedTotal,
      'notices': notices.map((e) => e.toJson()).toList(),
      'total': total,
  };
}

class FirewallRuleReorder {
  final int priority;
  final int targetPosition;
  final String uuid;

  const FirewallRuleReorder({
    this.priority = 0,
    this.targetPosition = 0,
    this.uuid = '',
  });

  factory FirewallRuleReorder.fromJson(Map<String, dynamic> json) {
    return FirewallRuleReorder(
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      targetPosition: (json['targetPosition'] as num?)?.toInt() ?? 0,
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'priority': priority,
      'targetPosition': targetPosition,
      'uuid': uuid,
  };
}

class FirewallRuleUpdate {
  final FirewallRule? rule;
  final String uuid;

  const FirewallRuleUpdate({
    this.rule,
    this.uuid = '',
  });

  factory FirewallRuleUpdate.fromJson(Map<String, dynamic> json) {
    return FirewallRuleUpdate(
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (rule != null) 'rule': rule!.toJson(),
      'uuid': uuid,
  };
}

class FirewallSettings {
  final FirewallBackendGroup? docker;
  final FirewallBackendGroup? forwarding;
  final String panelPort;
  final String pingStatus;
  final List<PortWhitelist> portWhiteList;
  final String sshPort;
  final FirewallBackendGroup? system;

  const FirewallSettings({
    this.docker,
    this.forwarding,
    this.panelPort = '',
    this.pingStatus = '',
    this.portWhiteList = const [],
    this.sshPort = '',
    this.system,
  });

  factory FirewallSettings.fromJson(Map<String, dynamic> json) {
    return FirewallSettings(
      docker: json['docker'] != null ? FirewallBackendGroup.fromJson(json['docker'] as Map<String, dynamic>) : null,
      forwarding: json['forwarding'] != null ? FirewallBackendGroup.fromJson(json['forwarding'] as Map<String, dynamic>) : null,
      panelPort: json['panelPort'] as String? ?? '',
      pingStatus: json['pingStatus'] as String? ?? '',
      portWhiteList: (json['portWhiteList'] as List<dynamic>?)?.map((e) => PortWhitelist.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      sshPort: json['sshPort'] as String? ?? '',
      system: json['system'] != null ? FirewallBackendGroup.fromJson(json['system'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (docker != null) 'docker': docker!.toJson(),
      if (forwarding != null) 'forwarding': forwarding!.toJson(),
      'panelPort': panelPort,
      'pingStatus': pingStatus,
      'portWhiteList': portWhiteList.map((e) => e.toJson()).toList(),
      'sshPort': sshPort,
      if (system != null) 'system': system!.toJson(),
  };
}

class FirewallSubsystemStatus {
  final String backend;
  final bool isActive;
  final bool isBind;
  final bool isExist;
  final bool isInit;
  final String name;
  final String pingStatus;
  final String syncError;
  final String version;

  const FirewallSubsystemStatus({
    this.backend = '',
    this.isActive = false,
    this.isBind = false,
    this.isExist = false,
    this.isInit = false,
    this.name = '',
    this.pingStatus = '',
    this.syncError = '',
    this.version = '',
  });

  factory FirewallSubsystemStatus.fromJson(Map<String, dynamic> json) {
    return FirewallSubsystemStatus(
      backend: json['backend'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isBind: json['isBind'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
      isInit: json['isInit'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      pingStatus: json['pingStatus'] as String? ?? '',
      syncError: json['syncError'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backend': backend,
      'isActive': isActive,
      'isBind': isBind,
      'isExist': isExist,
      'isInit': isInit,
      'name': name,
      'pingStatus': pingStatus,
      'syncError': syncError,
      'version': version,
  };
}

class ForceDelete {
  final bool forceDelete;
  final List<int> ids;

  const ForceDelete({
    this.forceDelete = false,
    this.ids = const [],
  });

  factory ForceDelete.fromJson(Map<String, dynamic> json) {
    return ForceDelete(
      forceDelete: json['forceDelete'] as bool? ?? false,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'forceDelete': forceDelete,
      'ids': ids,
  };
}

class ForwardRuleOperate {
  final bool forceDelete;
  final List<ForwardRuleOperation> rules;

  const ForwardRuleOperate({
    this.forceDelete = false,
    this.rules = const [],
  });

  factory ForwardRuleOperate.fromJson(Map<String, dynamic> json) {
    return ForwardRuleOperate(
      forceDelete: json['forceDelete'] as bool? ?? false,
      rules: (json['rules'] as List<dynamic>?)?.map((e) => ForwardRuleOperation.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'forceDelete': forceDelete,
      'rules': rules.map((e) => e.toJson()).toList(),
  };
}

class ForwardRuleOperation {
  final String family;
  final String interface;
  final String num;
  final String operation;
  final String port;
  final String protocol;
  final String targetIP;
  final String targetPort;

  const ForwardRuleOperation({
    this.family = '',
    this.interface = '',
    this.num = '',
    this.operation = '',
    this.port = '',
    this.protocol = '',
    this.targetIP = '',
    this.targetPort = '',
  });

  factory ForwardRuleOperation.fromJson(Map<String, dynamic> json) {
    return ForwardRuleOperation(
      family: json['family'] as String? ?? '',
      interface: json['interface'] as String? ?? '',
      num: json['num'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      port: json['port'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      targetIP: json['targetIP'] as String? ?? '',
      targetPort: json['targetPort'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'family': family,
      'interface': interface,
      'num': num,
      'operation': operation,
      'port': port,
      'protocol': protocol,
      'targetIP': targetIP,
      'targetPort': targetPort,
  };
}

class ForwardRuleSearch {
  final String info;
  final int page;
  final int pageSize;
  final String status;
  final String strategy;

  const ForwardRuleSearch({
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
    this.status = '',
    this.strategy = '',
  });

  factory ForwardRuleSearch.fromJson(Map<String, dynamic> json) {
    return ForwardRuleSearch(
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      strategy: json['strategy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'info': info,
      'page': page,
      'pageSize': pageSize,
      'status': status,
      'strategy': strategy,
  };
}

class HostConnTest {
  final String addr;
  final String authMode;
  final String passPhrase;
  final String password;
  final int port;
  final String privateKey;
  final String user;

  const HostConnTest({
    this.addr = '',
    this.authMode = '',
    this.passPhrase = '',
    this.password = '',
    this.port = 0,
    this.privateKey = '',
    this.user = '',
  });

  factory HostConnTest.fromJson(Map<String, dynamic> json) {
    return HostConnTest(
      addr: json['addr'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      passPhrase: json['passPhrase'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      privateKey: json['privateKey'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'addr': addr,
      'authMode': authMode,
      'passPhrase': passPhrase,
      'password': password,
      'port': port,
      'privateKey': privateKey,
      'user': user,
  };
}

class HostHelper {
  final String host;
  final String ip;

  const HostHelper({
    this.host = '',
    this.ip = '',
  });

  factory HostHelper.fromJson(Map<String, dynamic> json) {
    return HostHelper(
      host: json['host'] as String? ?? '',
      ip: json['ip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'host': host,
      'ip': ip,
  };
}

class HostOperate {
  final String addr;
  final String authMode;
  final String description;
  final int groupID;
  final int id;
  final String name;
  final String passPhrase;
  final String password;
  final int port;
  final String privateKey;
  final bool rememberPassword;
  final String user;

  const HostOperate({
    this.addr = '',
    this.authMode = '',
    this.description = '',
    this.groupID = 0,
    this.id = 0,
    this.name = '',
    this.passPhrase = '',
    this.password = '',
    this.port = 0,
    this.privateKey = '',
    this.rememberPassword = false,
    this.user = '',
  });

  factory HostOperate.fromJson(Map<String, dynamic> json) {
    return HostOperate(
      addr: json['addr'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      description: json['description'] as String? ?? '',
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      passPhrase: json['passPhrase'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      privateKey: json['privateKey'] as String? ?? '',
      rememberPassword: json['rememberPassword'] as bool? ?? false,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'addr': addr,
      'authMode': authMode,
      'description': description,
      'groupID': groupID,
      'id': id,
      'name': name,
      'passPhrase': passPhrase,
      'password': password,
      'port': port,
      'privateKey': privateKey,
      'rememberPassword': rememberPassword,
      'user': user,
  };
}

class Operate {
  final String operation;

  const Operate({
    this.operation = '',
  });

  factory Operate.fromJson(Map<String, dynamic> json) {
    return Operate(
      operation: json['operation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
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

class OperateByIDs {
  final List<int> ids;

  const OperateByIDs({
    this.ids = const [],
  });

  factory OperateByIDs.fromJson(Map<String, dynamic> json) {
    return OperateByIDs(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class OperationWithName {
  final String name;

  const OperationWithName({
    this.name = '',
  });

  factory OperationWithName.fromJson(Map<String, dynamic> json) {
    return OperationWithName(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
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

class Response {
  final int code;
  final dynamic data;
  final String errorCode;
  final String message;

  const Response({
    this.code = 0,
    this.data,
    this.errorCode = '',
    this.message = '',
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      code: (json['code'] as num?)?.toInt() ?? 0,
      data: json['data'],
      errorCode: json['errorCode'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'code': code,
      'data': data,
      'errorCode': errorCode,
      'message': message,
  };
}

class RootCertOperate {
  final String description;
  final String encryptionMode;
  final int id;
  final String mode;
  final String name;
  final String passPhrase;
  final String privateKey;
  final String publicKey;

  const RootCertOperate({
    this.description = '',
    this.encryptionMode = '',
    this.id = 0,
    this.mode = '',
    this.name = '',
    this.passPhrase = '',
    this.privateKey = '',
    this.publicKey = '',
  });

  factory RootCertOperate.fromJson(Map<String, dynamic> json) {
    return RootCertOperate(
      description: json['description'] as String? ?? '',
      encryptionMode: json['encryptionMode'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      passPhrase: json['passPhrase'] as String? ?? '',
      privateKey: json['privateKey'] as String? ?? '',
      publicKey: json['publicKey'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'encryptionMode': encryptionMode,
      'id': id,
      'mode': mode,
      'name': name,
      'passPhrase': passPhrase,
      'privateKey': privateKey,
      'publicKey': publicKey,
  };
}

class SSHConfUpdate {
  final String key;
  final String path;
  final String value;

  const SSHConfUpdate({
    this.key = '',
    this.path = '',
    this.value = '',
  });

  factory SSHConfUpdate.fromJson(Map<String, dynamic> json) {
    return SSHConfUpdate(
      key: json['key'] as String? ?? '',
      path: json['path'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'path': path,
      'value': value,
  };
}

class SSHInfo {
  final bool autoStart;
  final String currentUser;
  final bool isActive;
  final bool isExist;
  final String listenAddress;
  final String message;
  final String passwordAuthentication;
  final String permitRootLogin;
  final String port;
  final String pubkeyAuthentication;
  final String useDNS;

  const SSHInfo({
    this.autoStart = false,
    this.currentUser = '',
    this.isActive = false,
    this.isExist = false,
    this.listenAddress = '',
    this.message = '',
    this.passwordAuthentication = '',
    this.permitRootLogin = '',
    this.port = '',
    this.pubkeyAuthentication = '',
    this.useDNS = '',
  });

  factory SSHInfo.fromJson(Map<String, dynamic> json) {
    return SSHInfo(
      autoStart: json['autoStart'] as bool? ?? false,
      currentUser: json['currentUser'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
      listenAddress: json['listenAddress'] as String? ?? '',
      message: json['message'] as String? ?? '',
      passwordAuthentication: json['passwordAuthentication'] as String? ?? '',
      permitRootLogin: json['permitRootLogin'] as String? ?? '',
      port: json['port'] as String? ?? '',
      pubkeyAuthentication: json['pubkeyAuthentication'] as String? ?? '',
      useDNS: json['useDNS'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoStart': autoStart,
      'currentUser': currentUser,
      'isActive': isActive,
      'isExist': isExist,
      'listenAddress': listenAddress,
      'message': message,
      'passwordAuthentication': passwordAuthentication,
      'permitRootLogin': permitRootLogin,
      'port': port,
      'pubkeyAuthentication': pubkeyAuthentication,
      'useDNS': useDNS,
  };
}

class SSHUpdate {
  final String key;
  final String newValue;

  const SSHUpdate({
    this.key = '',
    this.newValue = '',
  });

  factory SSHUpdate.fromJson(Map<String, dynamic> json) {
    return SSHUpdate(
      key: json['key'] as String? ?? '',
      newValue: json['newValue'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'newValue': newValue,
  };
}

class SearchForTree {
  final String info;

  const SearchForTree({
    this.info = '',
  });

  factory SearchForTree.fromJson(Map<String, dynamic> json) {
    return SearchForTree(
      info: json['info'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'info': info,
  };
}

class SearchPageWithGroup {
  final int groupID;
  final String info;
  final int page;
  final int pageSize;

  const SearchPageWithGroup({
    this.groupID = 0,
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory SearchPageWithGroup.fromJson(Map<String, dynamic> json) {
    return SearchPageWithGroup(
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'groupID': groupID,
      'info': info,
      'page': page,
      'pageSize': pageSize,
  };
}

class SearchSSHLog {
  final String status;
  final String endTime;
  final String info;
  final int page;
  final int pageSize;
  final String startTime;

  const SearchSSHLog({
    this.status = '',
    this.endTime = '',
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
    this.startTime = '',
  });

  factory SearchSSHLog.fromJson(Map<String, dynamic> json) {
    return SearchSSHLog(
      status: json['Status'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'Status': status,
      'endTime': endTime,
      'info': info,
      'page': page,
      'pageSize': pageSize,
      'startTime': startTime,
  };
}

class SearchWithPage {
  final bool excludeAppStore;
  final String info;
  final int page;
  final int pageSize;

  const SearchWithPage({
    this.excludeAppStore = false,
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory SearchWithPage.fromJson(Map<String, dynamic> json) {
    return SearchWithPage(
      excludeAppStore: json['excludeAppStore'] as bool? ?? false,
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'excludeAppStore': excludeAppStore,
      'info': info,
      'page': page,
      'pageSize': pageSize,
  };
}

class SettingUpdate {
  final String key;
  final String value;

  const SettingUpdate({
    this.key = '',
    this.value = '',
  });

  factory SettingUpdate.fromJson(Map<String, dynamic> json) {
    return SettingUpdate(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class SwapHelper {
  final bool isNew;
  final String path;
  final int size;
  final String taskID;
  final String used;

  const SwapHelper({
    this.isNew = false,
    this.path = '',
    this.size = 0,
    this.taskID = '',
    this.used = '',
  });

  factory SwapHelper.fromJson(Map<String, dynamic> json) {
    return SwapHelper(
      isNew: json['isNew'] as bool? ?? false,
      path: json['path'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      used: json['used'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'isNew': isNew,
      'path': path,
      'size': size,
      'taskID': taskID,
      'used': used,
  };
}

class UpdateByNameAndFile {
  final String file;
  final String name;

  const UpdateByNameAndFile({
    this.file = '',
    this.name = '',
  });

  factory UpdateByNameAndFile.fromJson(Map<String, dynamic> json) {
    return UpdateByNameAndFile(
      file: json['file'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'file': file,
      'name': name,
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

class Action {

  const Action();

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class DesiredRule {
  final String marker;
  final String observedInstanceKey;
  final String origin;
  final FirewallRule? rule;
  final String ruleKey;
  final String uuid;

  const DesiredRule({
    this.marker = '',
    this.observedInstanceKey = '',
    this.origin = '',
    this.rule,
    this.ruleKey = '',
    this.uuid = '',
  });

  factory DesiredRule.fromJson(Map<String, dynamic> json) {
    return DesiredRule(
      marker: json['marker'] as String? ?? '',
      observedInstanceKey: json['observedInstanceKey'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
      ruleKey: json['ruleKey'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'marker': marker,
      'observedInstanceKey': observedInstanceKey,
      'origin': origin,
      if (rule != null) 'rule': rule!.toJson(),
      'ruleKey': ruleKey,
      'uuid': uuid,
  };
}

class Direction {

  const Direction();

  factory Direction.fromJson(Map<String, dynamic> json) {
    return Direction(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class FirewallRule {
  final Action? action;
  final List<String> connectionStates;
  final String description;
  final String destinationAddress;
  final String destinationPort;
  final String interface;
  final NativeKind? nativeKind;
  final String orderBucket;
  final int orderIndex;
  final int priority;
  final String protocol;
  final Scope? scope;
  final String sourceAddress;
  final String sourcePort;
  final String uuid;

  const FirewallRule({
    this.action,
    this.connectionStates = const [],
    this.description = '',
    this.destinationAddress = '',
    this.destinationPort = '',
    this.interface = '',
    this.nativeKind,
    this.orderBucket = '',
    this.orderIndex = 0,
    this.priority = 0,
    this.protocol = '',
    this.scope,
    this.sourceAddress = '',
    this.sourcePort = '',
    this.uuid = '',
  });

  factory FirewallRule.fromJson(Map<String, dynamic> json) {
    return FirewallRule(
      action: json['action'] != null ? Action.fromJson(json['action'] as Map<String, dynamic>) : null,
      connectionStates: (json['connectionStates'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      description: json['description'] as String? ?? '',
      destinationAddress: json['destinationAddress'] as String? ?? '',
      destinationPort: json['destinationPort'] as String? ?? '',
      interface: json['interface'] as String? ?? '',
      nativeKind: json['nativeKind'] != null ? NativeKind.fromJson(json['nativeKind'] as Map<String, dynamic>) : null,
      orderBucket: json['orderBucket'] as String? ?? '',
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      protocol: json['protocol'] as String? ?? '',
      scope: json['scope'] != null ? Scope.fromJson(json['scope'] as Map<String, dynamic>) : null,
      sourceAddress: json['sourceAddress'] as String? ?? '',
      sourcePort: json['sourcePort'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (action != null) 'action': action!.toJson(),
      'connectionStates': connectionStates,
      'description': description,
      'destinationAddress': destinationAddress,
      'destinationPort': destinationPort,
      'interface': interface,
      if (nativeKind != null) 'nativeKind': nativeKind!.toJson(),
      'orderBucket': orderBucket,
      'orderIndex': orderIndex,
      'priority': priority,
      'protocol': protocol,
      if (scope != null) 'scope': scope!.toJson(),
      'sourceAddress': sourceAddress,
      'sourcePort': sourcePort,
      'uuid': uuid,
  };
}

class InventoryItem {
  final DesiredRule? desired;
  final InventoryMatch? match;
  final ObservedRule? observed;
  final FirewallRule? rule;
  final InventoryState? state;
  final RuntimeUsage? usage;

  const InventoryItem({
    this.desired,
    this.match,
    this.observed,
    this.rule,
    this.state,
    this.usage,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      desired: json['desired'] != null ? DesiredRule.fromJson(json['desired'] as Map<String, dynamic>) : null,
      match: json['match'] != null ? InventoryMatch.fromJson(json['match'] as Map<String, dynamic>) : null,
      observed: json['observed'] != null ? ObservedRule.fromJson(json['observed'] as Map<String, dynamic>) : null,
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
      state: json['state'] != null ? InventoryState.fromJson(json['state'] as Map<String, dynamic>) : null,
      usage: json['usage'] != null ? RuntimeUsage.fromJson(json['usage'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (desired != null) 'desired': desired!.toJson(),
      if (match != null) 'match': match!.toJson(),
      if (observed != null) 'observed': observed!.toJson(),
      if (rule != null) 'rule': rule!.toJson(),
      if (state != null) 'state': state!.toJson(),
      if (usage != null) 'usage': usage!.toJson(),
  };
}

class InventoryMatch {

  const InventoryMatch();

  factory InventoryMatch.fromJson(Map<String, dynamic> json) {
    return InventoryMatch(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class InventoryState {

  const InventoryState();

  factory InventoryState.fromJson(Map<String, dynamic> json) {
    return InventoryState(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class Locator {
  final String canonical;
  final String nativeId;
  final int position;
  final String provider;
  final String scopeKey;

  const Locator({
    this.canonical = '',
    this.nativeId = '',
    this.position = 0,
    this.provider = '',
    this.scopeKey = '',
  });

  factory Locator.fromJson(Map<String, dynamic> json) {
    return Locator(
      canonical: json['canonical'] as String? ?? '',
      nativeId: json['nativeId'] as String? ?? '',
      position: (json['position'] as num?)?.toInt() ?? 0,
      provider: json['provider'] as String? ?? '',
      scopeKey: json['scopeKey'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'canonical': canonical,
      'nativeId': nativeId,
      'position': position,
      'provider': provider,
      'scopeKey': scopeKey,
  };
}

class NativeKind {

  const NativeKind();

  factory NativeKind.fromJson(Map<String, dynamic> json) {
    return NativeKind(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class ObservedRule {
  final String instanceKey;
  final Locator? locator;
  final String marker;
  final ParseStatus? parseStatus;
  final PersistenceStatus? persistence;
  final bool protected;
  final String raw;
  final FirewallRule? rule;

  const ObservedRule({
    this.instanceKey = '',
    this.locator,
    this.marker = '',
    this.parseStatus,
    this.persistence,
    this.protected = false,
    this.raw = '',
    this.rule,
  });

  factory ObservedRule.fromJson(Map<String, dynamic> json) {
    return ObservedRule(
      instanceKey: json['instanceKey'] as String? ?? '',
      locator: json['locator'] != null ? Locator.fromJson(json['locator'] as Map<String, dynamic>) : null,
      marker: json['marker'] as String? ?? '',
      parseStatus: json['parseStatus'] != null ? ParseStatus.fromJson(json['parseStatus'] as Map<String, dynamic>) : null,
      persistence: json['persistence'] != null ? PersistenceStatus.fromJson(json['persistence'] as Map<String, dynamic>) : null,
      protected: json['protected'] as bool? ?? false,
      raw: json['raw'] as String? ?? '',
      rule: json['rule'] != null ? FirewallRule.fromJson(json['rule'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      'instanceKey': instanceKey,
      if (locator != null) 'locator': locator!.toJson(),
      'marker': marker,
      if (parseStatus != null) 'parseStatus': parseStatus!.toJson(),
      if (persistence != null) 'persistence': persistence!.toJson(),
      'protected': protected,
      'raw': raw,
      if (rule != null) 'rule': rule!.toJson(),
  };
}

class ParseStatus {

  const ParseStatus();

  factory ParseStatus.fromJson(Map<String, dynamic> json) {
    return ParseStatus(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class PersistenceStatus {

  const PersistenceStatus();

  factory PersistenceStatus.fromJson(Map<String, dynamic> json) {
    return PersistenceStatus(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class PortWhitelist {
  final String port;
  final String protocol;
  final List<String> sources;
  final String type;

  const PortWhitelist({
    this.port = '',
    this.protocol = '',
    this.sources = const [],
    this.type = '',
  });

  factory PortWhitelist.fromJson(Map<String, dynamic> json) {
    return PortWhitelist(
      port: json['port'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'port': port,
      'protocol': protocol,
      'sources': sources,
      'type': type,
  };
}

class RuntimeUsage {
  final String reason;
  final bool used;
  final List<String> usedBy;

  const RuntimeUsage({
    this.reason = '',
    this.used = false,
    this.usedBy = const [],
  });

  factory RuntimeUsage.fromJson(Map<String, dynamic> json) {
    return RuntimeUsage(
      reason: json['reason'] as String? ?? '',
      used: json['used'] as bool? ?? false,
      usedBy: (json['usedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'reason': reason,
      'used': used,
      'usedBy': usedBy,
  };
}

class Scope {
  final String chain;
  final Direction? direction;
  final String family;
  final String provider;
  final String table;
  final String zone;

  const Scope({
    this.chain = '',
    this.direction,
    this.family = '',
    this.provider = '',
    this.table = '',
    this.zone = '',
  });

  factory Scope.fromJson(Map<String, dynamic> json) {
    return Scope(
      chain: json['chain'] as String? ?? '',
      direction: json['direction'] != null ? Direction.fromJson(json['direction'] as Map<String, dynamic>) : null,
      family: json['family'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      table: json['table'] as String? ?? '',
      zone: json['zone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'chain': chain,
      if (direction != null) 'direction': direction!.toJson(),
      'family': family,
      'provider': provider,
      'table': table,
      'zone': zone,
  };
}

class ScopeNotice {
  final ScopeNoticeCode? code;
  final List<String> values;

  const ScopeNotice({
    this.code,
    this.values = const [],
  });

  factory ScopeNotice.fromJson(Map<String, dynamic> json) {
    return ScopeNotice(
      code: json['code'] != null ? ScopeNoticeCode.fromJson(json['code'] as Map<String, dynamic>) : null,
      values: (json['values'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (code != null) 'code': code!.toJson(),
      'values': values,
  };
}

class ScopeNoticeCode {

  const ScopeNoticeCode();

  factory ScopeNoticeCode.fromJson(Map<String, dynamic> json) {
    return ScopeNoticeCode(
    );
  }

  Map<String, dynamic> toJson() => {
  };
}

class Favorite {
  final String createdAt;
  final int id;
  final bool isDir;
  final bool isTxt;
  final String name;
  final String path;
  final String type;
  final String updatedAt;

  const Favorite({
    this.createdAt = '',
    this.id = 0,
    this.isDir = false,
    this.isTxt = false,
    this.name = '',
    this.path = '',
    this.type = '',
    this.updatedAt = '',
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      createdAt: json['createdAt'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDir: json['isDir'] as bool? ?? false,
      isTxt: json['isTxt'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'id': id,
      'isDir': isDir,
      'isTxt': isTxt,
      'name': name,
      'path': path,
      'type': type,
      'updatedAt': updatedAt,
  };
}

class DirSizeReq {
  final String path;

  const DirSizeReq({
    this.path = '',
  });

  factory DirSizeReq.fromJson(Map<String, dynamic> json) {
    return DirSizeReq(
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
  };
}

class DiskMountRequest {
  final bool autoMount;
  final String device;
  final String filesystem;
  final String mountPoint;
  final bool noFail;

  const DiskMountRequest({
    this.autoMount = false,
    this.device = '',
    this.filesystem = '',
    this.mountPoint = '',
    this.noFail = false,
  });

  factory DiskMountRequest.fromJson(Map<String, dynamic> json) {
    return DiskMountRequest(
      autoMount: json['autoMount'] as bool? ?? false,
      device: json['device'] as String? ?? '',
      filesystem: json['filesystem'] as String? ?? '',
      mountPoint: json['mountPoint'] as String? ?? '',
      noFail: json['noFail'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'autoMount': autoMount,
      'device': device,
      'filesystem': filesystem,
      'mountPoint': mountPoint,
      'noFail': noFail,
  };
}

class DiskPartitionRequest {
  final bool autoMount;
  final String device;
  final String filesystem;
  final String label;
  final String mountPoint;

  const DiskPartitionRequest({
    this.autoMount = false,
    this.device = '',
    this.filesystem = '',
    this.label = '',
    this.mountPoint = '',
  });

  factory DiskPartitionRequest.fromJson(Map<String, dynamic> json) {
    return DiskPartitionRequest(
      autoMount: json['autoMount'] as bool? ?? false,
      device: json['device'] as String? ?? '',
      filesystem: json['filesystem'] as String? ?? '',
      label: json['label'] as String? ?? '',
      mountPoint: json['mountPoint'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoMount': autoMount,
      'device': device,
      'filesystem': filesystem,
      'label': label,
      'mountPoint': mountPoint,
  };
}

class DiskUnmountRequest {
  final String mountPoint;

  const DiskUnmountRequest({
    this.mountPoint = '',
  });

  factory DiskUnmountRequest.fromJson(Map<String, dynamic> json) {
    return DiskUnmountRequest(
      mountPoint: json['mountPoint'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'mountPoint': mountPoint,
  };
}

class FavoriteCreate {
  final String path;

  const FavoriteCreate({
    this.path = '',
  });

  factory FavoriteCreate.fromJson(Map<String, dynamic> json) {
    return FavoriteCreate(
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
  };
}

class FavoriteDelete {
  final int id;

  const FavoriteDelete({
    this.id = 0,
  });

  factory FavoriteDelete.fromJson(Map<String, dynamic> json) {
    return FavoriteDelete(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class FileAISearch {
  final bool containSub;
  final int contentHitsPromptMaxBytes;
  final List<String> extensions;
  final int llmMaxOutputTokens;
  final bool matchCase;
  final int maxFileBytes;
  final int maxHitsPerFile;
  final int maxItems;
  final int maxScanFiles;
  final int maxSize;
  final int maxTotalHits;
  final int minSize;
  final String modifiedAfter;
  final String modifiedBefore;
  final String path;
  final String query;
  final String responseLanguage;
  final bool useRegex;
  final bool wholeWord;

  const FileAISearch({
    this.containSub = false,
    this.contentHitsPromptMaxBytes = 0,
    this.extensions = const [],
    this.llmMaxOutputTokens = 0,
    this.matchCase = false,
    this.maxFileBytes = 0,
    this.maxHitsPerFile = 0,
    this.maxItems = 0,
    this.maxScanFiles = 0,
    this.maxSize = 0,
    this.maxTotalHits = 0,
    this.minSize = 0,
    this.modifiedAfter = '',
    this.modifiedBefore = '',
    this.path = '',
    this.query = '',
    this.responseLanguage = '',
    this.useRegex = false,
    this.wholeWord = false,
  });

  factory FileAISearch.fromJson(Map<String, dynamic> json) {
    return FileAISearch(
      containSub: json['containSub'] as bool? ?? false,
      contentHitsPromptMaxBytes: (json['contentHitsPromptMaxBytes'] as num?)?.toInt() ?? 0,
      extensions: (json['extensions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      llmMaxOutputTokens: (json['llmMaxOutputTokens'] as num?)?.toInt() ?? 0,
      matchCase: json['matchCase'] as bool? ?? false,
      maxFileBytes: (json['maxFileBytes'] as num?)?.toInt() ?? 0,
      maxHitsPerFile: (json['maxHitsPerFile'] as num?)?.toInt() ?? 0,
      maxItems: (json['maxItems'] as num?)?.toInt() ?? 0,
      maxScanFiles: (json['maxScanFiles'] as num?)?.toInt() ?? 0,
      maxSize: (json['maxSize'] as num?)?.toInt() ?? 0,
      maxTotalHits: (json['maxTotalHits'] as num?)?.toInt() ?? 0,
      minSize: (json['minSize'] as num?)?.toInt() ?? 0,
      modifiedAfter: json['modifiedAfter'] as String? ?? '',
      modifiedBefore: json['modifiedBefore'] as String? ?? '',
      path: json['path'] as String? ?? '',
      query: json['query'] as String? ?? '',
      responseLanguage: json['responseLanguage'] as String? ?? '',
      useRegex: json['useRegex'] as bool? ?? false,
      wholeWord: json['wholeWord'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'containSub': containSub,
      'contentHitsPromptMaxBytes': contentHitsPromptMaxBytes,
      'extensions': extensions,
      'llmMaxOutputTokens': llmMaxOutputTokens,
      'matchCase': matchCase,
      'maxFileBytes': maxFileBytes,
      'maxHitsPerFile': maxHitsPerFile,
      'maxItems': maxItems,
      'maxScanFiles': maxScanFiles,
      'maxSize': maxSize,
      'maxTotalHits': maxTotalHits,
      'minSize': minSize,
      'modifiedAfter': modifiedAfter,
      'modifiedBefore': modifiedBefore,
      'path': path,
      'query': query,
      'responseLanguage': responseLanguage,
      'useRegex': useRegex,
      'wholeWord': wholeWord,
  };
}

class FileBatchDelete {
  final bool isDir;
  final List<String> paths;

  const FileBatchDelete({
    this.isDir = false,
    this.paths = const [],
  });

  factory FileBatchDelete.fromJson(Map<String, dynamic> json) {
    return FileBatchDelete(
      isDir: json['isDir'] as bool? ?? false,
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'isDir': isDir,
      'paths': paths,
  };
}

class FileCompress {
  final String dst;
  final List<String> files;
  final String name;
  final bool replace;
  final String secret;
  final String taskID;
  final String type;

  const FileCompress({
    this.dst = '',
    this.files = const [],
    this.name = '',
    this.replace = false,
    this.secret = '',
    this.taskID = '',
    this.type = '',
  });

  factory FileCompress.fromJson(Map<String, dynamic> json) {
    return FileCompress(
      dst: json['dst'] as String? ?? '',
      files: (json['files'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      name: json['name'] as String? ?? '',
      replace: json['replace'] as bool? ?? false,
      secret: json['secret'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'dst': dst,
      'files': files,
      'name': name,
      'replace': replace,
      'secret': secret,
      'taskID': taskID,
      'type': type,
  };
}

class FileCompressStopReq {
  final String taskID;

  const FileCompressStopReq({
    this.taskID = '',
  });

  factory FileCompressStopReq.fromJson(Map<String, dynamic> json) {
    return FileCompressStopReq(
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'taskID': taskID,
  };
}

class FileContentReq {
  final bool isDetail;
  final String path;

  const FileContentReq({
    this.isDetail = false,
    this.path = '',
  });

  factory FileContentReq.fromJson(Map<String, dynamic> json) {
    return FileContentReq(
      isDetail: json['isDetail'] as bool? ?? false,
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'isDetail': isDetail,
      'path': path,
  };
}

class FileConvert {
  final String extension;
  final String inputFile;
  final String outputFormat;
  final String path;
  final String status;
  final String type;

  const FileConvert({
    this.extension = '',
    this.inputFile = '',
    this.outputFormat = '',
    this.path = '',
    this.status = '',
    this.type = '',
  });

  factory FileConvert.fromJson(Map<String, dynamic> json) {
    return FileConvert(
      extension: json['extension'] as String? ?? '',
      inputFile: json['inputFile'] as String? ?? '',
      outputFormat: json['outputFormat'] as String? ?? '',
      path: json['path'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'extension': extension,
      'inputFile': inputFile,
      'outputFormat': outputFormat,
      'path': path,
      'status': status,
      'type': type,
  };
}

class FileCreate {
  final String content;
  final bool isDir;
  final bool isLink;
  final bool isSymlink;
  final String linkPath;
  final int mode;
  final String path;
  final bool sub;

  const FileCreate({
    this.content = '',
    this.isDir = false,
    this.isLink = false,
    this.isSymlink = false,
    this.linkPath = '',
    this.mode = 0,
    this.path = '',
    this.sub = false,
  });

  factory FileCreate.fromJson(Map<String, dynamic> json) {
    return FileCreate(
      content: json['content'] as String? ?? '',
      isDir: json['isDir'] as bool? ?? false,
      isLink: json['isLink'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      linkPath: json['linkPath'] as String? ?? '',
      mode: (json['mode'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      sub: json['sub'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'isDir': isDir,
      'isLink': isLink,
      'isSymlink': isSymlink,
      'linkPath': linkPath,
      'mode': mode,
      'path': path,
      'sub': sub,
  };
}

class FileDeCompress {
  final String dst;
  final String path;
  final String secret;
  final String taskID;
  final String type;

  const FileDeCompress({
    this.dst = '',
    this.path = '',
    this.secret = '',
    this.taskID = '',
    this.type = '',
  });

  factory FileDeCompress.fromJson(Map<String, dynamic> json) {
    return FileDeCompress(
      dst: json['dst'] as String? ?? '',
      path: json['path'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'dst': dst,
      'path': path,
      'secret': secret,
      'taskID': taskID,
      'type': type,
  };
}

class FileDeCompressStopReq {
  final String taskID;

  const FileDeCompressStopReq({
    this.taskID = '',
  });

  factory FileDeCompressStopReq.fromJson(Map<String, dynamic> json) {
    return FileDeCompressStopReq(
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'taskID': taskID,
  };
}

class FileDelete {
  final bool forceDelete;
  final bool isDir;
  final String path;

  const FileDelete({
    this.forceDelete = false,
    this.isDir = false,
    this.path = '',
  });

  factory FileDelete.fromJson(Map<String, dynamic> json) {
    return FileDelete(
      forceDelete: json['forceDelete'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'forceDelete': forceDelete,
      'isDir': isDir,
      'path': path,
  };
}

class FileDownload {
  final bool compress;
  final String name;
  final List<String> paths;
  final String type;

  const FileDownload({
    this.compress = false,
    this.name = '',
    this.paths = const [],
    this.type = '',
  });

  factory FileDownload.fromJson(Map<String, dynamic> json) {
    return FileDownload(
      compress: json['compress'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'compress': compress,
      'name': name,
      'paths': paths,
      'type': type,
  };
}

class FileEdit {
  final String content;
  final String path;

  const FileEdit({
    this.content = '',
    this.path = '',
  });

  factory FileEdit.fromJson(Map<String, dynamic> json) {
    return FileEdit(
      content: json['content'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'path': path,
  };
}

class FileHistoryContentReq {
  final int id;

  const FileHistoryContentReq({
    this.id = 0,
  });

  factory FileHistoryContentReq.fromJson(Map<String, dynamic> json) {
    return FileHistoryContentReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class FileHistoryDeleteReq {
  final List<int> ids;

  const FileHistoryDeleteReq({
    this.ids = const [],
  });

  factory FileHistoryDeleteReq.fromJson(Map<String, dynamic> json) {
    return FileHistoryDeleteReq(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class FileHistoryRestoreReq {
  final int id;

  const FileHistoryRestoreReq({
    this.id = 0,
  });

  factory FileHistoryRestoreReq.fromJson(Map<String, dynamic> json) {
    return FileHistoryRestoreReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class FileHistorySearchReq {
  final String operation;
  final int page;
  final int pageSize;
  final String path;
  final String scope;

  const FileHistorySearchReq({
    this.operation = '',
    this.page = 0,
    this.pageSize = 0,
    this.path = '',
    this.scope = '',
  });

  factory FileHistorySearchReq.fromJson(Map<String, dynamic> json) {
    return FileHistorySearchReq(
      operation: json['operation'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
      'page': page,
      'pageSize': pageSize,
      'path': path,
      'scope': scope,
  };
}

class FileMove {
  final bool cover;
  final List<String> coverPaths;
  final String name;
  final String newPath;
  final List<String> oldPaths;
  final String taskID;
  final String type;

  const FileMove({
    this.cover = false,
    this.coverPaths = const [],
    this.name = '',
    this.newPath = '',
    this.oldPaths = const [],
    this.taskID = '',
    this.type = '',
  });

  factory FileMove.fromJson(Map<String, dynamic> json) {
    return FileMove(
      cover: json['cover'] as bool? ?? false,
      coverPaths: (json['coverPaths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      name: json['name'] as String? ?? '',
      newPath: json['newPath'] as String? ?? '',
      oldPaths: (json['oldPaths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cover': cover,
      'coverPaths': coverPaths,
      'name': name,
      'newPath': newPath,
      'oldPaths': oldPaths,
      'taskID': taskID,
      'type': type,
  };
}

class FileMoveStopReq {
  final String taskID;

  const FileMoveStopReq({
    this.taskID = '',
  });

  factory FileMoveStopReq.fromJson(Map<String, dynamic> json) {
    return FileMoveStopReq(
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'taskID': taskID,
  };
}

class FileOption {
  final bool containSub;
  final bool dir;
  final bool expand;
  final bool isDetail;
  final int page;
  final int pageSize;
  final String path;
  final String search;
  final bool showHidden;
  final String sortBy;
  final String sortOrder;

  const FileOption({
    this.containSub = false,
    this.dir = false,
    this.expand = false,
    this.isDetail = false,
    this.page = 0,
    this.pageSize = 0,
    this.path = '',
    this.search = '',
    this.showHidden = false,
    this.sortBy = '',
    this.sortOrder = '',
  });

  factory FileOption.fromJson(Map<String, dynamic> json) {
    return FileOption(
      containSub: json['containSub'] as bool? ?? false,
      dir: json['dir'] as bool? ?? false,
      expand: json['expand'] as bool? ?? false,
      isDetail: json['isDetail'] as bool? ?? false,
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      search: json['search'] as String? ?? '',
      showHidden: json['showHidden'] as bool? ?? false,
      sortBy: json['sortBy'] as String? ?? '',
      sortOrder: json['sortOrder'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containSub': containSub,
      'dir': dir,
      'expand': expand,
      'isDetail': isDetail,
      'page': page,
      'pageSize': pageSize,
      'path': path,
      'search': search,
      'showHidden': showHidden,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
  };
}

class FilePathCheck {
  final String path;
  final bool withInit;

  const FilePathCheck({
    this.path = '',
    this.withInit = false,
  });

  factory FilePathCheck.fromJson(Map<String, dynamic> json) {
    return FilePathCheck(
      path: json['path'] as String? ?? '',
      withInit: json['withInit'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
      'withInit': withInit,
  };
}

class FilePathsCheck {
  final List<String> paths;

  const FilePathsCheck({
    this.paths = const [],
  });

  factory FilePathsCheck.fromJson(Map<String, dynamic> json) {
    return FilePathsCheck(
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'paths': paths,
  };
}

class FileProcessReq {
  final String key;

  const FileProcessReq({
    this.key = '',
  });

  factory FileProcessReq.fromJson(Map<String, dynamic> json) {
    return FileProcessReq(
      key: json['key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
  };
}

class FileReadByLineReq {
  final int iD;
  final bool latest;
  final String name;
  final int page;
  final int pageSize;
  final int resourceID;
  final String taskID;
  final String taskOperate;
  final String taskType;
  final String type;

  const FileReadByLineReq({
    this.iD = 0,
    this.latest = false,
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.resourceID = 0,
    this.taskID = '',
    this.taskOperate = '',
    this.taskType = '',
    this.type = '',
  });

  factory FileReadByLineReq.fromJson(Map<String, dynamic> json) {
    return FileReadByLineReq(
      iD: (json['ID'] as num?)?.toInt() ?? 0,
      latest: json['latest'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      resourceID: (json['resourceID'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      taskOperate: json['taskOperate'] as String? ?? '',
      taskType: json['taskType'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'ID': iD,
      'latest': latest,
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'resourceID': resourceID,
      'taskID': taskID,
      'taskOperate': taskOperate,
      'taskType': taskType,
      'type': type,
  };
}

class FileRemarkBatch {
  final List<String> paths;

  const FileRemarkBatch({
    this.paths = const [],
  });

  factory FileRemarkBatch.fromJson(Map<String, dynamic> json) {
    return FileRemarkBatch(
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'paths': paths,
  };
}

class FileRemarkUpdate {
  final String path;
  final String remark;

  const FileRemarkUpdate({
    this.path = '',
    this.remark = '',
  });

  factory FileRemarkUpdate.fromJson(Map<String, dynamic> json) {
    return FileRemarkUpdate(
      path: json['path'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
      'remark': remark,
  };
}

class FileRename {
  final String newName;
  final String oldName;

  const FileRename({
    this.newName = '',
    this.oldName = '',
  });

  factory FileRename.fromJson(Map<String, dynamic> json) {
    return FileRename(
      newName: json['newName'] as String? ?? '',
      oldName: json['oldName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'newName': newName,
      'oldName': oldName,
  };
}

class FileRoleReq {
  final String group;
  final int mode;
  final List<String> paths;
  final bool sub;
  final String user;

  const FileRoleReq({
    this.group = '',
    this.mode = 0,
    this.paths = const [],
    this.sub = false,
    this.user = '',
  });

  factory FileRoleReq.fromJson(Map<String, dynamic> json) {
    return FileRoleReq(
      group: json['group'] as String? ?? '',
      mode: (json['mode'] as num?)?.toInt() ?? 0,
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      sub: json['sub'] as bool? ?? false,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'group': group,
      'mode': mode,
      'paths': paths,
      'sub': sub,
      'user': user,
  };
}

class FileRoleUpdate {
  final String group;
  final String path;
  final bool sub;
  final String user;

  const FileRoleUpdate({
    this.group = '',
    this.path = '',
    this.sub = false,
    this.user = '',
  });

  factory FileRoleUpdate.fromJson(Map<String, dynamic> json) {
    return FileRoleUpdate(
      group: json['group'] as String? ?? '',
      path: json['path'] as String? ?? '',
      sub: json['sub'] as bool? ?? false,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'group': group,
      'path': path,
      'sub': sub,
      'user': user,
  };
}

class FileShareCreate {
  final int expireMinutes;
  final String password;
  final String path;

  const FileShareCreate({
    this.expireMinutes = 0,
    this.password = '',
    this.path = '',
  });

  factory FileShareCreate.fromJson(Map<String, dynamic> json) {
    return FileShareCreate(
      expireMinutes: (json['expireMinutes'] as num?)?.toInt() ?? 0,
      password: json['password'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'expireMinutes': expireMinutes,
      'password': password,
      'path': path,
  };
}

class FileWget {
  final bool ignoreCertificate;
  final String name;
  final String path;
  final String url;
  final bool useProxy;

  const FileWget({
    this.ignoreCertificate = false,
    this.name = '',
    this.path = '',
    this.url = '',
    this.useProxy = false,
  });

  factory FileWget.fromJson(Map<String, dynamic> json) {
    return FileWget(
      ignoreCertificate: json['ignoreCertificate'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      url: json['url'] as String? ?? '',
      useProxy: json['useProxy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ignoreCertificate': ignoreCertificate,
      'name': name,
      'path': path,
      'url': url,
      'useProxy': useProxy,
  };
}

class HostSupervisorProcessFileGetReq {
  final String file;
  final String name;

  const HostSupervisorProcessFileGetReq({
    this.file = '',
    this.name = '',
  });

  factory HostSupervisorProcessFileGetReq.fromJson(Map<String, dynamic> json) {
    return HostSupervisorProcessFileGetReq(
      file: json['file'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'file': file,
      'name': name,
  };
}

class HostSupervisorProcessFileOperateReq {
  final String content;
  final String file;
  final String name;
  final String operate;

  const HostSupervisorProcessFileOperateReq({
    this.content = '',
    this.file = '',
    this.name = '',
    this.operate = '',
  });

  factory HostSupervisorProcessFileOperateReq.fromJson(Map<String, dynamic> json) {
    return HostSupervisorProcessFileOperateReq(
      content: json['content'] as String? ?? '',
      file: json['file'] as String? ?? '',
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'file': file,
      'name': name,
      'operate': operate,
  };
}

class HostToolConfigUpdate {
  final String content;
  final String type;

  const HostToolConfigUpdate({
    this.content = '',
    this.type = '',
  });

  factory HostToolConfigUpdate.fromJson(Map<String, dynamic> json) {
    return HostToolConfigUpdate(
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'type': type,
  };
}

class HostToolCreate {
  final String configPath;
  final String serviceName;
  final String type;

  const HostToolCreate({
    this.configPath = '',
    this.serviceName = '',
    this.type = '',
  });

  factory HostToolCreate.fromJson(Map<String, dynamic> json) {
    return HostToolCreate(
      configPath: json['configPath'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'configPath': configPath,
      'serviceName': serviceName,
      'type': type,
  };
}

class HostToolOperateReq {
  final String operate;
  final String type;

  const HostToolOperateReq({
    this.operate = '',
    this.type = '',
  });

  factory HostToolOperateReq.fromJson(Map<String, dynamic> json) {
    return HostToolOperateReq(
      operate: json['operate'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operate': operate,
      'type': type,
  };
}

class HostToolTypeReq {
  final String type;

  const HostToolTypeReq({
    this.type = '',
  });

  factory HostToolTypeReq.fromJson(Map<String, dynamic> json) {
    return HostToolTypeReq(
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'type': type,
  };
}

class ProcessReq {
  final int pID;

  const ProcessReq({
    this.pID = 0,
  });

  factory ProcessReq.fromJson(Map<String, dynamic> json) {
    return ProcessReq(
      pID: (json['PID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'PID': pID,
  };
}

class RecycleBinReduce {
  final String from;
  final String name;
  final String rName;

  const RecycleBinReduce({
    this.from = '',
    this.name = '',
    this.rName = '',
  });

  factory RecycleBinReduce.fromJson(Map<String, dynamic> json) {
    return RecycleBinReduce(
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rName: json['rName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'from': from,
      'name': name,
      'rName': rName,
  };
}

class SearchUploadWithPage {
  final int page;
  final int pageSize;
  final String path;

  const SearchUploadWithPage({
    this.page = 0,
    this.pageSize = 0,
    this.path = '',
  });

  factory SearchUploadWithPage.fromJson(Map<String, dynamic> json) {
    return SearchUploadWithPage(
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'page': page,
      'pageSize': pageSize,
      'path': path,
  };
}

class SupervisorProcessConfig {
  final String autoRestart;
  final String autoStart;
  final String command;
  final String dir;
  final String environment;
  final String name;
  final String numprocs;
  final String operate;
  final String user;

  const SupervisorProcessConfig({
    this.autoRestart = '',
    this.autoStart = '',
    this.command = '',
    this.dir = '',
    this.environment = '',
    this.name = '',
    this.numprocs = '',
    this.operate = '',
    this.user = '',
  });

  factory SupervisorProcessConfig.fromJson(Map<String, dynamic> json) {
    return SupervisorProcessConfig(
      autoRestart: json['autoRestart'] as String? ?? '',
      autoStart: json['autoStart'] as String? ?? '',
      command: json['command'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
      name: json['name'] as String? ?? '',
      numprocs: json['numprocs'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoRestart': autoRestart,
      'autoStart': autoStart,
      'command': command,
      'dir': dir,
      'environment': environment,
      'name': name,
      'numprocs': numprocs,
      'operate': operate,
      'user': user,
  };
}

class CompleteDiskInfo {
  final List<DiskInfo> disks;
  final List<DiskInfo> systemDisks;
  final int totalCapacity;
  final int totalDisks;
  final List<DiskBasicInfo> unpartitionedDisks;

  const CompleteDiskInfo({
    this.disks = const [],
    this.systemDisks = const [],
    this.totalCapacity = 0,
    this.totalDisks = 0,
    this.unpartitionedDisks = const [],
  });

  factory CompleteDiskInfo.fromJson(Map<String, dynamic> json) {
    return CompleteDiskInfo(
      disks: (json['disks'] as List<dynamic>?)?.map((e) => DiskInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      systemDisks: (json['systemDisks'] as List<dynamic>?)?.map((e) => DiskInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      totalCapacity: (json['totalCapacity'] as num?)?.toInt() ?? 0,
      totalDisks: (json['totalDisks'] as num?)?.toInt() ?? 0,
      unpartitionedDisks: (json['unpartitionedDisks'] as List<dynamic>?)?.map((e) => DiskBasicInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'disks': disks.map((e) => e.toJson()).toList(),
      'systemDisks': systemDisks.map((e) => e.toJson()).toList(),
      'totalCapacity': totalCapacity,
      'totalDisks': totalDisks,
      'unpartitionedDisks': unpartitionedDisks.map((e) => e.toJson()).toList(),
  };
}

class ComponentInfo {
  final String error;
  final bool exists;
  final String path;
  final String version;

  const ComponentInfo({
    this.error = '',
    this.exists = false,
    this.path = '',
    this.version = '',
  });

  factory ComponentInfo.fromJson(Map<String, dynamic> json) {
    return ComponentInfo(
      error: json['error'] as String? ?? '',
      exists: json['exists'] as bool? ?? false,
      path: json['path'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'error': error,
      'exists': exists,
      'path': path,
      'version': version,
  };
}

class DepthDirSizeRes {
  final String path;
  final int size;

  const DepthDirSizeRes({
    this.path = '',
    this.size = 0,
  });

  factory DepthDirSizeRes.fromJson(Map<String, dynamic> json) {
    return DepthDirSizeRes(
      path: json['path'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'path': path,
      'size': size,
  };
}

class DirSizeRes {
  final int size;

  const DirSizeRes({
    this.size = 0,
  });

  factory DirSizeRes.fromJson(Map<String, dynamic> json) {
    return DirSizeRes(
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'size': size,
  };
}

class DiskBasicInfo {
  final String avail;
  final String device;
  final String diskType;
  final String filesystem;
  final bool isMounted;
  final bool isRemovable;
  final bool isSystem;
  final String model;
  final String mountPoint;
  final String serial;
  final String size;
  final int usePercent;
  final String used;

  const DiskBasicInfo({
    this.avail = '',
    this.device = '',
    this.diskType = '',
    this.filesystem = '',
    this.isMounted = false,
    this.isRemovable = false,
    this.isSystem = false,
    this.model = '',
    this.mountPoint = '',
    this.serial = '',
    this.size = '',
    this.usePercent = 0,
    this.used = '',
  });

  factory DiskBasicInfo.fromJson(Map<String, dynamic> json) {
    return DiskBasicInfo(
      avail: json['avail'] as String? ?? '',
      device: json['device'] as String? ?? '',
      diskType: json['diskType'] as String? ?? '',
      filesystem: json['filesystem'] as String? ?? '',
      isMounted: json['isMounted'] as bool? ?? false,
      isRemovable: json['isRemovable'] as bool? ?? false,
      isSystem: json['isSystem'] as bool? ?? false,
      model: json['model'] as String? ?? '',
      mountPoint: json['mountPoint'] as String? ?? '',
      serial: json['serial'] as String? ?? '',
      size: json['size'] as String? ?? '',
      usePercent: (json['usePercent'] as num?)?.toInt() ?? 0,
      used: json['used'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'avail': avail,
      'device': device,
      'diskType': diskType,
      'filesystem': filesystem,
      'isMounted': isMounted,
      'isRemovable': isRemovable,
      'isSystem': isSystem,
      'model': model,
      'mountPoint': mountPoint,
      'serial': serial,
      'size': size,
      'usePercent': usePercent,
      'used': used,
  };
}

class ExistFileInfo {
  final bool isDir;
  final String modTime;
  final String name;
  final String path;
  final int size;

  const ExistFileInfo({
    this.isDir = false,
    this.modTime = '',
    this.name = '',
    this.path = '',
    this.size = 0,
  });

  factory ExistFileInfo.fromJson(Map<String, dynamic> json) {
    return ExistFileInfo(
      isDir: json['isDir'] as bool? ?? false,
      modTime: json['modTime'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'isDir': isDir,
      'modTime': modTime,
      'name': name,
      'path': path,
      'size': size,
  };
}

class FileAIContentHit {
  final int line;
  final String path;
  final String text;

  const FileAIContentHit({
    this.line = 0,
    this.path = '',
    this.text = '',
  });

  factory FileAIContentHit.fromJson(Map<String, dynamic> json) {
    return FileAIContentHit(
      line: (json['line'] as num?)?.toInt() ?? 0,
      path: json['path'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'line': line,
      'path': path,
      'text': text,
  };
}

class FileAISearchResult {
  final int completionTokens;
  final bool contentHitsTruncated;
  final int contentScannedFiles;
  final String duration;
  final List<FileAIContentHit> hits;
  final int itemCount;
  final String mode;
  final bool preFiltered;
  final int promptTokens;
  final String summary;
  final int totalTokens;
  final bool truncated;

  const FileAISearchResult({
    this.completionTokens = 0,
    this.contentHitsTruncated = false,
    this.contentScannedFiles = 0,
    this.duration = '',
    this.hits = const [],
    this.itemCount = 0,
    this.mode = '',
    this.preFiltered = false,
    this.promptTokens = 0,
    this.summary = '',
    this.totalTokens = 0,
    this.truncated = false,
  });

  factory FileAISearchResult.fromJson(Map<String, dynamic> json) {
    return FileAISearchResult(
      completionTokens: (json['completionTokens'] as num?)?.toInt() ?? 0,
      contentHitsTruncated: json['contentHitsTruncated'] as bool? ?? false,
      contentScannedFiles: (json['contentScannedFiles'] as num?)?.toInt() ?? 0,
      duration: json['duration'] as String? ?? '',
      hits: (json['hits'] as List<dynamic>?)?.map((e) => FileAIContentHit.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? '',
      preFiltered: json['preFiltered'] as bool? ?? false,
      promptTokens: (json['promptTokens'] as num?)?.toInt() ?? 0,
      summary: json['summary'] as String? ?? '',
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
      truncated: json['truncated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'completionTokens': completionTokens,
      'contentHitsTruncated': contentHitsTruncated,
      'contentScannedFiles': contentScannedFiles,
      'duration': duration,
      'hits': hits.map((e) => e.toJson()).toList(),
      'itemCount': itemCount,
      'mode': mode,
      'preFiltered': preFiltered,
      'promptTokens': promptTokens,
      'summary': summary,
      'totalTokens': totalTokens,
      'truncated': truncated,
  };
}

class FileHistoryInfo {
  final String content;
  final String contentSHA;
  final int contentSize;
  final String createdAt;
  final String currentContent;
  final String currentPath;
  final bool deleted;
  final String extension;
  final String fileId;
  final String fileMode;
  final String fileName;
  final int id;
  final String operation;
  final String path;
  final int previousId;
  final String sourcePath;
  final String storagePath;
  final String targetPath;
  final String updatedAt;

  const FileHistoryInfo({
    this.content = '',
    this.contentSHA = '',
    this.contentSize = 0,
    this.createdAt = '',
    this.currentContent = '',
    this.currentPath = '',
    this.deleted = false,
    this.extension = '',
    this.fileId = '',
    this.fileMode = '',
    this.fileName = '',
    this.id = 0,
    this.operation = '',
    this.path = '',
    this.previousId = 0,
    this.sourcePath = '',
    this.storagePath = '',
    this.targetPath = '',
    this.updatedAt = '',
  });

  factory FileHistoryInfo.fromJson(Map<String, dynamic> json) {
    return FileHistoryInfo(
      content: json['content'] as String? ?? '',
      contentSHA: json['contentSHA'] as String? ?? '',
      contentSize: (json['contentSize'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      currentContent: json['currentContent'] as String? ?? '',
      currentPath: json['currentPath'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
      extension: json['extension'] as String? ?? '',
      fileId: json['fileId'] as String? ?? '',
      fileMode: json['fileMode'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      operation: json['operation'] as String? ?? '',
      path: json['path'] as String? ?? '',
      previousId: (json['previousId'] as num?)?.toInt() ?? 0,
      sourcePath: json['sourcePath'] as String? ?? '',
      storagePath: json['storagePath'] as String? ?? '',
      targetPath: json['targetPath'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'contentSHA': contentSHA,
      'contentSize': contentSize,
      'createdAt': createdAt,
      'currentContent': currentContent,
      'currentPath': currentPath,
      'deleted': deleted,
      'extension': extension,
      'fileId': fileId,
      'fileMode': fileMode,
      'fileName': fileName,
      'id': id,
      'operation': operation,
      'path': path,
      'previousId': previousId,
      'sourcePath': sourcePath,
      'storagePath': storagePath,
      'targetPath': targetPath,
      'updatedAt': updatedAt,
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

class FileLineContent {
  final bool end;
  final List<String> lines;
  final String path;
  final String scope;
  final String taskStatus;
  final int total;
  final int totalLines;

  const FileLineContent({
    this.end = false,
    this.lines = const [],
    this.path = '',
    this.scope = '',
    this.taskStatus = '',
    this.total = 0,
    this.totalLines = 0,
  });

  factory FileLineContent.fromJson(Map<String, dynamic> json) {
    return FileLineContent(
      end: json['end'] as bool? ?? false,
      lines: (json['lines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      path: json['path'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
      taskStatus: json['taskStatus'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalLines: (json['totalLines'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'end': end,
      'lines': lines,
      'path': path,
      'scope': scope,
      'taskStatus': taskStatus,
      'total': total,
      'totalLines': totalLines,
  };
}

class FileRemarksRes {
  final Map<String, dynamic> remarks;

  const FileRemarksRes({
    this.remarks = const {},
  });

  factory FileRemarksRes.fromJson(Map<String, dynamic> json) {
    return FileRemarksRes(
      remarks: json['remarks'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
      'remarks': remarks,
  };
}

class FileShareInfo {
  final String code;
  final int expiresAt;
  final String fileName;
  final bool hasPassword;
  final String password;
  final String path;
  final bool permanent;

  const FileShareInfo({
    this.code = '',
    this.expiresAt = 0,
    this.fileName = '',
    this.hasPassword = false,
    this.password = '',
    this.path = '',
    this.permanent = false,
  });

  factory FileShareInfo.fromJson(Map<String, dynamic> json) {
    return FileShareInfo(
      code: json['code'] as String? ?? '',
      expiresAt: (json['expiresAt'] as num?)?.toInt() ?? 0,
      fileName: json['fileName'] as String? ?? '',
      hasPassword: json['hasPassword'] as bool? ?? false,
      password: json['password'] as String? ?? '',
      path: json['path'] as String? ?? '',
      permanent: json['permanent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'code': code,
      'expiresAt': expiresAt,
      'fileName': fileName,
      'hasPassword': hasPassword,
      'password': password,
      'path': path,
      'permanent': permanent,
  };
}

class FileSharePublicInfo {
  final int expiresAt;
  final String fileName;
  final bool hasPassword;
  final bool permanent;

  const FileSharePublicInfo({
    this.expiresAt = 0,
    this.fileName = '',
    this.hasPassword = false,
    this.permanent = false,
  });

  factory FileSharePublicInfo.fromJson(Map<String, dynamic> json) {
    return FileSharePublicInfo(
      expiresAt: (json['expiresAt'] as num?)?.toInt() ?? 0,
      fileName: json['fileName'] as String? ?? '',
      hasPassword: json['hasPassword'] as bool? ?? false,
      permanent: json['permanent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'expiresAt': expiresAt,
      'fileName': fileName,
      'hasPassword': hasPassword,
      'permanent': permanent,
  };
}

class FileTree {
  final List<FileTree> children;
  final String extension;
  final String id;
  final bool isDir;
  final String name;
  final String path;

  const FileTree({
    this.children = const [],
    this.extension = '',
    this.id = '',
    this.isDir = false,
    this.name = '',
    this.path = '',
  });

  factory FileTree.fromJson(Map<String, dynamic> json) {
    return FileTree(
      children: (json['children'] as List<dynamic>?)?.map((e) => FileTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extension: json['extension'] as String? ?? '',
      id: json['id'] as String? ?? '',
      isDir: json['isDir'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'children': children.map((e) => e.toJson()).toList(),
      'extension': extension,
      'id': id,
      'isDir': isDir,
      'name': name,
      'path': path,
  };
}

class FileWgetRes {
  final String key;

  const FileWgetRes({
    this.key = '',
  });

  factory FileWgetRes.fromJson(Map<String, dynamic> json) {
    return FileWgetRes(
      key: json['key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
  };
}

class HostToolConfig {
  final String content;

  const HostToolConfig({
    this.content = '',
  });

  factory HostToolConfig.fromJson(Map<String, dynamic> json) {
    return HostToolConfig(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class HostToolRes {
  final dynamic config;
  final String type;

  const HostToolRes({
    this.config,
    this.type = '',
  });

  factory HostToolRes.fromJson(Map<String, dynamic> json) {
    return HostToolRes(
      config: json['config'],
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'config': config,
      'type': type,
  };
}

class ProcessStatus {
  final String pID;
  final String msg;
  final String name;
  final String status;
  final String uptime;

  const ProcessStatus({
    this.pID = '',
    this.msg = '',
    this.name = '',
    this.status = '',
    this.uptime = '',
  });

  factory ProcessStatus.fromJson(Map<String, dynamic> json) {
    return ProcessStatus(
      pID: json['PID'] as String? ?? '',
      msg: json['msg'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      uptime: json['uptime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'PID': pID,
      'msg': msg,
      'name': name,
      'status': status,
      'uptime': uptime,
  };
}

class UserGroupResponse {
  final List<String> groups;
  final List<UserInfo> users;

  const UserGroupResponse({
    this.groups = const [],
    this.users = const [],
  });

  factory UserGroupResponse.fromJson(Map<String, dynamic> json) {
    return UserGroupResponse(
      groups: (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      users: (json['users'] as List<dynamic>?)?.map((e) => UserInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'groups': groups,
      'users': users.map((e) => e.toJson()).toList(),
  };
}

class UserInfo {
  final String group;
  final String username;

  const UserInfo({
    this.group = '',
    this.username = '',
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      group: json['group'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'group': group,
      'username': username,
  };
}
