import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/app.dart';

void main() {
  testWidgets('App shows Hareru text', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HareruApp()),
    );

    expect(find.text('Hareru'), findsWidgets);
  });
}
