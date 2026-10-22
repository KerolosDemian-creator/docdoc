import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/features/home/data/repo/mock_doctor_repository.dart';
import 'package:docdoc/features/home/ui/all_doctors_screen.dart';
import 'package:docdoc/features/home/ui/doctor_details_screen.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_card.dart';
import 'package:docdoc/features/login/ui/login_body.dart';
import 'package:docdoc/features/main/ui/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
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

  Future<void> pumpAtSize(
    WidgetTester tester,
    Size size,
    Widget home,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        fontSizeResolver: responsiveFontSize,
        builder: (context, child) => MaterialApp(home: home),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('phones use the bottom navigation bar', (tester) async {
    await pumpAtSize(tester, const Size(390, 844), const MainShell());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Hi, there!'), findsOneWidget);
  });

  testWidgets('wide screens switch to the navigation rail', (tester) async {
    await pumpAtSize(tester, const Size(1024, 768), const MainShell());

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('login form stays narrow and centred on wide screens', (
    tester,
  ) async {
    await pumpAtSize(
      tester,
      const Size(1024, 768),
      const Scaffold(body: LoginBody(isLoading: false)),
    );

    final formSize = tester.getSize(find.byType(Form));
    expect(formSize.width, lessThanOrEqualTo(AppBreakpoints.form));

    final formCentre = tester.getCenter(find.byType(Form)).dx;
    expect(formCentre, closeTo(512, 1));
  });

  testWidgets('doctor list uses two columns on wide screens', (tester) async {
    await pumpAtSize(
      tester,
      const Size(1024, 768),
      const AllDoctorsScreen(arguments: AllDoctorsArguments()),
    );

    final cards = find.byType(DoctorCard);
    expect(cards, findsWidgets);

    final first = tester.getTopLeft(cards.at(0));
    final second = tester.getTopLeft(cards.at(1));
    expect(second.dy, closeTo(first.dy, 1));
    expect(second.dx, greaterThan(first.dx));

    final firstWidth = tester.getSize(cards.at(0)).width;
    expect(firstWidth, lessThan(500));
  });

  testWidgets('key screens build without overflow on phones and tablets', (
    tester,
  ) async {
    final doctor = const MockDoctorRepository().getDoctors().first;
    final sizes = <Size>[
      const Size(320, 568),
      const Size(390, 844),
      const Size(768, 1024),
      const Size(1024, 768),
    ];

    for (final size in sizes) {
      await pumpAtSize(tester, size, DoctorDetailsScreen(doctor: doctor));
      expect(
        tester.takeException(),
        isNull,
        reason: 'doctor details overflowed at $size',
      );

      await pumpAtSize(tester, size, const MainShell());
      expect(
        tester.takeException(),
        isNull,
        reason: 'main shell overflowed at $size',
      );
    }
  });
}
