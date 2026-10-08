// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OneDeck';

  @override
  String get appSlogan => 'Modern Cross-Platform 1Panel Cockpit';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_save => 'Save';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_close => 'Close';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_refresh => 'Refresh';

  @override
  String get common_search => 'Search...';

  @override
  String get common_filter => 'Filter';

  @override
  String get common_copy => 'Copy';

  @override
  String get common_copied => 'Copied to clipboard';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_add => 'Add';

  @override
  String get common_create => 'New';

  @override
  String get common_actions => 'Actions';

  @override
  String get common_status => 'Status';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_success => 'Success';

  @override
  String get common_failed => 'Failed';

  @override
  String get common_error => 'Error occurred';

  @override
  String get common_empty => 'No data found';

  @override
  String get common_more => 'More';

  @override
  String get common_viewAll => 'View All';

  @override
  String get common_back => 'Back';

  @override
  String get common_shortcut_search => 'Press ⌘K to search';

  @override
  String get nav_dashboard => 'Dashboard';

  @override
  String get nav_host => 'Host Monitor';

  @override
  String get nav_app_store => 'App Store';

  @override
  String get nav_website => 'Websites';

  @override
  String get nav_container => 'Containers';

  @override
  String get nav_database => 'Databases';

  @override
  String get nav_file => 'Files';

  @override
  String get nav_terminal => 'Terminal';

  @override
  String get nav_cronjob => 'Cronjobs';

  @override
  String get nav_supervisor => 'Supervisor';

  @override
  String get nav_toolbox => 'Toolbox';

  @override
  String get nav_firewall => 'Firewall';

  @override
  String get nav_log => 'Audit Logs';

  @override
  String get nav_panel_settings => 'Panel Settings';

  @override
  String get nav_settings => 'Preferences';

  @override
  String get nav_servers => 'Servers';

  @override
  String get group_overview => 'Overview';

  @override
  String get group_apps => 'Apps & Services';

  @override
  String get group_ops => 'Ops & System';

  @override
  String get group_security => 'Security & Hub';

  @override
  String get server_active => 'Active Server';

  @override
  String get server_switch => 'Switch Server';

  @override
  String get server_add => 'Add Server';

  @override
  String get server_edit => 'Edit Server';

  @override
  String get server_delete => 'Delete Server';

  @override
  String get server_delete_confirm =>
      'Are you sure you want to delete this server?';

  @override
  String get server_name => 'Server Name';

  @override
  String get server_name_hint => 'e.g. Production Node 01';

  @override
  String get server_address => 'Host / Domain';

  @override
  String get server_address_hint => 'e.g. 192.168.1.100 or demo.1panel.pro';

  @override
  String get server_port => 'Panel Port';

  @override
  String get server_ssl => 'Enable HTTPS';

  @override
  String get server_token => 'API Key (Token)';

  @override
  String get server_token_hint => 'API Key generated in 1Panel settings';

  @override
  String get server_entry => 'Entrance Path';

  @override
  String get server_entry_hint => 'Optional security entrance path';

  @override
  String get server_test_connection => 'Test Connection';

  @override
  String get server_connecting => 'Connecting...';

  @override
  String get server_connected => 'Connected successfully';

  @override
  String get server_connect_failed => 'Connection failed';

  @override
  String get server_latency => 'Latency';

  @override
  String get server_status_online => 'Online';

  @override
  String get server_status_offline => 'Offline';

  @override
  String get server_status_warning => 'High Load';

  @override
  String get server_no_servers => 'No servers added yet';

  @override
  String get server_add_first => 'Add your first 1Panel server';

  @override
  String get metric_cpu => 'CPU';

  @override
  String get metric_memory => 'Memory';

  @override
  String get metric_disk => 'Disk';

  @override
  String get metric_network => 'Network';

  @override
  String get metric_uptime => 'Uptime';

  @override
  String get metric_load => 'System Load';

  @override
  String get container_tab_containers => 'Containers';

  @override
  String get container_tab_images => 'Images';

  @override
  String get container_tab_compose => 'Compose';

  @override
  String get container_tab_networks => 'Networks';

  @override
  String get container_tab_volumes => 'Volumes';

  @override
  String get container_status_running => 'Running';

  @override
  String get container_status_stopped => 'Stopped';

  @override
  String get container_status_restarting => 'Restarting';

  @override
  String get container_status_paused => 'Paused';

  @override
  String get container_action_start => 'Start';

  @override
  String get container_action_stop => 'Stop';

  @override
  String get container_action_restart => 'Restart';

  @override
  String get container_action_logs => 'Live Logs';

  @override
  String get container_action_terminal => 'Terminal';

  @override
  String get container_ports => 'Port Bindings';

  @override
  String get settings_title => 'Preferences';

  @override
  String get settings_appearance => 'Appearance & Display';

  @override
  String get settings_theme_mode => 'Theme Mode';

  @override
  String get settings_theme_system => 'System Default';

  @override
  String get settings_theme_dark => 'Titanium Dark';

  @override
  String get settings_theme_light => 'Polar Light';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_lang_system => 'System Default';

  @override
  String get settings_lang_zh => '简体中文';

  @override
  String get settings_lang_en => 'English';

  @override
  String get settings_security => 'Security & Privacy';

  @override
  String get settings_biometric => 'Biometric Unlock';

  @override
  String get settings_biometric_desc =>
      'Protect client access with Face ID or fingerprint';

  @override
  String get settings_network => 'Network & Connectivity';

  @override
  String get settings_timeout => 'Request Timeout';

  @override
  String get settings_allow_self_signed => 'Trust Self-Signed Certificates';

  @override
  String get settings_allow_self_signed_desc =>
      'Allow connecting via IP or untrusted HTTPS certs';

  @override
  String get settings_about => 'About OneDeck';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_github => 'GitHub Repository';

  @override
  String get settings_author => 'Crafting the next-gen 1Panel experience';
}
