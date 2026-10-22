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

  testWidgets('new users see onboarding and can continue to login', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(DocApp(appRouter: AppRouter()));

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);

    await tester.ensureVisible(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('signed-in users land on the home screen', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await getIt<AuthStorage>().register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    await tester.pumpWidget(DocApp(appRouter: AppRouter()));

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Mona!'), findsOneWidget);
    expect(find.text('Specialties'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('a signed-in user can book a doctor and see the appointment', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await getIt<AuthStorage>().register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    await tester.pumpWidget(DocApp(appRouter: AppRouter()));
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Dr. Randy Wigham'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dr. Randy Wigham'));
    await tester.pumpAndSettle();

    expect(find.text('Doctor Details'), findsOneWidget);

    await tester.tap(find.text('Book Appointment'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a date'), findsOneWidget);

    await tester.tap(find.text('Confirm Booking'));
    await tester.pumpAndSettle();

    expect(find.text('Appointment booked'), findsOneWidget);

    await tester.tap(find.text('View appointments'));
    await tester.pumpAndSettle();

    expect(find.text('My Appointments'), findsOneWidget);
    expect(find.text('Dr. Randy Wigham'), findsOneWidget);
  });
}
