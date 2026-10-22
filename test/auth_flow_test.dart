import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/app_router.dart';
import 'package:docdoc/doc_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await getIt.reset();
    SharedPreferences.setMockInitialValues({});
    await getItSetup();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('a new user can sign up and land on home', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(DocApp(appRouter: AppRouter()));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsWidgets);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Mona Ali');
    await tester.enterText(fields.at(1), 'mona@example.com');
    await tester.enterText(fields.at(2), '01012345678');

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Female').last);
    await tester.pumpAndSettle();

    await tester.enterText(fields.at(3), 'Strong1!');
    await tester.enterText(fields.at(4), 'Strong1!');

    final createButton = find.widgetWithText(ElevatedButton, 'Create Account');
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();

    expect(find.text('Hi, Mona!'), findsOneWidget);
    expect(getIt<AuthStorage>().isLoggedIn, isTrue);
  });

  testWidgets('an existing user can log in', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final storage = getIt<AuthStorage>();
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );
    await storage.logout();
    await storage.markOnboardingSeen();

    await tester.pumpWidget(DocApp(appRouter: AppRouter()));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'mona@example.com');
    await tester.enterText(fields.at(1), 'Strong1!');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Mona!'), findsOneWidget);
  });
}
