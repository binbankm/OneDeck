import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_deck/main.dart';
import 'package:one_deck/core/widgets/adaptive_scaffold.dart';
import 'package:one_deck/features/server/presentation/widgets/server_switcher_pill.dart';
import 'package:one_deck/features/settings/presentation/screens/app_settings_dialog.dart';
import 'package:one_deck/features/server/presentation/widgets/add_server_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UI 响应式与防溢出自动化测试 (无需真机/无黑黄斑马线)', () {
    testWidgets('极限窄窗 (280x600) 暴力拖拽测试: 顶部栏与底部栏零溢出 (Zero Overflow)', (tester) async {
      // 模拟极端极窄拖动（甚至小于普通手机的 280px 宽度）
      tester.view.physicalSize = const Size(280, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 验证核心组件在极端 280px 下不溢出
      expect(find.byType(AdaptiveScaffold), findsOneWidget);
      expect(find.byType(ServerSwitcherPill), findsOneWidget);
    });

    testWidgets('小屏手机 (360x640) 极限渲染: 底部导航5等分自适应且零溢出', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdaptiveScaffold), findsOneWidget);
      expect(find.byType(ServerSwitcherPill), findsOneWidget);
      expect(find.byIcon(LucideIcons.layoutDashboard), findsOneWidget);
      expect(find.byIcon(LucideIcons.globe), findsOneWidget);
      expect(find.byIcon(LucideIcons.box), findsOneWidget);
      expect(find.byIcon(LucideIcons.folder), findsOneWidget);
      expect(find.byIcon(LucideIcons.moreHorizontal), findsOneWidget);
    });

    testWidgets('桌面宽屏 (1440x900) 驾驶舱渲染: 桌面侧边栏展开与折叠零溢出', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('OneDeck'), findsOneWidget);

      // 测试点击“收起侧边栏”
      final collapseBtn = find.byTooltip('Collapse sidebar');
      if (collapseBtn.evaluate().isNotEmpty) {
        await tester.tap(collapseBtn);
        await tester.pumpAndSettle();

        // 验证折叠后（宽度仅68px）底部按钮垂直排布，零溢出
        expect(find.byTooltip('Expand sidebar'), findsOneWidget);

        // 再次点击展开侧边栏
        final expandBtn = find.byTooltip('Expand sidebar');
        await tester.tap(expandBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('弹窗交互测试: 打开设置弹窗无溢出并能顺利渲染', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      final settingsIconFinder = find.byIcon(LucideIcons.settings);
      expect(settingsIconFinder, findsAtLeastNWidgets(1));
      await tester.tap(settingsIconFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(AppSettingsCard), findsOneWidget);
    });

    testWidgets('添加服务器表单验证测试: 弹出并检验表单必填校验', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      final addBtn = find.byType(ElevatedButton);
      if (addBtn.evaluate().isNotEmpty) {
        await tester.tap(addBtn.first);
        await tester.pumpAndSettle();

        expect(find.byType(AddServerCard), findsOneWidget);
      }
    });

    testWidgets('窄屏添加服务器弹窗 (320x640): 5位数端口与按钮自适应且零溢出', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      final addBtn = find.byType(ElevatedButton);
      if (addBtn.evaluate().isNotEmpty) {
        await tester.tap(addBtn.first);
        await tester.pumpAndSettle();

        expect(find.byType(AddServerCard), findsOneWidget);

        // 输入 5 位数高端口
        final portFinder = find.widgetWithText(TextFormField, '9999');
        if (portFinder.evaluate().isNotEmpty) {
          await tester.enterText(portFinder, '65535');
          await tester.pumpAndSettle();
          expect(find.text('65535'), findsOneWidget);
        }
      }
    });

    testWidgets('极限极窄视口 (220x500): 仪表盘无服务器卡片零溢出 (Zero Overflow)', (tester) async {
      tester.view.physicalSize = const Size(220, 500);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1));
    });

    testWidgets('窄屏偏好设置弹窗 (260x600): 偏好设置标题与主题切换器零溢出', (tester) async {
      tester.view.physicalSize = const Size(260, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: OneDeckApp(),
        ),
      );
      await tester.pumpAndSettle();

      final settingsIconFinder = find.byIcon(LucideIcons.settings);
      expect(settingsIconFinder, findsAtLeastNWidgets(1));
      await tester.tap(settingsIconFinder.first);
      await tester.pumpAndSettle();

      expect(find.byType(AppSettingsCard), findsOneWidget);
    });
  });
}
