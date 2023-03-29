import 'package:capstone/authentication/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Map Screen Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoginScreen());

    expect(find.byKey(const Key('login-button')), findsOneWidget);
  });
}
