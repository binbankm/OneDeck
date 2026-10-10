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

  /// No description provided for @dashboard_trend_title.
  ///
  /// In zh, this message translates to:
  /// **'实时监控趋势'**
  String get dashboard_trend_title;

  /// No description provided for @dashboard_live_badge.
  ///
  /// In zh, this message translates to:
  /// **'实时'**
  String get dashboard_live_badge;

  /// No description provided for @dashboard_tab_cpu.
  ///
  /// In zh, this message translates to:
  /// **'CPU 趋势'**
  String get dashboard_tab_cpu;

  /// No description provided for @dashboard_tab_memory.
  ///
  /// In zh, this message translates to:
  /// **'内存占用'**
  String get dashboard_tab_memory;

  /// No description provided for @dashboard_tab_network.
  ///
  /// In zh, this message translates to:
  /// **'网络吞吐'**
  String get dashboard_tab_network;

  /// No description provided for @dashboard_tab_load.
  ///
  /// In zh, this message translates to:
  /// **'系统负载'**
  String get dashboard_tab_load;

  /// No description provided for @dashboard_net_down.
  ///
  /// In zh, this message translates to:
  /// **'↓ 下行流量'**
  String get dashboard_net_down;

  /// No description provided for @dashboard_net_up.
  ///
  /// In zh, this message translates to:
  /// **'↑ 上行流量'**
  String get dashboard_net_up;

  /// No description provided for @dashboard_net_total.
  ///
  /// In zh, this message translates to:
  /// **'累计'**
  String get dashboard_net_total;

  /// No description provided for @dashboard_disk_mount.
  ///
  /// In zh, this message translates to:
  /// **'挂载点'**
  String get dashboard_disk_mount;

  /// No description provided for @dashboard_mem_usage.
  ///
  /// In zh, this message translates to:
  /// **'占用'**
  String get dashboard_mem_usage;

  /// No description provided for @dashboard_mem_avail.
  ///
  /// In zh, this message translates to:
  /// **'可用'**
  String get dashboard_mem_avail;

  /// No description provided for @dashboard_cpu_load.
  ///
  /// In zh, this message translates to:
  /// **'负载'**
  String get dashboard_cpu_load;

  /// No description provided for @dashboard_cpu_cores.
  ///
  /// In zh, this message translates to:
  /// **'核'**
  String get dashboard_cpu_cores;

  /// No description provided for @dashboard_unit_websites.
  ///
  /// In zh, this message translates to:
  /// **'个站点'**
  String get dashboard_unit_websites;

  /// No description provided for @dashboard_unit_containers.
  ///
  /// In zh, this message translates to:
  /// **'个应用'**
  String get dashboard_unit_containers;

  /// No description provided for @dashboard_unit_databases.
  ///
  /// In zh, this message translates to:
  /// **'个库'**
  String get dashboard_unit_databases;

  /// No description provided for @dashboard_unit_cronjobs.
  ///
  /// In zh, this message translates to:
  /// **'项任务'**
  String get dashboard_unit_cronjobs;

  /// No description provided for @dashboard_sys_specs.
  ///
  /// In zh, this message translates to:
  /// **'系统规格与环境'**
  String get dashboard_sys_specs;

  /// No description provided for @dashboard_spec_hostname.
  ///
  /// In zh, this message translates to:
  /// **'主机名'**
  String get dashboard_spec_hostname;

  /// No description provided for @dashboard_spec_os.
  ///
  /// In zh, this message translates to:
  /// **'操作系统'**
  String get dashboard_spec_os;

  /// No description provided for @dashboard_spec_kernel.
  ///
  /// In zh, this message translates to:
  /// **'内核架构'**
  String get dashboard_spec_kernel;

  /// No description provided for @dashboard_spec_cpu.
  ///
  /// In zh, this message translates to:
  /// **'处理器'**
  String get dashboard_spec_cpu;

  /// No description provided for @dashboard_spec_proxy.
  ///
  /// In zh, this message translates to:
  /// **'系统代理'**
  String get dashboard_spec_proxy;

  /// No description provided for @dashboard_spec_proxy_none.
  ///
  /// In zh, this message translates to:
  /// **'直连 (无代理)'**
  String get dashboard_spec_proxy_none;

  /// No description provided for @dashboard_spec_cores_detail.
  ///
  /// In zh, this message translates to:
  /// **'物理核心 / 逻辑核心'**
  String get dashboard_spec_cores_detail;

  /// No description provided for @dashboard_uptime_prefix.
  ///
  /// In zh, this message translates to:
  /// **'已运行'**
  String get dashboard_uptime_prefix;

  /// No description provided for @dashboard_ip_copied.
  ///
  /// In zh, this message translates to:
  /// **'已复制 IP'**
  String get dashboard_ip_copied;

  /// No description provided for @dashboard_refresh_tooltip.
  ///
  /// In zh, this message translates to:
  /// **'刷新实时数据'**
  String get dashboard_refresh_tooltip;

  /// No description provided for @dashboard_error_api_key_prompt.
  ///
  /// In zh, this message translates to:
  /// **'1Panel V2 需要在面板「设置」→「API 接口」开启并复制 API Key。'**
  String get dashboard_error_api_key_prompt;

  /// No description provided for @dashboard_configure_api_key.
  ///
  /// In zh, this message translates to:
  /// **'配置 API Key'**
  String get dashboard_configure_api_key;

  /// No description provided for @dashboard_auth_failed.
  ///
  /// In zh, this message translates to:
  /// **'未连接 / 鉴权未通过'**
  String get dashboard_auth_failed;

  /// No description provided for @dashboard_top_processes.
  ///
  /// In zh, this message translates to:
  /// **'Top 进程资源排行'**
  String get dashboard_top_processes;

  /// No description provided for @dashboard_top_cpu.
  ///
  /// In zh, this message translates to:
  /// **'CPU 消耗'**
  String get dashboard_top_cpu;

  /// No description provided for @dashboard_top_mem.
  ///
  /// In zh, this message translates to:
  /// **'内存占用'**
  String get dashboard_top_mem;

  /// No description provided for @dashboard_process_name.
  ///
  /// In zh, this message translates to:
  /// **'进程名称'**
  String get dashboard_process_name;

  /// No description provided for @dashboard_process_pid.
  ///
  /// In zh, this message translates to:
  /// **'PID'**
  String get dashboard_process_pid;

  /// No description provided for @dashboard_process_user.
  ///
  /// In zh, this message translates to:
  /// **'运行用户'**
  String get dashboard_process_user;

  /// No description provided for @dashboard_multi_disk.
  ///
  /// In zh, this message translates to:
  /// **'存储分区与挂载点'**
  String get dashboard_multi_disk;

  /// No description provided for @dashboard_inodes.
  ///
  /// In zh, this message translates to:
  /// **'Inode'**
  String get dashboard_inodes;

  /// No description provided for @dashboard_load_detail.
  ///
  /// In zh, this message translates to:
  /// **'系统平均负载'**
  String get dashboard_load_detail;

  /// No description provided for @dashboard_load_1m.
  ///
  /// In zh, this message translates to:
  /// **'1 分钟'**
  String get dashboard_load_1m;

  /// No description provided for @dashboard_load_5m.
  ///
  /// In zh, this message translates to:
  /// **'5 分钟'**
  String get dashboard_load_5m;

  /// No description provided for @dashboard_load_15m.
  ///
  /// In zh, this message translates to:
  /// **'15 分钟'**
  String get dashboard_load_15m;

  /// No description provided for @dashboard_load_healthy.
  ///
  /// In zh, this message translates to:
  /// **'负载健康'**
  String get dashboard_load_healthy;

  /// No description provided for @dashboard_load_warning.
  ///
  /// In zh, this message translates to:
  /// **'轻微偏高'**
  String get dashboard_load_warning;

  /// No description provided for @dashboard_load_critical.
  ///
  /// In zh, this message translates to:
  /// **'严重过载'**
  String get dashboard_load_critical;

  /// No description provided for @dashboard_memory_deep.
  ///
  /// In zh, this message translates to:
  /// **'内存分层与 Swap'**
  String get dashboard_memory_deep;

  /// No description provided for @dashboard_mem_cache.
  ///
  /// In zh, this message translates to:
  /// **'缓存'**
  String get dashboard_mem_cache;

  /// No description provided for @dashboard_swap.
  ///
  /// In zh, this message translates to:
  /// **'Swap 交换分区'**
  String get dashboard_swap;

  /// No description provided for @dashboard_swap_safe.
  ///
  /// In zh, this message translates to:
  /// **'正常'**
  String get dashboard_swap_safe;

  /// No description provided for @dashboard_swap_warning.
  ///
  /// In zh, this message translates to:
  /// **'已触发换页'**
  String get dashboard_swap_warning;

  /// No description provided for @dashboard_cpu_cores_matrix.
  ///
  /// In zh, this message translates to:
  /// **'CPU 多核心独立负载'**
  String get dashboard_cpu_cores_matrix;

  /// No description provided for @dashboard_core_prefix.
  ///
  /// In zh, this message translates to:
  /// **'核心'**
  String get dashboard_core_prefix;

  /// No description provided for @dashboard_disk_io.
  ///
  /// In zh, this message translates to:
  /// **'磁盘 I/O 读写监控'**
  String get dashboard_disk_io;

  /// No description provided for @dashboard_io_read.
  ///
  /// In zh, this message translates to:
  /// **'读取数据'**
  String get dashboard_io_read;

  /// No description provided for @dashboard_io_write.
  ///
  /// In zh, this message translates to:
  /// **'写入数据'**
  String get dashboard_io_write;

  /// No description provided for @dashboard_io_count.
  ///
  /// In zh, this message translates to:
  /// **'I/O 操作次数'**
  String get dashboard_io_count;

  /// No description provided for @dashboard_gpu_title.
  ///
  /// In zh, this message translates to:
  /// **'GPU / AI 加速卡'**
  String get dashboard_gpu_title;

  /// No description provided for @dashboard_gpu_temp.
  ///
  /// In zh, this message translates to:
  /// **'温度'**
  String get dashboard_gpu_temp;

  /// No description provided for @dashboard_gpu_mem.
  ///
  /// In zh, this message translates to:
  /// **'显存占用'**
  String get dashboard_gpu_mem;

  /// No description provided for @dashboard_gpu_power.
  ///
  /// In zh, this message translates to:
  /// **'功耗'**
  String get dashboard_gpu_power;

  /// No description provided for @dashboard_mem_used.
  ///
  /// In zh, this message translates to:
  /// **'已用'**
  String get dashboard_mem_used;

  /// No description provided for @dashboard_mem_free.
  ///
  /// In zh, this message translates to:
  /// **'空闲'**
  String get dashboard_mem_free;

  /// No description provided for @dashboard_mem_used_total.
  ///
  /// In zh, this message translates to:
  /// **'已用 / 总量'**
  String get dashboard_mem_used_total;

  /// No description provided for @dashboard_swap_disabled.
  ///
  /// In zh, this message translates to:
  /// **'未启用'**
  String get dashboard_swap_disabled;

  /// No description provided for @dashboard_disk_free.
  ///
  /// In zh, this message translates to:
  /// **'剩余'**
  String get dashboard_disk_free;

  /// No description provided for @dashboard_disks_count.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个分区'**
  String dashboard_disks_count(Object count);

  /// No description provided for @dashboard_disks_empty.
  ///
  /// In zh, this message translates to:
  /// **'未检测到存储挂载点'**
  String get dashboard_disks_empty;

  /// No description provided for @dashboard_io_ops_unit.
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get dashboard_io_ops_unit;

  /// No description provided for @dashboard_cores_baseline.
  ///
  /// In zh, this message translates to:
  /// **'核心数基线: {cores} 核 (低于基线即为轻载运行)'**
  String dashboard_cores_baseline(Object cores);

  /// No description provided for @dashboard_cores_count.
  ///
  /// In zh, this message translates to:
  /// **'{count} 核心'**
  String dashboard_cores_count(Object count);

  /// No description provided for @dashboard_cores_empty.
  ///
  /// In zh, this message translates to:
  /// **'无独立核心采样数据'**
  String get dashboard_cores_empty;

  /// No description provided for @dashboard_refresh_processes.
  ///
  /// In zh, this message translates to:
  /// **'刷新进程'**
  String get dashboard_refresh_processes;

  /// No description provided for @dashboard_processes_empty.
  ///
  /// In zh, this message translates to:
  /// **'暂无活跃进程数据 (正在采集或待刷新)'**
  String get dashboard_processes_empty;

  /// No description provided for @dashboard_sidebar_expand.
  ///
  /// In zh, this message translates to:
  /// **'展开侧边栏'**
  String get dashboard_sidebar_expand;

  /// No description provided for @dashboard_sidebar_collapse.
  ///
  /// In zh, this message translates to:
  /// **'折叠侧边栏'**
  String get dashboard_sidebar_collapse;

  /// No description provided for @dashboard_more_modules_count.
  ///
  /// In zh, this message translates to:
  /// **'{count} 个扩展模块'**
  String dashboard_more_modules_count(Object count);

  /// No description provided for @dashboard_mem_total.
  ///
  /// In zh, this message translates to:
  /// **'总计'**
  String get dashboard_mem_total;

  /// No description provided for @dashboard_hero_address.
  ///
  /// In zh, this message translates to:
  /// **'连接地址'**
  String get dashboard_hero_address;

  /// No description provided for @dashboard_hero_os.
  ///
  /// In zh, this message translates to:
  /// **'操作系统'**
  String get dashboard_hero_os;

  /// No description provided for @dashboard_hero_cpu.
  ///
  /// In zh, this message translates to:
  /// **'处理器'**
  String get dashboard_hero_cpu;
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
