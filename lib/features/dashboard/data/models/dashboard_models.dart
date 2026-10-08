// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AppLauncher {
  final String description;
  final List<InstallDetail> detail;
  final String icon;
  final bool isInstall;
  final bool isRecommend;
  final String key;
  final int limit;
  final String name;
  final int recommend;
  final String type;

  const AppLauncher({
    this.description = '',
    this.detail = const [],
    this.icon = '',
    this.isInstall = false,
    this.isRecommend = false,
    this.key = '',
    this.limit = 0,
    this.name = '',
    this.recommend = 0,
    this.type = '',
  });

  factory AppLauncher.fromJson(Map<String, dynamic> json) {
    return AppLauncher(
      description: json['description'] as String? ?? '',
      detail: (json['detail'] as List<dynamic>?)?.map((e) => InstallDetail.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      icon: json['icon'] as String? ?? '',
      isInstall: json['isInstall'] as bool? ?? false,
      isRecommend: json['isRecommend'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'detail': detail.map((e) => e.toJson()).toList(),
      'icon': icon,
      'isInstall': isInstall,
      'isRecommend': isRecommend,
      'key': key,
      'limit': limit,
      'name': name,
      'recommend': recommend,
      'type': type,
  };
}

class ChangeQuicks {
  final List<QuickJump> quicks;

  const ChangeQuicks({
    this.quicks = const [],
  });

  factory ChangeQuicks.fromJson(Map<String, dynamic> json) {
    return ChangeQuicks(
      quicks: (json['quicks'] as List<dynamic>?)?.map((e) => QuickJump.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'quicks': quicks.map((e) => e.toJson()).toList(),
  };
}

class DashboardBase {
  final int agentNumber;
  final int appInstalledNumber;
  final int cpuCores;
  final int cpuLogicalCores;
  final double cpuMhz;
  final String cpuModelName;
  final int cronjobNumber;
  final DashboardCurrent? currentInfo;
  final int databaseNumber;
  final String hostname;
  final String ipV4Addr;
  final String kernelArch;
  final String kernelVersion;
  final String os;
  final String platform;
  final String platformFamily;
  final String platformVersion;
  final String prettyDistro;
  final List<QuickJump> quickJump;
  final String systemProxy;
  final String virtualizationSystem;
  final int websiteNumber;

  const DashboardBase({
    this.agentNumber = 0,
    this.appInstalledNumber = 0,
    this.cpuCores = 0,
    this.cpuLogicalCores = 0,
    this.cpuMhz = 0.0,
    this.cpuModelName = '',
    this.cronjobNumber = 0,
    this.currentInfo,
    this.databaseNumber = 0,
    this.hostname = '',
    this.ipV4Addr = '',
    this.kernelArch = '',
    this.kernelVersion = '',
    this.os = '',
    this.platform = '',
    this.platformFamily = '',
    this.platformVersion = '',
    this.prettyDistro = '',
    this.quickJump = const [],
    this.systemProxy = '',
    this.virtualizationSystem = '',
    this.websiteNumber = 0,
  });

  factory DashboardBase.fromJson(Map<String, dynamic> json) {
    return DashboardBase(
      agentNumber: (json['agentNumber'] as num?)?.toInt() ?? 0,
      appInstalledNumber: (json['appInstalledNumber'] as num?)?.toInt() ?? 0,
      cpuCores: (json['cpuCores'] as num?)?.toInt() ?? 0,
      cpuLogicalCores: (json['cpuLogicalCores'] as num?)?.toInt() ?? 0,
      cpuMhz: (json['cpuMhz'] as num?)?.toDouble() ?? 0.0,
      cpuModelName: json['cpuModelName'] as String? ?? '',
      cronjobNumber: (json['cronjobNumber'] as num?)?.toInt() ?? 0,
      currentInfo: json['currentInfo'] != null ? DashboardCurrent.fromJson(json['currentInfo'] as Map<String, dynamic>) : null,
      databaseNumber: (json['databaseNumber'] as num?)?.toInt() ?? 0,
      hostname: json['hostname'] as String? ?? '',
      ipV4Addr: json['ipV4Addr'] as String? ?? '',
      kernelArch: json['kernelArch'] as String? ?? '',
      kernelVersion: json['kernelVersion'] as String? ?? '',
      os: json['os'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      platformFamily: json['platformFamily'] as String? ?? '',
      platformVersion: json['platformVersion'] as String? ?? '',
      prettyDistro: json['prettyDistro'] as String? ?? '',
      quickJump: (json['quickJump'] as List<dynamic>?)?.map((e) => QuickJump.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      systemProxy: json['systemProxy'] as String? ?? '',
      virtualizationSystem: json['virtualizationSystem'] as String? ?? '',
      websiteNumber: (json['websiteNumber'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentNumber': agentNumber,
      'appInstalledNumber': appInstalledNumber,
      'cpuCores': cpuCores,
      'cpuLogicalCores': cpuLogicalCores,
      'cpuMhz': cpuMhz,
      'cpuModelName': cpuModelName,
      'cronjobNumber': cronjobNumber,
      if (currentInfo != null) 'currentInfo': currentInfo!.toJson(),
      'databaseNumber': databaseNumber,
      'hostname': hostname,
      'ipV4Addr': ipV4Addr,
      'kernelArch': kernelArch,
      'kernelVersion': kernelVersion,
      'os': os,
      'platform': platform,
      'platformFamily': platformFamily,
      'platformVersion': platformVersion,
      'prettyDistro': prettyDistro,
      'quickJump': quickJump.map((e) => e.toJson()).toList(),
      'systemProxy': systemProxy,
      'virtualizationSystem': virtualizationSystem,
      'websiteNumber': websiteNumber,
  };
}

class DashboardCurrent {
  final List<double> cpuDetailedPercent;
  final List<double> cpuPercent;
  final int cpuTotal;
  final double cpuUsed;
  final double cpuUsedPercent;
  final List<DiskInfo> diskData;
  final List<GPUInfo> gpuData;
  final int ioCount;
  final int ioReadBytes;
  final int ioReadTime;
  final int ioWriteBytes;
  final int ioWriteTime;
  final double load1;
  final double load15;
  final double load5;
  final double loadUsagePercent;
  final int memoryAvailable;
  final int memoryCache;
  final int memoryFree;
  final int memoryShard;
  final int memoryTotal;
  final int memoryUsed;
  final double memoryUsedPercent;
  final int netBytesRecv;
  final int netBytesSent;
  final int procs;
  final RunningTime? runningTime;
  final String shotTime;
  final int swapMemoryAvailable;
  final int swapMemoryTotal;
  final int swapMemoryUsed;
  final double swapMemoryUsedPercent;
  final String timeSinceUptime;
  final List<Process> topCPUItems;
  final List<Process> topMemItems;
  final int uptime;
  final List<XPUInfo> xpuData;

  const DashboardCurrent({
    this.cpuDetailedPercent = const [],
    this.cpuPercent = const [],
    this.cpuTotal = 0,
    this.cpuUsed = 0.0,
    this.cpuUsedPercent = 0.0,
    this.diskData = const [],
    this.gpuData = const [],
    this.ioCount = 0,
    this.ioReadBytes = 0,
    this.ioReadTime = 0,
    this.ioWriteBytes = 0,
    this.ioWriteTime = 0,
    this.load1 = 0.0,
    this.load15 = 0.0,
    this.load5 = 0.0,
    this.loadUsagePercent = 0.0,
    this.memoryAvailable = 0,
    this.memoryCache = 0,
    this.memoryFree = 0,
    this.memoryShard = 0,
    this.memoryTotal = 0,
    this.memoryUsed = 0,
    this.memoryUsedPercent = 0.0,
    this.netBytesRecv = 0,
    this.netBytesSent = 0,
    this.procs = 0,
    this.runningTime,
    this.shotTime = '',
    this.swapMemoryAvailable = 0,
    this.swapMemoryTotal = 0,
    this.swapMemoryUsed = 0,
    this.swapMemoryUsedPercent = 0.0,
    this.timeSinceUptime = '',
    this.topCPUItems = const [],
    this.topMemItems = const [],
    this.uptime = 0,
    this.xpuData = const [],
  });

  factory DashboardCurrent.fromJson(Map<String, dynamic> json) {
    return DashboardCurrent(
      cpuDetailedPercent: (json['cpuDetailedPercent'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      cpuPercent: (json['cpuPercent'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      cpuTotal: (json['cpuTotal'] as num?)?.toInt() ?? 0,
      cpuUsed: (json['cpuUsed'] as num?)?.toDouble() ?? 0.0,
      cpuUsedPercent: (json['cpuUsedPercent'] as num?)?.toDouble() ?? 0.0,
      diskData: (json['diskData'] as List<dynamic>?)?.map((e) => DiskInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      gpuData: (json['gpuData'] as List<dynamic>?)?.map((e) => GPUInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      ioCount: (json['ioCount'] as num?)?.toInt() ?? 0,
      ioReadBytes: (json['ioReadBytes'] as num?)?.toInt() ?? 0,
      ioReadTime: (json['ioReadTime'] as num?)?.toInt() ?? 0,
      ioWriteBytes: (json['ioWriteBytes'] as num?)?.toInt() ?? 0,
      ioWriteTime: (json['ioWriteTime'] as num?)?.toInt() ?? 0,
      load1: (json['load1'] as num?)?.toDouble() ?? 0.0,
      load15: (json['load15'] as num?)?.toDouble() ?? 0.0,
      load5: (json['load5'] as num?)?.toDouble() ?? 0.0,
      loadUsagePercent: (json['loadUsagePercent'] as num?)?.toDouble() ?? 0.0,
      memoryAvailable: (json['memoryAvailable'] as num?)?.toInt() ?? 0,
      memoryCache: (json['memoryCache'] as num?)?.toInt() ?? 0,
      memoryFree: (json['memoryFree'] as num?)?.toInt() ?? 0,
      memoryShard: (json['memoryShard'] as num?)?.toInt() ?? 0,
      memoryTotal: (json['memoryTotal'] as num?)?.toInt() ?? 0,
      memoryUsed: (json['memoryUsed'] as num?)?.toInt() ?? 0,
      memoryUsedPercent: (json['memoryUsedPercent'] as num?)?.toDouble() ?? 0.0,
      netBytesRecv: (json['netBytesRecv'] as num?)?.toInt() ?? 0,
      netBytesSent: (json['netBytesSent'] as num?)?.toInt() ?? 0,
      procs: (json['procs'] as num?)?.toInt() ?? 0,
      runningTime: json['runningTime'] != null ? RunningTime.fromJson(json['runningTime'] as Map<String, dynamic>) : null,
      shotTime: json['shotTime'] as String? ?? '',
      swapMemoryAvailable: (json['swapMemoryAvailable'] as num?)?.toInt() ?? 0,
      swapMemoryTotal: (json['swapMemoryTotal'] as num?)?.toInt() ?? 0,
      swapMemoryUsed: (json['swapMemoryUsed'] as num?)?.toInt() ?? 0,
      swapMemoryUsedPercent: (json['swapMemoryUsedPercent'] as num?)?.toDouble() ?? 0.0,
      timeSinceUptime: json['timeSinceUptime'] as String? ?? '',
      topCPUItems: (json['topCPUItems'] as List<dynamic>?)?.map((e) => Process.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      topMemItems: (json['topMemItems'] as List<dynamic>?)?.map((e) => Process.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      uptime: (json['uptime'] as num?)?.toInt() ?? 0,
      xpuData: (json['xpuData'] as List<dynamic>?)?.map((e) => XPUInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'cpuDetailedPercent': cpuDetailedPercent,
      'cpuPercent': cpuPercent,
      'cpuTotal': cpuTotal,
      'cpuUsed': cpuUsed,
      'cpuUsedPercent': cpuUsedPercent,
      'diskData': diskData.map((e) => e.toJson()).toList(),
      'gpuData': gpuData.map((e) => e.toJson()).toList(),
      'ioCount': ioCount,
      'ioReadBytes': ioReadBytes,
      'ioReadTime': ioReadTime,
      'ioWriteBytes': ioWriteBytes,
      'ioWriteTime': ioWriteTime,
      'load1': load1,
      'load15': load15,
      'load5': load5,
      'loadUsagePercent': loadUsagePercent,
      'memoryAvailable': memoryAvailable,
      'memoryCache': memoryCache,
      'memoryFree': memoryFree,
      'memoryShard': memoryShard,
      'memoryTotal': memoryTotal,
      'memoryUsed': memoryUsed,
      'memoryUsedPercent': memoryUsedPercent,
      'netBytesRecv': netBytesRecv,
      'netBytesSent': netBytesSent,
      'procs': procs,
      if (runningTime != null) 'runningTime': runningTime!.toJson(),
      'shotTime': shotTime,
      'swapMemoryAvailable': swapMemoryAvailable,
      'swapMemoryTotal': swapMemoryTotal,
      'swapMemoryUsed': swapMemoryUsed,
      'swapMemoryUsedPercent': swapMemoryUsedPercent,
      'timeSinceUptime': timeSinceUptime,
      'topCPUItems': topCPUItems.map((e) => e.toJson()).toList(),
      'topMemItems': topMemItems.map((e) => e.toJson()).toList(),
      'uptime': uptime,
      'xpuData': xpuData.map((e) => e.toJson()).toList(),
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

class GPUInfo {
  final String fanSpeed;
  final String gpuUtil;
  final int index;
  final String maxPowerLimit;
  final String memTotal;
  final String memUsed;
  final String memoryUsage;
  final String performanceState;
  final String powerDraw;
  final String powerUsage;
  final String productName;
  final String temperature;
  final String type;

  const GPUInfo({
    this.fanSpeed = '',
    this.gpuUtil = '',
    this.index = 0,
    this.maxPowerLimit = '',
    this.memTotal = '',
    this.memUsed = '',
    this.memoryUsage = '',
    this.performanceState = '',
    this.powerDraw = '',
    this.powerUsage = '',
    this.productName = '',
    this.temperature = '',
    this.type = '',
  });

  factory GPUInfo.fromJson(Map<String, dynamic> json) {
    return GPUInfo(
      fanSpeed: json['fanSpeed'] as String? ?? '',
      gpuUtil: json['gpuUtil'] as String? ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      maxPowerLimit: json['maxPowerLimit'] as String? ?? '',
      memTotal: json['memTotal'] as String? ?? '',
      memUsed: json['memUsed'] as String? ?? '',
      memoryUsage: json['memoryUsage'] as String? ?? '',
      performanceState: json['performanceState'] as String? ?? '',
      powerDraw: json['powerDraw'] as String? ?? '',
      powerUsage: json['powerUsage'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      temperature: json['temperature'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'fanSpeed': fanSpeed,
      'gpuUtil': gpuUtil,
      'index': index,
      'maxPowerLimit': maxPowerLimit,
      'memTotal': memTotal,
      'memUsed': memUsed,
      'memoryUsage': memoryUsage,
      'performanceState': performanceState,
      'powerDraw': powerDraw,
      'powerUsage': powerUsage,
      'productName': productName,
      'temperature': temperature,
      'type': type,
  };
}

class GPUProcess {
  final String pid;
  final String processName;
  final String type;
  final String usedMemory;

  const GPUProcess({
    this.pid = '',
    this.processName = '',
    this.type = '',
    this.usedMemory = '',
  });

  factory GPUProcess.fromJson(Map<String, dynamic> json) {
    return GPUProcess(
      pid: json['pid'] as String? ?? '',
      processName: json['processName'] as String? ?? '',
      type: json['type'] as String? ?? '',
      usedMemory: json['usedMemory'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'pid': pid,
      'processName': processName,
      'type': type,
      'usedMemory': usedMemory,
  };
}

class InstallDetail {
  final int detailID;
  final int httpPort;
  final int httpsPort;
  final int installID;
  final String name;
  final String path;
  final String status;
  final String version;
  final String webUI;

  const InstallDetail({
    this.detailID = 0,
    this.httpPort = 0,
    this.httpsPort = 0,
    this.installID = 0,
    this.name = '',
    this.path = '',
    this.status = '',
    this.version = '',
    this.webUI = '',
  });

  factory InstallDetail.fromJson(Map<String, dynamic> json) {
    return InstallDetail(
      detailID: (json['detailID'] as num?)?.toInt() ?? 0,
      httpPort: (json['httpPort'] as num?)?.toInt() ?? 0,
      httpsPort: (json['httpsPort'] as num?)?.toInt() ?? 0,
      installID: (json['installID'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      status: json['status'] as String? ?? '',
      version: json['version'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detailID': detailID,
      'httpPort': httpPort,
      'httpsPort': httpsPort,
      'installID': installID,
      'name': name,
      'path': path,
      'status': status,
      'version': version,
      'webUI': webUI,
  };
}

class LauncherOption {
  final bool isShow;
  final String key;

  const LauncherOption({
    this.isShow = false,
    this.key = '',
  });

  factory LauncherOption.fromJson(Map<String, dynamic> json) {
    return LauncherOption(
      isShow: json['isShow'] as bool? ?? false,
      key: json['key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'isShow': isShow,
      'key': key,
  };
}

class MonitorData {
  final List<String> date;
  final String param;
  final List<dynamic> value;

  const MonitorData({
    this.date = const [],
    this.param = '',
    this.value = const [],
  });

  factory MonitorData.fromJson(Map<String, dynamic> json) {
    return MonitorData(
      date: (json['date'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      param: json['param'] as String? ?? '',
      value: (json['value'] as List<dynamic>?) ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'date': date,
      'param': param,
      'value': value,
  };
}

class MonitorGPUData {
  final List<String> date;
  final List<List<GPUProcess>> gpuProcesses;
  final List<double> gpuValue;
  final List<double> memoryPercent;
  final List<double> memoryTotal;
  final List<double> memoryUsed;
  final List<double> powerPercent;
  final List<double> powerTotal;
  final List<double> powerUsed;
  final List<int> processCount;
  final List<int> speedValue;
  final List<double> temperatureValue;

  const MonitorGPUData({
    this.date = const [],
    this.gpuProcesses = const [],
    this.gpuValue = const [],
    this.memoryPercent = const [],
    this.memoryTotal = const [],
    this.memoryUsed = const [],
    this.powerPercent = const [],
    this.powerTotal = const [],
    this.powerUsed = const [],
    this.processCount = const [],
    this.speedValue = const [],
    this.temperatureValue = const [],
  });

  factory MonitorGPUData.fromJson(Map<String, dynamic> json) {
    return MonitorGPUData(
      date: (json['date'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      gpuProcesses: const [],
      gpuValue: (json['gpuValue'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      memoryPercent: (json['memoryPercent'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      memoryTotal: (json['memoryTotal'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      memoryUsed: (json['memoryUsed'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      powerPercent: (json['powerPercent'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      powerTotal: (json['powerTotal'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      powerUsed: (json['powerUsed'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      processCount: (json['processCount'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      speedValue: (json['speedValue'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      temperatureValue: (json['temperatureValue'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'date': date,
      'gpuProcesses': const [],
      'gpuValue': gpuValue,
      'memoryPercent': memoryPercent,
      'memoryTotal': memoryTotal,
      'memoryUsed': memoryUsed,
      'powerPercent': powerPercent,
      'powerTotal': powerTotal,
      'powerUsed': powerUsed,
      'processCount': processCount,
      'speedValue': speedValue,
      'temperatureValue': temperatureValue,
  };
}

class MonitorGPUSearch {
  final String endTime;
  final String productName;
  final String startTime;

  const MonitorGPUSearch({
    this.endTime = '',
    this.productName = '',
    this.startTime = '',
  });

  factory MonitorGPUSearch.fromJson(Map<String, dynamic> json) {
    return MonitorGPUSearch(
      endTime: json['endTime'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'endTime': endTime,
      'productName': productName,
      'startTime': startTime,
  };
}

class MonitorSearch {
  final String endTime;
  final String io;
  final String network;
  final String param;
  final String startTime;

  const MonitorSearch({
    this.endTime = '',
    this.io = '',
    this.network = '',
    this.param = '',
    this.startTime = '',
  });

  factory MonitorSearch.fromJson(Map<String, dynamic> json) {
    return MonitorSearch(
      endTime: json['endTime'] as String? ?? '',
      io: json['io'] as String? ?? '',
      network: json['network'] as String? ?? '',
      param: json['param'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'endTime': endTime,
      'io': io,
      'network': network,
      'param': param,
      'startTime': startTime,
  };
}

class MonitorSetting {
  final String defaultIO;
  final String defaultNetwork;
  final String monitorInterval;
  final String monitorStatus;
  final String monitorStoreDays;

  const MonitorSetting({
    this.defaultIO = '',
    this.defaultNetwork = '',
    this.monitorInterval = '',
    this.monitorStatus = '',
    this.monitorStoreDays = '',
  });

  factory MonitorSetting.fromJson(Map<String, dynamic> json) {
    return MonitorSetting(
      defaultIO: json['defaultIO'] as String? ?? '',
      defaultNetwork: json['defaultNetwork'] as String? ?? '',
      monitorInterval: json['monitorInterval'] as String? ?? '',
      monitorStatus: json['monitorStatus'] as String? ?? '',
      monitorStoreDays: json['monitorStoreDays'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'defaultIO': defaultIO,
      'defaultNetwork': defaultNetwork,
      'monitorInterval': monitorInterval,
      'monitorStatus': monitorStatus,
      'monitorStoreDays': monitorStoreDays,
  };
}

class MonitorSettingUpdate {
  final String key;
  final String value;

  const MonitorSettingUpdate({
    this.key = '',
    this.value = '',
  });

  factory MonitorSettingUpdate.fromJson(Map<String, dynamic> json) {
    return MonitorSettingUpdate(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class NodeCurrent {
  final List<double> cpuDetailedPercent;
  final int cpuTotal;
  final double cpuUsed;
  final double cpuUsedPercent;
  final double load1;
  final double load15;
  final double load5;
  final double loadUsagePercent;
  final int memoryAvailable;
  final int memoryTotal;
  final int memoryUsed;
  final double memoryUsedPercent;
  final int swapMemoryAvailable;
  final int swapMemoryTotal;
  final int swapMemoryUsed;
  final double swapMemoryUsedPercent;

  const NodeCurrent({
    this.cpuDetailedPercent = const [],
    this.cpuTotal = 0,
    this.cpuUsed = 0.0,
    this.cpuUsedPercent = 0.0,
    this.load1 = 0.0,
    this.load15 = 0.0,
    this.load5 = 0.0,
    this.loadUsagePercent = 0.0,
    this.memoryAvailable = 0,
    this.memoryTotal = 0,
    this.memoryUsed = 0,
    this.memoryUsedPercent = 0.0,
    this.swapMemoryAvailable = 0,
    this.swapMemoryTotal = 0,
    this.swapMemoryUsed = 0,
    this.swapMemoryUsedPercent = 0.0,
  });

  factory NodeCurrent.fromJson(Map<String, dynamic> json) {
    return NodeCurrent(
      cpuDetailedPercent: (json['cpuDetailedPercent'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? const [],
      cpuTotal: (json['cpuTotal'] as num?)?.toInt() ?? 0,
      cpuUsed: (json['cpuUsed'] as num?)?.toDouble() ?? 0.0,
      cpuUsedPercent: (json['cpuUsedPercent'] as num?)?.toDouble() ?? 0.0,
      load1: (json['load1'] as num?)?.toDouble() ?? 0.0,
      load15: (json['load15'] as num?)?.toDouble() ?? 0.0,
      load5: (json['load5'] as num?)?.toDouble() ?? 0.0,
      loadUsagePercent: (json['loadUsagePercent'] as num?)?.toDouble() ?? 0.0,
      memoryAvailable: (json['memoryAvailable'] as num?)?.toInt() ?? 0,
      memoryTotal: (json['memoryTotal'] as num?)?.toInt() ?? 0,
      memoryUsed: (json['memoryUsed'] as num?)?.toInt() ?? 0,
      memoryUsedPercent: (json['memoryUsedPercent'] as num?)?.toDouble() ?? 0.0,
      swapMemoryAvailable: (json['swapMemoryAvailable'] as num?)?.toInt() ?? 0,
      swapMemoryTotal: (json['swapMemoryTotal'] as num?)?.toInt() ?? 0,
      swapMemoryUsed: (json['swapMemoryUsed'] as num?)?.toInt() ?? 0,
      swapMemoryUsedPercent: (json['swapMemoryUsedPercent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
      'cpuDetailedPercent': cpuDetailedPercent,
      'cpuTotal': cpuTotal,
      'cpuUsed': cpuUsed,
      'cpuUsedPercent': cpuUsedPercent,
      'load1': load1,
      'load15': load15,
      'load5': load5,
      'loadUsagePercent': loadUsagePercent,
      'memoryAvailable': memoryAvailable,
      'memoryTotal': memoryTotal,
      'memoryUsed': memoryUsed,
      'memoryUsedPercent': memoryUsedPercent,
      'swapMemoryAvailable': swapMemoryAvailable,
      'swapMemoryTotal': swapMemoryTotal,
      'swapMemoryUsed': swapMemoryUsed,
      'swapMemoryUsedPercent': swapMemoryUsedPercent,
  };
}

class OsInfo {
  final int diskSize;
  final String kernelArch;
  final String kernelVersion;
  final String os;
  final String platform;
  final String platformFamily;
  final String prettyDistro;

  const OsInfo({
    this.diskSize = 0,
    this.kernelArch = '',
    this.kernelVersion = '',
    this.os = '',
    this.platform = '',
    this.platformFamily = '',
    this.prettyDistro = '',
  });

  factory OsInfo.fromJson(Map<String, dynamic> json) {
    return OsInfo(
      diskSize: (json['diskSize'] as num?)?.toInt() ?? 0,
      kernelArch: json['kernelArch'] as String? ?? '',
      kernelVersion: json['kernelVersion'] as String? ?? '',
      os: json['os'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      platformFamily: json['platformFamily'] as String? ?? '',
      prettyDistro: json['prettyDistro'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'diskSize': diskSize,
      'kernelArch': kernelArch,
      'kernelVersion': kernelVersion,
      'os': os,
      'platform': platform,
      'platformFamily': platformFamily,
      'prettyDistro': prettyDistro,
  };
}

class Process {
  final String cmd;
  final int memory;
  final String name;
  final double percent;
  final int pid;
  final String user;

  const Process({
    this.cmd = '',
    this.memory = 0,
    this.name = '',
    this.percent = 0.0,
    this.pid = 0,
    this.user = '',
  });

  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      cmd: json['cmd'] as String? ?? '',
      memory: (json['memory'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
      pid: (json['pid'] as num?)?.toInt() ?? 0,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cmd': cmd,
      'memory': memory,
      'name': name,
      'percent': percent,
      'pid': pid,
      'user': user,
  };
}

class QuickJump {
  final String alias;
  final String detail;
  final int id;
  final bool isShow;
  final String name;
  final int recommend;
  final String router;
  final String title;

  const QuickJump({
    this.alias = '',
    this.detail = '',
    this.id = 0,
    this.isShow = false,
    this.name = '',
    this.recommend = 0,
    this.router = '',
    this.title = '',
  });

  factory QuickJump.fromJson(Map<String, dynamic> json) {
    return QuickJump(
      alias: json['alias'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isShow: json['isShow'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      router: json['router'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'alias': alias,
      'detail': detail,
      'id': id,
      'isShow': isShow,
      'name': name,
      'recommend': recommend,
      'router': router,
      'title': title,
  };
}

class RunningTime {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const RunningTime({
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
  });

  factory RunningTime.fromJson(Map<String, dynamic> json) {
    return RunningTime(
      days: (json['days'] as num?)?.toInt() ?? 0,
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
  };
}

class SearchByFilter {
  final String filter;

  const SearchByFilter({
    this.filter = '',
  });

  factory SearchByFilter.fromJson(Map<String, dynamic> json) {
    return SearchByFilter(
      filter: json['filter'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'filter': filter,
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

class XPUInfo {
  final int deviceID;
  final String deviceName;
  final String memory;
  final String memoryUsed;
  final String memoryUtil;
  final String power;
  final String temperature;

  const XPUInfo({
    this.deviceID = 0,
    this.deviceName = '',
    this.memory = '',
    this.memoryUsed = '',
    this.memoryUtil = '',
    this.power = '',
    this.temperature = '',
  });

  factory XPUInfo.fromJson(Map<String, dynamic> json) {
    return XPUInfo(
      deviceID: (json['deviceID'] as num?)?.toInt() ?? 0,
      deviceName: json['deviceName'] as String? ?? '',
      memory: json['memory'] as String? ?? '',
      memoryUsed: json['memoryUsed'] as String? ?? '',
      memoryUtil: json['memoryUtil'] as String? ?? '',
      power: json['power'] as String? ?? '',
      temperature: json['temperature'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'deviceID': deviceID,
      'deviceName': deviceName,
      'memory': memory,
      'memoryUsed': memoryUsed,
      'memoryUtil': memoryUtil,
      'power': power,
      'temperature': temperature,
  };
}
