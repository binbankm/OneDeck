import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_deck/main.dart';
import 'package:one_deck/core/widgets/adaptive_scaffold.dart';
import 'package:one_deck/features/server/presentation/widgets/server_switcher_pill.dart';

void main() {
  testWidgets('OneDeckApp builds cleanly and renders adaptive scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OneDeckApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify adaptive scaffold and top server switcher pill are rendered
    expect(find.byType(AdaptiveScaffold), findsOneWidget);
    expect(find.byType(ServerSwitcherPill), findsOneWidget);
  });
}
