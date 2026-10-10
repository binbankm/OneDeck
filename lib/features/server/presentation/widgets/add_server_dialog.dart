import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../domain/models/server_model.dart';
import '../providers/server_provider.dart';

/// Modal dialog/sheet to Add or Edit a 1Panel server configuration.
Future<void> showAddOrEditServerDialog(BuildContext context, {ServerModel? initialServer}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: AddServerCard(initialServer: initialServer),
    ),
  );
}

class AddServerCard extends ConsumerStatefulWidget {
  final ServerModel? initialServer;

  const AddServerCard({super.key, this.initialServer});

  @override
  ConsumerState<AddServerCard> createState() => _AddServerCardState();
}

class _AddServerCardState extends ConsumerState<AddServerCard> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _entryController;
  late TextEditingController _tokenController;

  bool _isSsl = false;
  bool _allowSelfSigned = true;
  bool _isTesting = false;
  bool _obscureToken = true;
  ConnectionTestResult? _testResult;

  @override
  void initState() {
    super.initState();
    final s = widget.initialServer;
    _nameController = TextEditingController(text: s?.name ?? '');
    _hostController = TextEditingController(text: s?.host ?? '');
    _portController = TextEditingController(text: s != null ? s.port.toString() : '9999');
    _entryController = TextEditingController(text: s?.entry ?? '');
    _tokenController = TextEditingController();
    _isSsl = s?.isSsl ?? false;
    _allowSelfSigned = s?.allowSelfSigned ?? true;

    if (s != null) {
      _loadToken(s.id);
    }
  }

  Future<void> _loadToken(String serverId) async {
    final storage = ref.read(serverStorageServiceProvider);
    final token = await storage.getServerToken(serverId);
    if (token != null && mounted) {
      _tokenController.text = token;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _entryController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  ServerModel _buildServerModel() {
    final port = int.tryParse(_portController.text.trim()) ?? 9999;
    return ServerModel(
      id: widget.initialServer?.id ?? const Uuid().v4(),
      name: _nameController.text.trim().isEmpty ? '1Panel Server' : _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: port,
      isSsl: _isSsl,
      entry: _entryController.text.trim(),
      allowSelfSigned: _allowSelfSigned,
      createdAt: widget.initialServer?.createdAt ?? DateTime.now(),
      lastLatencyMs: _testResult?.latencyMs,
      isOnline: _testResult?.isSuccess,
    );
  }

  Future<void> _handleTestConnection() async {
    if (_hostController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.server_address_hint)),
      );
      return;
    }

    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    final server = _buildServerModel();
    final token = _tokenController.text.trim();
    final testFn = ref.read(testConnectionProvider);

    final result = await testFn(server, token);

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testResult = result;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final server = _buildServerModel();
    final token = _tokenController.text.trim();

    try {
      await ref.read(serversProvider.notifier).addOrUpdateServer(server, token);

      // If activeServerId is null or editing the current server, set active
      final activeId = ref.read(activeServerIdProvider);
      if (activeId == null || activeId == server.id) {
        await ref.read(activeServerIdProvider.notifier).selectServer(server.id);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存服务器失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEditing = widget.initialServer != null;

    return Material(
      color: DeckColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: DeckColors.subtleBorder(context), width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(24),
        child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? l10n.server_edit : l10n.server_add,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: DeckColors.textPrimary(context),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Server Name
              Text(l10n.server_name, style: _labelStyle(context)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(hintText: l10n.server_name_hint),
              ),
              const SizedBox(height: 14),

              // Host & Port Row (Flexible layout with safe fixed port width)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 320;
                  final hostField = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.server_address, style: _labelStyle(context)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _hostController,
                        validator: (v) => v == null || v.trim().isEmpty ? l10n.common_failed : null,
                        decoration: InputDecoration(hintText: l10n.server_address_hint),
                      ),
                    ],
                  );

                  final portField = SizedBox(
                    width: isCompact ? double.infinity : 108,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.server_port, style: _labelStyle(context)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _portController,
                          keyboardType: TextInputType.number,
                          maxLength: 5,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: '9999',
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return l10n.common_failed;
                            final p = int.tryParse(v.trim());
                            if (p == null || p < 1 || p > 65535) return '!';
                            return null;
                          },
                        ),
                      ],
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        hostField,
                        const SizedBox(height: 14),
                        portField,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: hostField),
                      const SizedBox(width: 12),
                      portField,
                    ],
                  );
                },
              ),
              const SizedBox(height: 14),

              // Entrance Path & SSL Toggles
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.server_entry, style: _labelStyle(context)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _entryController,
                          decoration: InputDecoration(hintText: l10n.server_entry_hint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Switches
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.server_ssl, style: TextStyle(fontSize: 14, color: DeckColors.textPrimary(context))),
                value: _isSsl,
                onChanged: (v) => setState(() => _isSsl = v),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settings_allow_self_signed, style: TextStyle(fontSize: 14, color: DeckColors.textPrimary(context))),
                subtitle: Text(l10n.settings_allow_self_signed_desc, style: TextStyle(fontSize: 12, color: DeckColors.textMuted(context))),
                value: _allowSelfSigned,
                onChanged: (v) => setState(() => _allowSelfSigned = v),
              ),
              const SizedBox(height: 10),

              // API Token
              Text(l10n.server_token, style: _labelStyle(context)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tokenController,
                obscureText: _obscureToken,
                decoration: InputDecoration(
                  hintText: l10n.server_token_hint,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureToken ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureToken = !_obscureToken),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Test Connection Status Banner
              if (_testResult != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _testResult!.isSuccess
                        ? DeckColors.statusOnlineGlow
                        : DeckColors.statusErrorGlow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _testResult!.isSuccess
                          ? DeckColors.statusOnline
                          : DeckColors.statusError,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _testResult!.isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                        size: 18,
                        color: _testResult!.isSuccess ? DeckColors.statusOnline : DeckColors.statusError,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _testResult!.isSuccess
                              ? '${l10n.server_connected} (${_testResult!.latencyMs}ms)'
                              : '${l10n.server_connect_failed}: ${_testResult!.errorMessage}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _testResult!.isSuccess ? DeckColors.statusOnline : DeckColors.statusError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Actions Row (Adaptive layout to prevent button overflow on compact screens)
              LayoutBuilder(
                builder: (context, constraints) {
                  final testBtn = OutlinedButton.icon(
                    onPressed: _isTesting ? null : _handleTestConnection,
                    icon: _isTesting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.bolt_rounded, size: 16),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(l10n.server_test_connection),
                    ),
                  );

                  final actionBtns = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.common_cancel),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _handleSave,
                        child: Text(l10n.common_save),
                      ),
                    ],
                  );

                  if (constraints.maxWidth < 360) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        testBtn,
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [actionBtns],
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      testBtn,
                      const Spacer(),
                      actionBtns,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  TextStyle _labelStyle(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: DeckColors.textSecondary(context),
    );
  }
}
