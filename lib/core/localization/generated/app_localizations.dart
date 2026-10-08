import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'OneDeck'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In zh, this message translates to:
  /// **'现代全平台 1Panel 运维座舱'**
  String get appSlogan;

  /// No description provided for @common_ok.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get common_ok;

  /// No description provided for @common_cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get common_cancel;

  /// No description provided for @common_save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get common_save;

  /// No description provided for @common_delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get common_delete;

  /// No description provided for @common_confirm.
  ///
  /// In zh, this message translates to:
  /// **'确认'**
  String get common_confirm;

  /// No description provided for @common_close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get common_close;

  /// No description provided for @common_retry.
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get common_retry;

  /// No description provided for @common_refresh.
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get common_refresh;

  /// No description provided for @common_search.
  ///
  /// In zh, this message translates to:
  /// **'搜索...'**
  String get common_search;

  /// No description provided for @common_filter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get common_filter;

  /// No description provided for @common_copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get common_copy;

  /// No description provided for @common_copied.
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get common_copied;

  /// No description provided for @common_edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get common_edit;

  /// No description provided for @common_add.
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get common_add;

  /// No description provided for @common_create.
  ///
  /// In zh, this message translates to:
  /// **'新建'**
  String get common_create;

  /// No description provided for @common_actions.
  ///
  /// In zh, this message translates to:
  /// **'操作'**
  String get common_actions;

  /// No description provided for @common_status.
  ///
  /// In zh, this message translates to:
  /// **'状态'**
  String get common_status;

  /// No description provided for @common_loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get common_loading;

  /// No description provided for @common_success.
  ///
  /// In zh, this message translates to:
  /// **'操作成功'**
  String get common_success;

  /// No description provided for @common_failed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败'**
  String get common_failed;

  /// No description provided for @common_error.
  ///
  /// In zh, this message translates to:
  /// **'发生错误'**
  String get common_error;

  /// No description provided for @common_empty.
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get common_empty;

  /// No description provided for @common_more.
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get common_more;

  /// No description provided for @common_viewAll.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get common_viewAll;

  /// No description provided for @common_back.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get common_back;

  /// No description provided for @common_shortcut_search.
  ///
  /// In zh, this message translates to:
  /// **'按 ⌘K 快速检索'**
  String get common_shortcut_search;

  /// No description provided for @nav_dashboard.
  ///
  /// In zh, this message translates to:
  /// **'仪表盘'**
  String get nav_dashboard;

  /// No description provided for @nav_host.
  ///
  /// In zh, this message translates to:
  /// **'主机监控'**
  String get nav_host;

  /// No description provided for @nav_app_store.
  ///
  /// In zh, this message translates to:
  /// **'应用商店'**
  String get nav_app_store;

  /// No description provided for @nav_website.
  ///
  /// In zh, this message translates to:
  /// **'网站管理'**
  String get nav_website;

  /// No description provided for @nav_container.
  ///
  /// In zh, this message translates to:
  /// **'容器与镜像'**
  String get nav_container;

  /// No description provided for @nav_database.
  ///
  /// In zh, this message translates to:
  /// **'数据库'**
  String get nav_database;

  /// No description provided for @nav_file.
  ///
  /// In zh, this message translates to:
  /// **'文件管理'**
  String get nav_file;

  /// No description provided for @nav_terminal.
  ///
  /// In zh, this message translates to:
  /// **'终端控制台'**
  String get nav_terminal;

  /// No description provided for @nav_cronjob.
  ///
  /// In zh, this message translates to:
  /// **'计划任务'**
  String get nav_cronjob;

  /// No description provided for @nav_supervisor.
  ///
  /// In zh, this message translates to:
  /// **'进程守护'**
  String get nav_supervisor;

  /// No description provided for @nav_toolbox.
  ///
  /// In zh, this message translates to:
  /// **'系统工具'**
  String get nav_toolbox;

  /// No description provided for @nav_firewall.
  ///
  /// In zh, this message translates to:
  /// **'防火墙'**
  String get nav_firewall;

  /// No description provided for @nav_log.
  ///
  /// In zh, this message translates to:
  /// **'日志审计'**
  String get nav_log;

  /// No description provided for @nav_panel_settings.
  ///
  /// In zh, this message translates to:
  /// **'面板设置'**
  String get nav_panel_settings;

  /// No description provided for @nav_settings.
  ///
  /// In zh, this message translates to:
  /// **'偏好设置'**
  String get nav_settings;

  /// No description provided for @nav_servers.
  ///
  /// In zh, this message translates to:
  /// **'服务器管理'**
  String get nav_servers;

  /// No description provided for @group_overview.
  ///
  /// In zh, this message translates to:
  /// **'监控与概览'**
  String get group_overview;

  /// No description provided for @group_apps.
  ///
  /// In zh, this message translates to:
  /// **'应用与服务'**
  String get group_apps;

  /// No description provided for @group_ops.
  ///
  /// In zh, this message translates to:
  /// **'系统与运维'**
  String get group_ops;

  /// No description provided for @group_security.
  ///
  /// In zh, this message translates to:
  /// **'安全与全局'**
  String get group_security;

  /// No description provided for @server_active.
  ///
  /// In zh, this message translates to:
  /// **'当前服务器'**
  String get server_active;

  /// No description provided for @server_switch.
  ///
  /// In zh, this message translates to:
  /// **'切换服务器'**
  String get server_switch;

  /// No description provided for @server_add.
  ///
  /// In zh, this message translates to:
  /// **'添加服务器'**
  String get server_add;

  /// No description provided for @server_edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑服务器'**
  String get server_edit;

  /// No description provided for @server_delete.
  ///
  /// In zh, this message translates to:
  /// **'删除服务器'**
  String get server_delete;

  /// No description provided for @server_delete_confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除此服务器配置吗？'**
  String get server_delete_confirm;

  /// No description provided for @server_name.
  ///
  /// In zh, this message translates to:
  /// **'服务器名称'**
  String get server_name;

  /// No description provided for @server_name_hint.
  ///
  /// In zh, this message translates to:
  /// **'如：生产主节点'**
  String get server_name_hint;

  /// No description provided for @server_address.
  ///
  /// In zh, this message translates to:
  /// **'主机地址 / 域名'**
  String get server_address;

  /// No description provided for @server_address_hint.
  ///
  /// In zh, this message translates to:
  /// **'如：192.168.1.100 或 demo.1panel.pro'**
  String get server_address_hint;

  /// No description provided for @server_port.
  ///
  /// In zh, this message translates to:
  /// **'面板端口'**
  String get server_port;

  /// No description provided for @server_ssl.
  ///
  /// In zh, this message translates to:
  /// **'启用 HTTPS'**
  String get server_ssl;

  /// No description provided for @server_token.
  ///
  /// In zh, this message translates to:
  /// **'API 密钥 (Token)'**
  String get server_token;

  /// No description provided for @server_token_hint.
  ///
  /// In zh, this message translates to:
  /// **'1Panel 面板设置中生成的 API 密钥'**
  String get server_token_hint;

  /// No description provided for @server_entry.
  ///
  /// In zh, this message translates to:
  /// **'安全入口'**
  String get server_entry;

  /// No description provided for @server_entry_hint.
  ///
  /// In zh, this message translates to:
  /// **'如无安全入口可留空'**
  String get server_entry_hint;

  /// No description provided for @server_test_connection.
  ///
  /// In zh, this message translates to:
  /// **'测试连接'**
  String get server_test_connection;

  /// No description provided for @server_connecting.
  ///
  /// In zh, this message translates to:
  /// **'正在连接...'**
  String get server_connecting;

  /// No description provided for @server_connected.
  ///
  /// In zh, this message translates to:
  /// **'连接成功'**
  String get server_connected;

  /// No description provided for @server_connect_failed.
  ///
  /// In zh, this message translates to:
  /// **'连接失败'**
  String get server_connect_failed;

  /// No description provided for @server_latency.
  ///
  /// In zh, this message translates to:
  /// **'延迟'**
  String get server_latency;

  /// No description provided for @server_status_online.
  ///
  /// In zh, this message translates to:
  /// **'在线'**
  String get server_status_online;

  /// No description provided for @server_status_offline.
  ///
  /// In zh, this message translates to:
  /// **'离线'**
  String get server_status_offline;

  /// No description provided for @server_status_warning.
  ///
  /// In zh, this message translates to:
  /// **'高负荷'**
  String get server_status_warning;

  /// No description provided for @server_no_servers.
  ///
  /// In zh, this message translates to:
  /// **'尚未添加任何服务器'**
  String get server_no_servers;

  /// No description provided for @server_add_first.
  ///
  /// In zh, this message translates to:
  /// **'立即添加第一台 1Panel 服务器'**
  String get server_add_first;

  /// No description provided for @metric_cpu.
  ///
  /// In zh, this message translates to:
  /// **'处理器'**
  String get metric_cpu;

  /// No description provided for @metric_memory.
  ///
  /// In zh, this message translates to:
  /// **'内存'**
  String get metric_memory;

  /// No description provided for @metric_disk.
  ///
  /// In zh, this message translates to:
  /// **'磁盘'**
  String get metric_disk;

  /// No description provided for @metric_network.
  ///
  /// In zh, this message translates to:
  /// **'网络吞吐'**
  String get metric_network;

  /// No description provided for @metric_uptime.
  ///
  /// In zh, this message translates to:
  /// **'运行时间'**
  String get metric_uptime;

  /// No description provided for @metric_load.
  ///
  /// In zh, this message translates to:
  /// **'系统负载'**
  String get metric_load;

  /// No description provided for @container_tab_containers.
  ///
  /// In zh, this message translates to:
  /// **'容器'**
  String get container_tab_containers;

  /// No description provided for @container_tab_images.
  ///
  /// In zh, this message translates to:
  /// **'镜像'**
  String get container_tab_images;

  /// No description provided for @container_tab_compose.
  ///
  /// In zh, this message translates to:
  /// **'编排 Compose'**
  String get container_tab_compose;

  /// No description provided for @container_tab_networks.
  ///
  /// In zh, this message translates to:
  /// **'网络'**
  String get container_tab_networks;

  /// No description provided for @container_tab_volumes.
  ///
  /// In zh, this message translates to:
  /// **'存储卷'**
  String get container_tab_volumes;

  /// No description provided for @container_status_running.
  ///
  /// In zh, this message translates to:
  /// **'运行中'**
  String get container_status_running;

  /// No description provided for @container_status_stopped.
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get container_status_stopped;

  /// No description provided for @container_status_restarting.
  ///
  /// In zh, this message translates to:
  /// **'重启中'**
  String get container_status_restarting;

  /// No description provided for @container_status_paused.
  ///
  /// In zh, this message translates to:
  /// **'已暂停'**
  String get container_status_paused;

  /// No description provided for @container_action_start.
  ///
  /// In zh, this message translates to:
  /// **'启动'**
  String get container_action_start;

  /// No description provided for @container_action_stop.
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get container_action_stop;

  /// No description provided for @container_action_restart.
  ///
  /// In zh, this message translates to:
  /// **'重启'**
  String get container_action_restart;

  /// No description provided for @container_action_logs.
  ///
  /// In zh, this message translates to:
  /// **'实时日志'**
  String get container_action_logs;

  /// No description provided for @container_action_terminal.
  ///
  /// In zh, this message translates to:
  /// **'控制台终端'**
  String get container_action_terminal;

  /// No description provided for @container_ports.
  ///
  /// In zh, this message translates to:
  /// **'端口映射'**
  String get container_ports;

  /// No description provided for @settings_title.
  ///
  /// In zh, this message translates to:
  /// **'客户端偏好设置'**
  String get settings_title;

  /// No description provided for @settings_appearance.
  ///
  /// In zh, this message translates to:
  /// **'外观与显示'**
  String get settings_appearance;

  /// No description provided for @settings_theme_mode.
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get settings_theme_mode;

  /// No description provided for @settings_theme_system.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_dark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get settings_theme_dark;

  /// No description provided for @settings_theme_light.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get settings_theme_light;

  /// No description provided for @settings_language.
  ///
  /// In zh, this message translates to:
  /// **'界面语言'**
  String get settings_language;

  /// No description provided for @settings_lang_system.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get settings_lang_system;

  /// No description provided for @settings_lang_zh.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get settings_lang_zh;

  /// No description provided for @settings_lang_en.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get settings_lang_en;

  /// No description provided for @settings_security.
  ///
  /// In zh, this message translates to:
  /// **'安全与隐私'**
  String get settings_security;

  /// No description provided for @settings_biometric.
  ///
  /// In zh, this message translates to:
  /// **'生物识别解锁'**
  String get settings_biometric;

  /// No description provided for @settings_biometric_desc.
  ///
  /// In zh, this message translates to:
  /// **'使用 Face ID / 指纹保护应用访问安全'**
  String get settings_biometric_desc;

  /// No description provided for @settings_network.
  ///
  /// In zh, this message translates to:
  /// **'网络与通信'**
  String get settings_network;

  /// No description provided for @settings_timeout.
  ///
  /// In zh, this message translates to:
  /// **'网络超时时间'**
  String get settings_timeout;

  /// No description provided for @settings_allow_self_signed.
  ///
  /// In zh, this message translates to:
  /// **'信任自签名证书'**
  String get settings_allow_self_signed;

  /// No description provided for @settings_allow_self_signed_desc.
  ///
  /// In zh, this message translates to:
  /// **'允许通过 IP 直连或不受信任的自签 HTTPS 证书'**
  String get settings_allow_self_signed_desc;

  /// No description provided for @settings_about.
  ///
  /// In zh, this message translates to:
  /// **'关于 OneDeck'**
  String get settings_about;

  /// No description provided for @settings_version.
  ///
  /// In zh, this message translates to:
  /// **'版本号'**
  String get settings_version;

  /// No description provided for @settings_github.
  ///
  /// In zh, this message translates to:
  /// **'开源代码仓库'**
  String get settings_github;

  /// No description provided for @settings_author.
  ///
  /// In zh, this message translates to:
  /// **'打造下一代全平台 1Panel 体验'**
  String get settings_author;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
