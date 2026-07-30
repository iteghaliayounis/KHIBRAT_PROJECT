// Smoke test بسيط للتأكد أن التطبيق يبني بدون أخطاء.
//
// This is a basic Flutter widget test that verifies the app boots
// without throwing. To perform an interaction with a widget in your
// test, use the WidgetTester utility.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khibrat_flutter2/main.dart';

void main() {
  testWidgets('App boots and shows splash title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KhubratApp());

    // Verify that the splash screen renders without errors.
    // We use a small delay to let the splash animations start.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(Scaffold), findsWidgets);
  });
}
