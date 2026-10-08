import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_deck/main.dart';

void main() {
  testWidgets('OneDeckApp builds cleanly and renders app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: OneDeckApp(),
      ),
    );

    // Wait for localizations to load
    await tester.pumpAndSettle();

    expect(find.text('OneDeck'), findsOneWidget);
  });
}
