import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heart_tree_star/authentication/models/authenticate_response.dart';
import 'package:heart_tree_star/authentication/screens/login.dart';
import 'package:heart_tree_star/authentication/services/authentication_service.dart';
import 'package:mocktail/mocktail.dart';

import '../fakes/fakes.dart';
import '../fakes/mock_services.dart';
import 'authenticated_widget.dart';

void main() {
  late AuthenticatedWidget app;
  late MockAuthenticationService authService;
  late MockBeamerDelegate mockDelegate;

  setUpAll(() {
    authService = MockAuthenticationService();
    mockDelegate = MockBeamerDelegate();

    app = AuthenticatedWidget(
        overrides: [
          authServiceProvider.overrideWithValue(authService),
        ],
        child: MaterialApp(
          home: BeamerProvider(
            routerDelegate: mockDelegate,
            child: const LoginScreen(),
          ),
        ));
  });

  testWidgets('Render login smoke test', (WidgetTester tester) async {
    when(() => authService.login()).thenAnswer(
      (_) async => AuthenticateResponse()
        ..user = fakeUser
        ..accessToken = 'token'
        ..incompleteToken = false,
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(app);
    await tester.pump();

    final loginButton = find.byKey(const Key('login-authenticate-fab'));
    await tester.tap(loginButton);

    verify(() => authService.login());
    await tester.pumpAndSettle();

    final firstNameField = find.byKey(const Key('first-name-field'));
    final lastNameField = find.byKey(const Key('last-name-field'));
    expect(firstNameField, findsNothing);
    expect(lastNameField, findsNothing);
  });

  testWidgets('Render login smoke test', (WidgetTester tester) async {
    when(() => authService.login()).thenAnswer(
      (_) async => AuthenticateResponse()..incompleteToken = true,
    );

    await tester.pumpWidget(app);
    await tester.pump();

    final loginButton = find.byKey(const Key('login-authenticate-fab'));
    await tester.tap(loginButton);

    verify(() => authService.login());
    await tester.pumpAndSettle();

    final firstNameField = find.byKey(const Key('first-name-field'));
    final lastNameField = find.byKey(const Key('last-name-field'));
    expect(firstNameField, findsOneWidget);
    expect(lastNameField, findsOneWidget);

    final user = fakeUser;

    when(() => authService.login())
        .thenAnswer((_) async => AuthenticateResponse()
          ..incompleteToken = false
          ..user = user
          ..accessToken = 'token');

    await tester.enterText(firstNameField, user.firstName);
    await tester.enterText(lastNameField, user.lastName);
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    verify(() => authService.login(user.firstName, user.lastName));
  });
}
