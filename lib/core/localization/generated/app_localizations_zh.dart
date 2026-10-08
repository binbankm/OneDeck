// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'OneDeck';

  @override
  String get appSlogan => '现代全平台 1Panel 运维座舱';

  @override
  String get common_ok => '确定';

  @override
  String get common_cancel => '取消';

  @override
  String get common_save => '保存';

  @override
  String get common_delete => '删除';

  @override
  String get common_confirm => '确认';

  @override
  String get common_close => '关闭';

  @override
  String get common_retry => '重试';

  @override
  String get common_refresh => '刷新';

  @override
  String get common_search => '搜索...';

  @override
  String get common_filter => '筛选';

  @override
  String get common_copy => '复制';

  @override
  String get common_copied => '已复制到剪贴板';

  @override
  String get common_edit => '编辑';

  @override
  String get common_add => '添加';

  @override
  String get common_create => '新建';

  @override
  String get common_actions => '操作';

  @override
  String get common_status => '状态';

  @override
  String get common_loading => '加载中...';

  @override
  String get common_success => '操作成功';

  @override
  String get common_failed => '操作失败';

  @override
  String get common_error => '发生错误';

  @override
  String get common_empty => '暂无数据';

  @override
  String get common_more => '更多';

  @override
  String get common_viewAll => '查看全部';

  @override
  String get common_back => '返回';

  @override
  String get common_shortcut_search => '按 ⌘K 快速检索';

  @override
  String get nav_dashboard => '仪表盘';

  @override
  String get nav_host => '主机监控';

  @override
  String get nav_app_store => '应用商店';

  @override
  String get nav_website => '网站管理';

  @override
  String get nav_container => '容器与镜像';

  @override
  String get nav_database => '数据库';

  @override
  String get nav_file => '文件管理';

  @override
  String get nav_terminal => '终端控制台';

  @override
  String get nav_cronjob => '计划任务';

  @override
  String get nav_supervisor => '进程守护';

  @override
  String get nav_toolbox => '系统工具';

  @override
  String get nav_firewall => '防火墙';

  @override
  String get nav_log => '日志审计';

  @override
  String get nav_panel_settings => '面板设置';

  @override
  String get nav_settings => '偏好设置';

  @override
  String get nav_servers => '服务器管理';

  @override
  String get group_overview => '监控与概览';

  @override
  String get group_apps => '应用与服务';

  @override
  String get group_ops => '系统与运维';

  @override
  String get group_security => '安全与全局';

  @override
  String get server_active => '当前服务器';

  @override
  String get server_switch => '切换服务器';

  @override
  String get server_add => '添加服务器';

  @override
  String get server_edit => '编辑服务器';

  @override
  String get server_delete => '删除服务器';

  @override
  String get server_delete_confirm => '确定要删除此服务器配置吗？';

  @override
  String get server_name => '服务器名称';

  @override
  String get server_name_hint => '如：生产主节点';

  @override
  String get server_address => '主机地址 / 域名';

  @override
  String get server_address_hint => '如：192.168.1.100 或 demo.1panel.pro';

  @override
  String get server_port => '面板端口';

  @override
  String get server_ssl => '启用 HTTPS';

  @override
  String get server_token => 'API 密钥 (Token)';

  @override
  String get server_token_hint => '1Panel 面板设置中生成的 API 密钥';

  @override
  String get server_entry => '安全入口';

  @override
  String get server_entry_hint => '如无安全入口可留空';

  @override
  String get server_test_connection => '测试连接';

  @override
  String get server_connecting => '正在连接...';

  @override
  String get server_connected => '连接成功';

  @override
  String get server_connect_failed => '连接失败';

  @override
  String get server_latency => '延迟';

  @override
  String get server_status_online => '在线';

  @override
  String get server_status_offline => '离线';

  @override
  String get server_status_warning => '高负荷';

  @override
  String get server_no_servers => '尚未添加任何服务器';

  @override
  String get server_add_first => '立即添加第一台 1Panel 服务器';

  @override
  String get metric_cpu => '处理器';

  @override
  String get metric_memory => '内存';

  @override
  String get metric_disk => '磁盘';

  @override
  String get metric_network => '网络吞吐';

  @override
  String get metric_uptime => '运行时间';

  @override
  String get metric_load => '系统负载';

  @override
  String get container_tab_containers => '容器';

  @override
  String get container_tab_images => '镜像';

  @override
  String get container_tab_compose => '编排 Compose';

  @override
  String get container_tab_networks => '网络';

  @override
  String get container_tab_volumes => '存储卷';

  @override
  String get container_status_running => '运行中';

  @override
  String get container_status_stopped => '已停止';

  @override
  String get container_status_restarting => '重启中';

  @override
  String get container_status_paused => '已暂停';

  @override
  String get container_action_start => '启动';

  @override
  String get container_action_stop => '停止';

  @override
  String get container_action_restart => '重启';

  @override
  String get container_action_logs => '实时日志';

  @override
  String get container_action_terminal => '控制台终端';

  @override
  String get container_ports => '端口映射';

  @override
  String get settings_title => '客户端偏好设置';

  @override
  String get settings_appearance => '外观与显示';

  @override
  String get settings_theme_mode => '主题模式';

  @override
  String get settings_theme_system => '跟随系统';

  @override
  String get settings_theme_dark => '钛金深色';

  @override
  String get settings_theme_light => '极地浅色';

  @override
  String get settings_language => '界面语言';

  @override
  String get settings_lang_system => '跟随系统';

  @override
  String get settings_lang_zh => '简体中文';

  @override
  String get settings_lang_en => 'English';

  @override
  String get settings_security => '安全与隐私';

  @override
  String get settings_biometric => '生物识别解锁';

  @override
  String get settings_biometric_desc => '使用 Face ID / 指纹保护应用访问安全';

  @override
  String get settings_network => '网络与通信';

  @override
  String get settings_timeout => '网络超时时间';

  @override
  String get settings_allow_self_signed => '信任自签名证书';

  @override
  String get settings_allow_self_signed_desc => '允许通过 IP 直连或不受信任的自签 HTTPS 证书';

  @override
  String get settings_about => '关于 OneDeck';

  @override
  String get settings_version => '版本号';

  @override
  String get settings_github => '开源代码仓库';

  @override
  String get settings_author => '打造下一代全平台 1Panel 体验';
}
