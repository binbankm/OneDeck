// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class BatchDelete {
  final bool force;
  final List<String> names;
  final String taskID;

  const BatchDelete({
    this.force = false,
    this.names = const [],
    this.taskID = '',
  });

  factory BatchDelete.fromJson(Map<String, dynamic> json) {
    return BatchDelete(
      force: json['force'] as bool? ?? false,
      names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'force': force,
      'names': names,
      'taskID': taskID,
  };
}

class ComposeCreate {
  final String dirName;
  final String env;
  final String file;
  final bool forcePull;
  final String from;
  final String name;
  final String path;
  final String taskID;
  final int template;

  const ComposeCreate({
    this.dirName = '',
    this.env = '',
    this.file = '',
    this.forcePull = false,
    this.from = '',
    this.name = '',
    this.path = '',
    this.taskID = '',
    this.template = 0,
  });

  factory ComposeCreate.fromJson(Map<String, dynamic> json) {
    return ComposeCreate(
      dirName: json['dirName'] as String? ?? '',
      env: json['env'] as String? ?? '',
      file: json['file'] as String? ?? '',
      forcePull: json['forcePull'] as bool? ?? false,
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      template: (json['template'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'dirName': dirName,
      'env': env,
      'file': file,
      'forcePull': forcePull,
      'from': from,
      'name': name,
      'path': path,
      'taskID': taskID,
      'template': template,
  };
}

class ComposeLogClean {
  final String detailPath;
  final String name;
  final String path;

  const ComposeLogClean({
    this.detailPath = '',
    this.name = '',
    this.path = '',
  });

  factory ComposeLogClean.fromJson(Map<String, dynamic> json) {
    return ComposeLogClean(
      detailPath: json['detailPath'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detailPath': detailPath,
      'name': name,
      'path': path,
  };
}

class ComposeOperation {
  final bool force;
  final String name;
  final String operation;
  final String path;
  final bool withFile;

  const ComposeOperation({
    this.force = false,
    this.name = '',
    this.operation = '',
    this.path = '',
    this.withFile = false,
  });

  factory ComposeOperation.fromJson(Map<String, dynamic> json) {
    return ComposeOperation(
      force: json['force'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      path: json['path'] as String? ?? '',
      withFile: json['withFile'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'force': force,
      'name': name,
      'operation': operation,
      'path': path,
      'withFile': withFile,
  };
}

class ComposePin {
  final bool isPinned;
  final String name;

  const ComposePin({
    this.isPinned = false,
    this.name = '',
  });

  factory ComposePin.fromJson(Map<String, dynamic> json) {
    return ComposePin(
      isPinned: json['isPinned'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'isPinned': isPinned,
      'name': name,
  };
}

class ComposeTemplateBatch {
  final List<ComposeTemplateCreate> templates;

  const ComposeTemplateBatch({
    this.templates = const [],
  });

  factory ComposeTemplateBatch.fromJson(Map<String, dynamic> json) {
    return ComposeTemplateBatch(
      templates: (json['templates'] as List<dynamic>?)?.map((e) => ComposeTemplateCreate.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'templates': templates.map((e) => e.toJson()).toList(),
  };
}

class ComposeTemplateCreate {
  final String content;
  final String description;
  final String name;

  const ComposeTemplateCreate({
    this.content = '',
    this.description = '',
    this.name = '',
  });

  factory ComposeTemplateCreate.fromJson(Map<String, dynamic> json) {
    return ComposeTemplateCreate(
      content: json['content'] as String? ?? '',
      description: json['description'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'description': description,
      'name': name,
  };
}

class ComposeTemplateInfo {
  final String content;
  final String createdAt;
  final String description;
  final int id;
  final String name;

  const ComposeTemplateInfo({
    this.content = '',
    this.createdAt = '',
    this.description = '',
    this.id = 0,
    this.name = '',
  });

  factory ComposeTemplateInfo.fromJson(Map<String, dynamic> json) {
    return ComposeTemplateInfo(
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'createdAt': createdAt,
      'description': description,
      'id': id,
      'name': name,
  };
}

class ComposeTemplateUpdate {
  final String content;
  final String description;
  final int id;

  const ComposeTemplateUpdate({
    this.content = '',
    this.description = '',
    this.id = 0,
  });

  factory ComposeTemplateUpdate.fromJson(Map<String, dynamic> json) {
    return ComposeTemplateUpdate(
      content: json['content'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'description': description,
      'id': id,
  };
}

class ComposeUpdate {
  final String content;
  final String detailPath;
  final String env;
  final bool forcePull;
  final String name;
  final String path;
  final String taskID;

  const ComposeUpdate({
    this.content = '',
    this.detailPath = '',
    this.env = '',
    this.forcePull = false,
    this.name = '',
    this.path = '',
    this.taskID = '',
  });

  factory ComposeUpdate.fromJson(Map<String, dynamic> json) {
    return ComposeUpdate(
      content: json['content'] as String? ?? '',
      detailPath: json['detailPath'] as String? ?? '',
      env: json['env'] as String? ?? '',
      forcePull: json['forcePull'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'detailPath': detailPath,
      'env': env,
      'forcePull': forcePull,
      'name': name,
      'path': path,
      'taskID': taskID,
  };
}

class ContainerCommit {
  final String author;
  final String comment;
  final String containerID;
  final String containerName;
  final String newImageName;
  final bool pause;
  final String taskID;

  const ContainerCommit({
    this.author = '',
    this.comment = '',
    this.containerID = '',
    this.containerName = '',
    this.newImageName = '',
    this.pause = false,
    this.taskID = '',
  });

  factory ContainerCommit.fromJson(Map<String, dynamic> json) {
    return ContainerCommit(
      author: json['author'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      containerID: json['containerID'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      newImageName: json['newImageName'] as String? ?? '',
      pause: json['pause'] as bool? ?? false,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'author': author,
      'comment': comment,
      'containerID': containerID,
      'containerName': containerName,
      'newImageName': newImageName,
      'pause': pause,
      'taskID': taskID,
  };
}

class ContainerFileBatchDeleteReq {
  final String containerID;
  final List<String> paths;

  const ContainerFileBatchDeleteReq({
    this.containerID = '',
    this.paths = const [],
  });

  factory ContainerFileBatchDeleteReq.fromJson(Map<String, dynamic> json) {
    return ContainerFileBatchDeleteReq(
      containerID: json['containerID'] as String? ?? '',
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'containerID': containerID,
      'paths': paths,
  };
}

class ContainerFileContent {
  final String content;
  final bool isBinary;
  final int size;
  final bool truncated;

  const ContainerFileContent({
    this.content = '',
    this.isBinary = false,
    this.size = 0,
    this.truncated = false,
  });

  factory ContainerFileContent.fromJson(Map<String, dynamic> json) {
    return ContainerFileContent(
      content: json['content'] as String? ?? '',
      isBinary: json['isBinary'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      truncated: json['truncated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'isBinary': isBinary,
      'size': size,
      'truncated': truncated,
  };
}

class ContainerFileInfo {
  final bool isDir;
  final bool isLink;
  final String linkTo;
  final String modTime;
  final String mode;
  final String name;
  final String path;
  final int size;

  const ContainerFileInfo({
    this.isDir = false,
    this.isLink = false,
    this.linkTo = '',
    this.modTime = '',
    this.mode = '',
    this.name = '',
    this.path = '',
    this.size = 0,
  });

  factory ContainerFileInfo.fromJson(Map<String, dynamic> json) {
    return ContainerFileInfo(
      isDir: json['isDir'] as bool? ?? false,
      isLink: json['isLink'] as bool? ?? false,
      linkTo: json['linkTo'] as String? ?? '',
      modTime: json['modTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'isDir': isDir,
      'isLink': isLink,
      'linkTo': linkTo,
      'modTime': modTime,
      'mode': mode,
      'name': name,
      'path': path,
      'size': size,
  };
}

class ContainerFileReq {
  final String containerID;
  final String path;

  const ContainerFileReq({
    this.containerID = '',
    this.path = '',
  });

  factory ContainerFileReq.fromJson(Map<String, dynamic> json) {
    return ContainerFileReq(
      containerID: json['containerID'] as String? ?? '',
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerID': containerID,
      'path': path,
  };
}

class ContainerItemStats {
  final int buildCacheReclaimable;
  final int buildCacheUsage;
  final int containerReclaimable;
  final int containerUsage;
  final int imageReclaimable;
  final int imageUsage;
  final int sizeRootFs;
  final int sizeRw;
  final int volumeReclaimable;
  final int volumeUsage;

  const ContainerItemStats({
    this.buildCacheReclaimable = 0,
    this.buildCacheUsage = 0,
    this.containerReclaimable = 0,
    this.containerUsage = 0,
    this.imageReclaimable = 0,
    this.imageUsage = 0,
    this.sizeRootFs = 0,
    this.sizeRw = 0,
    this.volumeReclaimable = 0,
    this.volumeUsage = 0,
  });

  factory ContainerItemStats.fromJson(Map<String, dynamic> json) {
    return ContainerItemStats(
      buildCacheReclaimable: (json['buildCacheReclaimable'] as num?)?.toInt() ?? 0,
      buildCacheUsage: (json['buildCacheUsage'] as num?)?.toInt() ?? 0,
      containerReclaimable: (json['containerReclaimable'] as num?)?.toInt() ?? 0,
      containerUsage: (json['containerUsage'] as num?)?.toInt() ?? 0,
      imageReclaimable: (json['imageReclaimable'] as num?)?.toInt() ?? 0,
      imageUsage: (json['imageUsage'] as num?)?.toInt() ?? 0,
      sizeRootFs: (json['sizeRootFs'] as num?)?.toInt() ?? 0,
      sizeRw: (json['sizeRw'] as num?)?.toInt() ?? 0,
      volumeReclaimable: (json['volumeReclaimable'] as num?)?.toInt() ?? 0,
      volumeUsage: (json['volumeUsage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'buildCacheReclaimable': buildCacheReclaimable,
      'buildCacheUsage': buildCacheUsage,
      'containerReclaimable': containerReclaimable,
      'containerUsage': containerUsage,
      'imageReclaimable': imageReclaimable,
      'imageUsage': imageUsage,
      'sizeRootFs': sizeRootFs,
      'sizeRw': sizeRw,
      'volumeReclaimable': volumeReclaimable,
      'volumeUsage': volumeUsage,
  };
}

class ContainerListStats {
  final String containerID;
  final double cpuPercent;
  final int cpuTotalUsage;
  final int memoryCache;
  final int memoryLimit;
  final double memoryPercent;
  final int memoryUsage;
  final int percpuUsage;
  final int systemUsage;

  const ContainerListStats({
    this.containerID = '',
    this.cpuPercent = 0.0,
    this.cpuTotalUsage = 0,
    this.memoryCache = 0,
    this.memoryLimit = 0,
    this.memoryPercent = 0.0,
    this.memoryUsage = 0,
    this.percpuUsage = 0,
    this.systemUsage = 0,
  });

  factory ContainerListStats.fromJson(Map<String, dynamic> json) {
    return ContainerListStats(
      containerID: json['containerID'] as String? ?? '',
      cpuPercent: (json['cpuPercent'] as num?)?.toDouble() ?? 0.0,
      cpuTotalUsage: (json['cpuTotalUsage'] as num?)?.toInt() ?? 0,
      memoryCache: (json['memoryCache'] as num?)?.toInt() ?? 0,
      memoryLimit: (json['memoryLimit'] as num?)?.toInt() ?? 0,
      memoryPercent: (json['memoryPercent'] as num?)?.toDouble() ?? 0.0,
      memoryUsage: (json['memoryUsage'] as num?)?.toInt() ?? 0,
      percpuUsage: (json['percpuUsage'] as num?)?.toInt() ?? 0,
      systemUsage: (json['systemUsage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'containerID': containerID,
      'cpuPercent': cpuPercent,
      'cpuTotalUsage': cpuTotalUsage,
      'memoryCache': memoryCache,
      'memoryLimit': memoryLimit,
      'memoryPercent': memoryPercent,
      'memoryUsage': memoryUsage,
      'percpuUsage': percpuUsage,
      'systemUsage': systemUsage,
  };
}

class ContainerLog {
  final String container;
  final String containerType;
  final String since;
  final int tail;
  final bool timestamp;

  const ContainerLog({
    this.container = '',
    this.containerType = '',
    this.since = '',
    this.tail = 0,
    this.timestamp = false,
  });

  factory ContainerLog.fromJson(Map<String, dynamic> json) {
    return ContainerLog(
      container: json['container'] as String? ?? '',
      containerType: json['containerType'] as String? ?? '',
      since: json['since'] as String? ?? '',
      tail: (json['tail'] as num?)?.toInt() ?? 0,
      timestamp: json['timestamp'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'container': container,
      'containerType': containerType,
      'since': since,
      'tail': tail,
      'timestamp': timestamp,
  };
}

class ContainerNetwork {
  final List<String> aliases;
  final Map<String, dynamic> driverOpts;
  final int gwPriority;
  final String ipv4;
  final String ipv6;
  final List<String> linkLocalIPs;
  final List<String> links;
  final String macAddr;
  final String network;

  const ContainerNetwork({
    this.aliases = const [],
    this.driverOpts = const {},
    this.gwPriority = 0,
    this.ipv4 = '',
    this.ipv6 = '',
    this.linkLocalIPs = const [],
    this.links = const [],
    this.macAddr = '',
    this.network = '',
  });

  factory ContainerNetwork.fromJson(Map<String, dynamic> json) {
    return ContainerNetwork(
      aliases: (json['aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      driverOpts: json['driverOpts'] as Map<String, dynamic>? ?? const {},
      gwPriority: (json['gwPriority'] as num?)?.toInt() ?? 0,
      ipv4: json['ipv4'] as String? ?? '',
      ipv6: json['ipv6'] as String? ?? '',
      linkLocalIPs: (json['linkLocalIPs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      links: (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      macAddr: json['macAddr'] as String? ?? '',
      network: json['network'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'aliases': aliases,
      'driverOpts': driverOpts,
      'gwPriority': gwPriority,
      'ipv4': ipv4,
      'ipv6': ipv6,
      'linkLocalIPs': linkLocalIPs,
      'links': links,
      'macAddr': macAddr,
      'network': network,
  };
}

class ContainerOperate {
  final bool autoRemove;
  final List<String> cmd;
  final int cpuShares;
  final List<String> dns;
  final String domainName;
  final List<String> entrypoint;
  final List<String> env;
  final List<PortHelper> exposedPorts;
  final List<ExtraHost> extraHosts;
  final bool forcePull;
  final String hostname;
  final String image;
  final List<String> labels;
  final double memory;
  final String name;
  final double nanoCPUs;
  final List<ContainerNetwork> networks;
  final bool openStdin;
  final bool privileged;
  final bool publishAllPorts;
  final String restartPolicy;
  final String taskID;
  final bool tty;
  final String user;
  final List<VolumeHelper> volumes;
  final String workingDir;

  const ContainerOperate({
    this.autoRemove = false,
    this.cmd = const [],
    this.cpuShares = 0,
    this.dns = const [],
    this.domainName = '',
    this.entrypoint = const [],
    this.env = const [],
    this.exposedPorts = const [],
    this.extraHosts = const [],
    this.forcePull = false,
    this.hostname = '',
    this.image = '',
    this.labels = const [],
    this.memory = 0.0,
    this.name = '',
    this.nanoCPUs = 0.0,
    this.networks = const [],
    this.openStdin = false,
    this.privileged = false,
    this.publishAllPorts = false,
    this.restartPolicy = '',
    this.taskID = '',
    this.tty = false,
    this.user = '',
    this.volumes = const [],
    this.workingDir = '',
  });

  factory ContainerOperate.fromJson(Map<String, dynamic> json) {
    return ContainerOperate(
      autoRemove: json['autoRemove'] as bool? ?? false,
      cmd: (json['cmd'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      cpuShares: (json['cpuShares'] as num?)?.toInt() ?? 0,
      dns: (json['dns'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      domainName: json['domainName'] as String? ?? '',
      entrypoint: (json['entrypoint'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      env: (json['env'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => PortHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extraHosts: (json['extraHosts'] as List<dynamic>?)?.map((e) => ExtraHost.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      forcePull: json['forcePull'] as bool? ?? false,
      hostname: json['hostname'] as String? ?? '',
      image: json['image'] as String? ?? '',
      labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      memory: (json['memory'] as num?)?.toDouble() ?? 0.0,
      name: json['name'] as String? ?? '',
      nanoCPUs: (json['nanoCPUs'] as num?)?.toDouble() ?? 0.0,
      networks: (json['networks'] as List<dynamic>?)?.map((e) => ContainerNetwork.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      openStdin: json['openStdin'] as bool? ?? false,
      privileged: json['privileged'] as bool? ?? false,
      publishAllPorts: json['publishAllPorts'] as bool? ?? false,
      restartPolicy: json['restartPolicy'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      tty: json['tty'] as bool? ?? false,
      user: json['user'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => VolumeHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      workingDir: json['workingDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoRemove': autoRemove,
      'cmd': cmd,
      'cpuShares': cpuShares,
      'dns': dns,
      'domainName': domainName,
      'entrypoint': entrypoint,
      'env': env,
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'extraHosts': extraHosts.map((e) => e.toJson()).toList(),
      'forcePull': forcePull,
      'hostname': hostname,
      'image': image,
      'labels': labels,
      'memory': memory,
      'name': name,
      'nanoCPUs': nanoCPUs,
      'networks': networks.map((e) => e.toJson()).toList(),
      'openStdin': openStdin,
      'privileged': privileged,
      'publishAllPorts': publishAllPorts,
      'restartPolicy': restartPolicy,
      'taskID': taskID,
      'tty': tty,
      'user': user,
      'volumes': volumes.map((e) => e.toJson()).toList(),
      'workingDir': workingDir,
  };
}

class ContainerOperation {
  final List<String> names;
  final String operation;
  final String taskID;

  const ContainerOperation({
    this.names = const [],
    this.operation = '',
    this.taskID = '',
  });

  factory ContainerOperation.fromJson(Map<String, dynamic> json) {
    return ContainerOperation(
      names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      operation: json['operation'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'names': names,
      'operation': operation,
      'taskID': taskID,
  };
}

class ContainerOptions {
  final String name;
  final String state;

  const ContainerOptions({
    this.name = '',
    this.state = '',
  });

  factory ContainerOptions.fromJson(Map<String, dynamic> json) {
    return ContainerOptions(
      name: json['name'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'state': state,
  };
}

class ContainerPrune {
  final String pruneType;
  final String taskID;
  final bool withTagAll;

  const ContainerPrune({
    this.pruneType = '',
    this.taskID = '',
    this.withTagAll = false,
  });

  factory ContainerPrune.fromJson(Map<String, dynamic> json) {
    return ContainerPrune(
      pruneType: json['pruneType'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      withTagAll: json['withTagAll'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'pruneType': pruneType,
      'taskID': taskID,
      'withTagAll': withTagAll,
  };
}

class ContainerRename {
  final String name;
  final String newName;

  const ContainerRename({
    this.name = '',
    this.newName = '',
  });

  factory ContainerRename.fromJson(Map<String, dynamic> json) {
    return ContainerRename(
      name: json['name'] as String? ?? '',
      newName: json['newName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'newName': newName,
  };
}

class ContainerStats {
  final double cache;
  final double cpuPercent;
  final double ioRead;
  final double ioWrite;
  final double memory;
  final double networkRX;
  final double networkTX;
  final String shotTime;

  const ContainerStats({
    this.cache = 0.0,
    this.cpuPercent = 0.0,
    this.ioRead = 0.0,
    this.ioWrite = 0.0,
    this.memory = 0.0,
    this.networkRX = 0.0,
    this.networkTX = 0.0,
    this.shotTime = '',
  });

  factory ContainerStats.fromJson(Map<String, dynamic> json) {
    return ContainerStats(
      cache: (json['cache'] as num?)?.toDouble() ?? 0.0,
      cpuPercent: (json['cpuPercent'] as num?)?.toDouble() ?? 0.0,
      ioRead: (json['ioRead'] as num?)?.toDouble() ?? 0.0,
      ioWrite: (json['ioWrite'] as num?)?.toDouble() ?? 0.0,
      memory: (json['memory'] as num?)?.toDouble() ?? 0.0,
      networkRX: (json['networkRX'] as num?)?.toDouble() ?? 0.0,
      networkTX: (json['networkTX'] as num?)?.toDouble() ?? 0.0,
      shotTime: json['shotTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cache': cache,
      'cpuPercent': cpuPercent,
      'ioRead': ioRead,
      'ioWrite': ioWrite,
      'memory': memory,
      'networkRX': networkRX,
      'networkTX': networkTX,
      'shotTime': shotTime,
  };
}

class ContainerStatus {
  final int composeCount;
  final int composeTemplateCount;
  final int containerCount;
  final int created;
  final int dead;
  final int exited;
  final int imageCount;
  final int networkCount;
  final int paused;
  final int removing;
  final int repoCount;
  final int restarting;
  final int running;
  final int volumeCount;

  const ContainerStatus({
    this.composeCount = 0,
    this.composeTemplateCount = 0,
    this.containerCount = 0,
    this.created = 0,
    this.dead = 0,
    this.exited = 0,
    this.imageCount = 0,
    this.networkCount = 0,
    this.paused = 0,
    this.removing = 0,
    this.repoCount = 0,
    this.restarting = 0,
    this.running = 0,
    this.volumeCount = 0,
  });

  factory ContainerStatus.fromJson(Map<String, dynamic> json) {
    return ContainerStatus(
      composeCount: (json['composeCount'] as num?)?.toInt() ?? 0,
      composeTemplateCount: (json['composeTemplateCount'] as num?)?.toInt() ?? 0,
      containerCount: (json['containerCount'] as num?)?.toInt() ?? 0,
      created: (json['created'] as num?)?.toInt() ?? 0,
      dead: (json['dead'] as num?)?.toInt() ?? 0,
      exited: (json['exited'] as num?)?.toInt() ?? 0,
      imageCount: (json['imageCount'] as num?)?.toInt() ?? 0,
      networkCount: (json['networkCount'] as num?)?.toInt() ?? 0,
      paused: (json['paused'] as num?)?.toInt() ?? 0,
      removing: (json['removing'] as num?)?.toInt() ?? 0,
      repoCount: (json['repoCount'] as num?)?.toInt() ?? 0,
      restarting: (json['restarting'] as num?)?.toInt() ?? 0,
      running: (json['running'] as num?)?.toInt() ?? 0,
      volumeCount: (json['volumeCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'composeCount': composeCount,
      'composeTemplateCount': composeTemplateCount,
      'containerCount': containerCount,
      'created': created,
      'dead': dead,
      'exited': exited,
      'imageCount': imageCount,
      'networkCount': networkCount,
      'paused': paused,
      'removing': removing,
      'repoCount': repoCount,
      'restarting': restarting,
      'running': running,
      'volumeCount': volumeCount,
  };
}

class ContainerUpgrade {
  final bool forcePull;
  final String image;
  final List<String> names;
  final String taskID;

  const ContainerUpgrade({
    this.forcePull = false,
    this.image = '',
    this.names = const [],
    this.taskID = '',
  });

  factory ContainerUpgrade.fromJson(Map<String, dynamic> json) {
    return ContainerUpgrade(
      forcePull: json['forcePull'] as bool? ?? false,
      image: json['image'] as String? ?? '',
      names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'forcePull': forcePull,
      'image': image,
      'names': names,
      'taskID': taskID,
  };
}

class DaemonJsonConf {
  final String cgroupDriver;
  final bool experimental;
  final String fixedCidrV6;
  final List<String> insecureRegistries;
  final bool ip6Tables;
  final bool iptables;
  final bool ipv6;
  final bool isSwarm;
  final bool liveRestore;
  final String logMaxFile;
  final String logMaxSize;
  final List<String> registryMirrors;
  final String version;

  const DaemonJsonConf({
    this.cgroupDriver = '',
    this.experimental = false,
    this.fixedCidrV6 = '',
    this.insecureRegistries = const [],
    this.ip6Tables = false,
    this.iptables = false,
    this.ipv6 = false,
    this.isSwarm = false,
    this.liveRestore = false,
    this.logMaxFile = '',
    this.logMaxSize = '',
    this.registryMirrors = const [],
    this.version = '',
  });

  factory DaemonJsonConf.fromJson(Map<String, dynamic> json) {
    return DaemonJsonConf(
      cgroupDriver: json['cgroupDriver'] as String? ?? '',
      experimental: json['experimental'] as bool? ?? false,
      fixedCidrV6: json['fixedCidrV6'] as String? ?? '',
      insecureRegistries: (json['insecureRegistries'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      ip6Tables: json['ip6Tables'] as bool? ?? false,
      iptables: json['iptables'] as bool? ?? false,
      ipv6: json['ipv6'] as bool? ?? false,
      isSwarm: json['isSwarm'] as bool? ?? false,
      liveRestore: json['liveRestore'] as bool? ?? false,
      logMaxFile: json['logMaxFile'] as String? ?? '',
      logMaxSize: json['logMaxSize'] as String? ?? '',
      registryMirrors: (json['registryMirrors'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cgroupDriver': cgroupDriver,
      'experimental': experimental,
      'fixedCidrV6': fixedCidrV6,
      'insecureRegistries': insecureRegistries,
      'ip6Tables': ip6Tables,
      'iptables': iptables,
      'ipv6': ipv6,
      'isSwarm': isSwarm,
      'liveRestore': liveRestore,
      'logMaxFile': logMaxFile,
      'logMaxSize': logMaxSize,
      'registryMirrors': registryMirrors,
      'version': version,
  };
}

class DaemonJsonUpdateByFile {
  final String file;

  const DaemonJsonUpdateByFile({
    this.file = '',
  });

  factory DaemonJsonUpdateByFile.fromJson(Map<String, dynamic> json) {
    return DaemonJsonUpdateByFile(
      file: json['file'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'file': file,
  };
}

class DockerOperation {
  final String operation;

  const DockerOperation({
    this.operation = '',
  });

  factory DockerOperation.fromJson(Map<String, dynamic> json) {
    return DockerOperation(
      operation: json['operation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
  };
}

class DockerStatus {
  final bool isActive;
  final bool isExist;

  const DockerStatus({
    this.isActive = false,
    this.isExist = false,
  });

  factory DockerStatus.fromJson(Map<String, dynamic> json) {
    return DockerStatus(
      isActive: json['isActive'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'isActive': isActive,
      'isExist': isExist,
  };
}

class ExtraHost {
  final String hostname;
  final String ip;

  const ExtraHost({
    this.hostname = '',
    this.ip = '',
  });

  factory ExtraHost.fromJson(Map<String, dynamic> json) {
    return ExtraHost(
      hostname: json['hostname'] as String? ?? '',
      ip: json['ip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'hostname': hostname,
      'ip': ip,
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

class ImageBuild {
  final List<String> args;
  final String dockerfile;
  final String from;
  final String name;
  final List<String> tags;
  final String taskID;

  const ImageBuild({
    this.args = const [],
    this.dockerfile = '',
    this.from = '',
    this.name = '',
    this.tags = const [],
    this.taskID = '',
  });

  factory ImageBuild.fromJson(Map<String, dynamic> json) {
    return ImageBuild(
      args: (json['args'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      dockerfile: json['dockerfile'] as String? ?? '',
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'args': args,
      'dockerfile': dockerfile,
      'from': from,
      'name': name,
      'tags': tags,
      'taskID': taskID,
  };
}

class ImageInfo {
  final String createdAt;
  final String description;
  final String id;
  final bool isPinned;
  final bool isUsed;
  final int size;
  final List<String> tags;

  const ImageInfo({
    this.createdAt = '',
    this.description = '',
    this.id = '',
    this.isPinned = false,
    this.isUsed = false,
    this.size = 0,
    this.tags = const [],
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: json['id'] as String? ?? '',
      isPinned: json['isPinned'] as bool? ?? false,
      isUsed: json['isUsed'] as bool? ?? false,
      size: (json['size'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'createdAt': createdAt,
      'description': description,
      'id': id,
      'isPinned': isPinned,
      'isUsed': isUsed,
      'size': size,
      'tags': tags,
  };
}

class ImageLoad {
  final List<String> paths;
  final String taskID;

  const ImageLoad({
    this.paths = const [],
    this.taskID = '',
  });

  factory ImageLoad.fromJson(Map<String, dynamic> json) {
    return ImageLoad(
      paths: (json['paths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'paths': paths,
      'taskID': taskID,
  };
}

class ImagePull {
  final List<String> imageName;
  final int repoID;
  final String taskID;

  const ImagePull({
    this.imageName = const [],
    this.repoID = 0,
    this.taskID = '',
  });

  factory ImagePull.fromJson(Map<String, dynamic> json) {
    return ImagePull(
      imageName: (json['imageName'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      repoID: (json['repoID'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'imageName': imageName,
      'repoID': repoID,
      'taskID': taskID,
  };
}

class ImagePush {
  final String name;
  final int repoID;
  final String tagName;
  final String taskID;

  const ImagePush({
    this.name = '',
    this.repoID = 0,
    this.tagName = '',
    this.taskID = '',
  });

  factory ImagePush.fromJson(Map<String, dynamic> json) {
    return ImagePush(
      name: json['name'] as String? ?? '',
      repoID: (json['repoID'] as num?)?.toInt() ?? 0,
      tagName: json['tagName'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'repoID': repoID,
      'tagName': tagName,
      'taskID': taskID,
  };
}

class ImageRepoDelete {
  final List<int> ids;

  const ImageRepoDelete({
    this.ids = const [],
  });

  factory ImageRepoDelete.fromJson(Map<String, dynamic> json) {
    return ImageRepoDelete(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class ImageRepoOption {
  final String downloadUrl;
  final int id;
  final String name;

  const ImageRepoOption({
    this.downloadUrl = '',
    this.id = 0,
    this.name = '',
  });

  factory ImageRepoOption.fromJson(Map<String, dynamic> json) {
    return ImageRepoOption(
      downloadUrl: json['downloadUrl'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'downloadUrl': downloadUrl,
      'id': id,
      'name': name,
  };
}

class ImageRepoUpdate {
  final bool auth;
  final String downloadUrl;
  final int id;
  final String password;
  final String protocol;
  final String username;

  const ImageRepoUpdate({
    this.auth = false,
    this.downloadUrl = '',
    this.id = 0,
    this.password = '',
    this.protocol = '',
    this.username = '',
  });

  factory ImageRepoUpdate.fromJson(Map<String, dynamic> json) {
    return ImageRepoUpdate(
      auth: json['auth'] as bool? ?? false,
      downloadUrl: json['downloadUrl'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      password: json['password'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'auth': auth,
      'downloadUrl': downloadUrl,
      'id': id,
      'password': password,
      'protocol': protocol,
      'username': username,
  };
}

class ImageSave {
  final String name;
  final String path;
  final String tagName;
  final String taskID;

  const ImageSave({
    this.name = '',
    this.path = '',
    this.tagName = '',
    this.taskID = '',
  });

  factory ImageSave.fromJson(Map<String, dynamic> json) {
    return ImageSave(
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      tagName: json['tagName'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'path': path,
      'tagName': tagName,
      'taskID': taskID,
  };
}

class ImageTag {
  final String sourceID;
  final List<String> tags;

  const ImageTag({
    this.sourceID = '',
    this.tags = const [],
  });

  factory ImageTag.fromJson(Map<String, dynamic> json) {
    return ImageTag(
      sourceID: json['sourceID'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'sourceID': sourceID,
      'tags': tags,
  };
}

class InspectReq {
  final String detail;
  final String id;
  final String type;

  const InspectReq({
    this.detail = '',
    this.id = '',
    this.type = '',
  });

  factory InspectReq.fromJson(Map<String, dynamic> json) {
    return InspectReq(
      detail: json['detail'] as String? ?? '',
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detail': detail,
      'id': id,
      'type': type,
  };
}

class LogOption {
  final String logMaxFile;
  final String logMaxSize;

  const LogOption({
    this.logMaxFile = '',
    this.logMaxSize = '',
  });

  factory LogOption.fromJson(Map<String, dynamic> json) {
    return LogOption(
      logMaxFile: json['logMaxFile'] as String? ?? '',
      logMaxSize: json['logMaxSize'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'logMaxFile': logMaxFile,
      'logMaxSize': logMaxSize,
  };
}

class NetworkCreate {
  final List<SettingUpdate> auxAddress;
  final List<SettingUpdate> auxAddressV6;
  final String driver;
  final String gateway;
  final String gatewayV6;
  final String ipRange;
  final String ipRangeV6;
  final bool ipv4;
  final bool ipv6;
  final List<String> labels;
  final String name;
  final List<String> options;
  final String subnet;
  final String subnetV6;

  const NetworkCreate({
    this.auxAddress = const [],
    this.auxAddressV6 = const [],
    this.driver = '',
    this.gateway = '',
    this.gatewayV6 = '',
    this.ipRange = '',
    this.ipRangeV6 = '',
    this.ipv4 = false,
    this.ipv6 = false,
    this.labels = const [],
    this.name = '',
    this.options = const [],
    this.subnet = '',
    this.subnetV6 = '',
  });

  factory NetworkCreate.fromJson(Map<String, dynamic> json) {
    return NetworkCreate(
      auxAddress: (json['auxAddress'] as List<dynamic>?)?.map((e) => SettingUpdate.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      auxAddressV6: (json['auxAddressV6'] as List<dynamic>?)?.map((e) => SettingUpdate.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      driver: json['driver'] as String? ?? '',
      gateway: json['gateway'] as String? ?? '',
      gatewayV6: json['gatewayV6'] as String? ?? '',
      ipRange: json['ipRange'] as String? ?? '',
      ipRangeV6: json['ipRangeV6'] as String? ?? '',
      ipv4: json['ipv4'] as bool? ?? false,
      ipv6: json['ipv6'] as bool? ?? false,
      labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      name: json['name'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      subnet: json['subnet'] as String? ?? '',
      subnetV6: json['subnetV6'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'auxAddress': auxAddress.map((e) => e.toJson()).toList(),
      'auxAddressV6': auxAddressV6.map((e) => e.toJson()).toList(),
      'driver': driver,
      'gateway': gateway,
      'gatewayV6': gatewayV6,
      'ipRange': ipRange,
      'ipRangeV6': ipRangeV6,
      'ipv4': ipv4,
      'ipv6': ipv6,
      'labels': labels,
      'name': name,
      'options': options,
      'subnet': subnet,
      'subnetV6': subnetV6,
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

class Options {
  final String option;

  const Options({
    this.option = '',
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      option: json['option'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'option': option,
  };
}

class PageContainer {
  final bool excludeAppStore;
  final String filters;
  final String name;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;
  final String state;

  const PageContainer({
    this.excludeAppStore = false,
    this.filters = '',
    this.name = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
    this.state = '',
  });

  factory PageContainer.fromJson(Map<String, dynamic> json) {
    return PageContainer(
      excludeAppStore: json['excludeAppStore'] as bool? ?? false,
      filters: json['filters'] as String? ?? '',
      name: json['name'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      state: json['state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'excludeAppStore': excludeAppStore,
      'filters': filters,
      'name': name,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'state': state,
  };
}

class PageImage {
  final String name;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const PageImage({
    this.name = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory PageImage.fromJson(Map<String, dynamic> json) {
    return PageImage(
      name: json['name'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'order': order,
      'orderBy': orderBy,
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

class PortHelper {
  final String containerPort;
  final String hostIP;
  final String hostPort;
  final String protocol;

  const PortHelper({
    this.containerPort = '',
    this.hostIP = '',
    this.hostPort = '',
    this.protocol = '',
  });

  factory PortHelper.fromJson(Map<String, dynamic> json) {
    return PortHelper(
      containerPort: json['containerPort'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      hostPort: json['hostPort'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerPort': containerPort,
      'hostIP': hostIP,
      'hostPort': hostPort,
      'protocol': protocol,
  };
}

class ResourceLimit {
  final int cpu;
  final int memory;

  const ResourceLimit({
    this.cpu = 0,
    this.memory = 0,
  });

  factory ResourceLimit.fromJson(Map<String, dynamic> json) {
    return ResourceLimit(
      cpu: (json['cpu'] as num?)?.toInt() ?? 0,
      memory: (json['memory'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'cpu': cpu,
      'memory': memory,
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

class VolumeCreate {
  final String driver;
  final List<String> labels;
  final String name;
  final List<String> options;

  const VolumeCreate({
    this.driver = '',
    this.labels = const [],
    this.name = '',
    this.options = const [],
  });

  factory VolumeCreate.fromJson(Map<String, dynamic> json) {
    return VolumeCreate(
      driver: json['driver'] as String? ?? '',
      labels: (json['labels'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      name: json['name'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'driver': driver,
      'labels': labels,
      'name': name,
      'options': options,
  };
}

class VolumeHelper {
  final String containerDir;
  final String mode;
  final String shared;
  final String sourceDir;
  final String type;

  const VolumeHelper({
    this.containerDir = '',
    this.mode = '',
    this.shared = '',
    this.sourceDir = '',
    this.type = '',
  });

  factory VolumeHelper.fromJson(Map<String, dynamic> json) {
    return VolumeHelper(
      containerDir: json['containerDir'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      shared: json['shared'] as String? ?? '',
      sourceDir: json['sourceDir'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerDir': containerDir,
      'mode': mode,
      'shared': shared,
      'sourceDir': sourceDir,
      'type': type,
  };
}
