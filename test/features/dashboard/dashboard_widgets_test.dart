import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:one_deck/core/localization/generated/app_localizations.dart';
import 'package:one_deck/features/dashboard/data/models/dashboard_models.dart';
import 'package:one_deck/features/dashboard/presentation/widgets/multi_disk_card.dart';
import 'package:one_deck/features/dashboard/presentation/widgets/disk_io_card.dart';
import 'package:one_deck/features/dashboard/presentation/widgets/memory_swap_card.dart';
import 'package:one_deck/features/dashboard/presentation/widgets/top_processes_card.dart';

Widget _buildWrapper(Widget child, {Size size = const Size(320, 800), Locale locale = const Locale('zh')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Widget Tests (Mobile Viewport & Zero Overflow)', () {
    testWidgets('MultiDiskCard with very long mapper device path does NOT overflow on 320px screen', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final disks = [
        const DiskInfo(
          path: '/',
          device: '/dev/mapper/ubuntu--vg-ubuntu--lv',
          type: 'ext4',
          total: 103722000000,
          used: 12777000000,
          free: 86529000000,
          usedPercent: 12.3,
          inodesTotal: 6225920,
          inodesUsed: 192300,
          inodesUsedPercent: 3.09,
        ),
      ];

      await tester.pumpWidget(_buildWrapper(MultiDiskCard(disks: disks), size: const Size(320, 800)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('/'), findsOneWidget);
      expect(find.text('ext4'), findsOneWidget);
    });

    testWidgets('DiskIoCard renders all metrics cleanly on narrow mobile screen without overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final current = DashboardCurrent(
        ioReadBytes: 9300000000,
        ioWriteBytes: 398200000,
        ioCount: 731240,
      );

      await tester.pumpWidget(_buildWrapper(DiskIoCard(current: current), size: const Size(320, 800)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('731240 次'), findsOneWidget);
    });

    testWidgets('MemorySwapCard shows safe status for negligible swap (<50MB) and warning for high swap', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Low swap: 1.3 MB (0.1%)
      final currentLow = DashboardCurrent(
        memoryTotal: 8 * 1024 * 1024 * 1024,
        memoryUsed: 3 * 1024 * 1024 * 1024,
        swapMemoryTotal: 2 * 1024 * 1024 * 1024,
        swapMemoryUsed: 1300000,
        swapMemoryUsedPercent: 0.1,
      );

      await tester.pumpWidget(_buildWrapper(MemorySwapCard(current: currentLow), size: const Size(320, 800)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('正常'), findsOneWidget);
      expect(find.text('已触发换页'), findsNothing);

      // High swap: 500MB (25%)
      final currentHigh = DashboardCurrent(
        memoryTotal: 8 * 1024 * 1024 * 1024,
        memoryUsed: 7 * 1024 * 1024 * 1024,
        swapMemoryTotal: 2 * 1024 * 1024 * 1024,
        swapMemoryUsed: 500 * 1024 * 1024,
        swapMemoryUsedPercent: 25.0,
      );

      await tester.pumpWidget(_buildWrapper(MemorySwapCard(current: currentHigh), size: const Size(320, 800)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('已触发换页'), findsOneWidget);
    });

    testWidgets('TopProcessesCard displays process items without overflow on narrow 320px viewport', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final topCpu = [
        const Process(name: '1panel', pid: 1042, user: 'root', percent: 14.5, memory: 120000000),
        const Process(name: 'mysqld', pid: 2314, user: 'mysql', percent: 8.2, memory: 520000000),
      ];

      await tester.pumpWidget(_buildWrapper(
        TopProcessesCard(topCpu: topCpu, topMem: const []),
        size: const Size(320, 800),
      ));
      await tester.pumpAndSettle();

expect(tester.takeException(), isNull);
      expect(find.text('1panel'), findsOneWidget);
      expect(find.text('mysqld'), findsOneWidget);
      expect(find.text('14.5%'), findsOneWidget);
    });
  });
}
