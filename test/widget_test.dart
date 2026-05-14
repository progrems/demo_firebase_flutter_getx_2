// This is a basic Flutter widget test.
//
// The app does not use the default counter page anymore.
// This test checks that the first screen of our Firebase/GetX app is shown.

import 'package:demo_firebase_flutter_getx_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Account page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DemoFirebaseFlutterGetx());
    await tester.pumpAndSettle();

    // Verify that the first page shows the Compte button.
    expect(find.text('Compte'), findsOneWidget);
  });
}
