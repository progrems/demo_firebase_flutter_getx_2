import 'package:flutter_test/flutter_test.dart';

import 'package:demo_firebase_flutter_getx_2/main.dart';

void main() {
  testWidgets('Account page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Compte'), findsOneWidget);
  });
}
