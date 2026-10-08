import '../../features/dashboard/data/models/dashboard_models.dart';

class Formatters {
  Formatters._();

  /// Format raw bytes to human readable string (B, KB, MB, GB, TB)
  static String formatBytes(int bytes, [int decimals = 1]) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    var i = 0;
    double count = bytes.toDouble();
    while (count >= 1024 && i < suffixes.length - 1) {
      count /= 1024;
      i++;
    }
    return '${count.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Format network speed bytes per second (B/s, KB/s, MB/s, GB/s)
  static String formatNetworkRate(num bytesPerSec) {
    if (bytesPerSec <= 0) return '0 B/s';
    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    var i = 0;
    double count = bytesPerSec.toDouble();
    while (count >= 1024 && i < suffixes.length - 1) {
      count /= 1024;
      i++;
    }
    return '${count.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Format running time to localized string
  static String formatUptime(RunningTime? time, [int? seconds, String? locale]) {
    final isZh = locale == null || locale.startsWith('zh');
    final dayUnit = isZh ? '天' : 'd';
    final hourUnit = isZh ? '小时' : 'h';
    final minUnit = isZh ? '分' : 'm';
    final startedStr = isZh ? '刚刚启动' : 'Just started';
    final runningStr = isZh ? '运行中' : 'Running';

    if (time != null && (time.days > 0 || time.hours > 0 || time.minutes > 0)) {
      final parts = <String>[];
      if (time.days > 0) parts.add('${time.days}$dayUnit');
      if (time.hours > 0) parts.add('${time.hours}$hourUnit');
      if (time.minutes > 0 && time.days == 0) parts.add('${time.minutes}$minUnit');
      if (parts.isEmpty) parts.add(startedStr);
      return parts.join(' ');
    }

    if (seconds != null && seconds > 0) {
      final days = seconds ~/ 86400;
      final hours = (seconds % 86400) ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final parts = <String>[];
      if (days > 0) parts.add('$days$dayUnit');
      if (hours > 0) parts.add('$hours$hourUnit');
      if (minutes > 0 && days == 0) parts.add('$minutes$minUnit');
      if (parts.isEmpty) parts.add(startedStr);
      return parts.join(' ');
    }

    return runningStr;
  }
}
