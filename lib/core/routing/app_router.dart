import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/route_arguments.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:docdoc/features/booking/logic/booking_cubit.dart';
import 'package:docdoc/features/booking/ui/booking_screen.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/ui/all_doctors_screen.dart';
import 'package:docdoc/features/home/ui/doctor_details_screen.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/login/ui/login_screen.dart';
import 'package:docdoc/features/main/ui/main_shell.dart';
import 'package:docdoc/features/onboarding/ui/onboarding_screen.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:docdoc/features/sign_up/ui/sign_up_screen.dart';
import 'package:docdoc/features/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case Routes.onboarding:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.signUp:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider<SignUpCubit>(
            create: (_) => getIt<SignUpCubit>(),
            child: const SignUpScreen(),
          ),
        );

      case Routes.home:
        final arguments = settings.arguments;
        final initialTab = arguments is MainShellArguments
            ? arguments.initialTab
            : 0;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => MainShell(initialTab: initialTab),
        );

      case Routes.doctorDetails:
        final doctor = settings.arguments;
        if (doctor is! Doctor) {
          return _notFound(settings.name);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => DoctorDetailsScreen(doctor: doctor),
        );

      case Routes.allDoctors:
        final arguments = settings.arguments;
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => AllDoctorsScreen(
            arguments: arguments is AllDoctorsArguments
                ? arguments
                : const AllDoctorsArguments(),
          ),
        );

      case Routes.booking:
        final doctor = settings.arguments;
        if (doctor is! Doctor) {
          return _notFound(settings.name);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BlocProvider<BookingCubit>(
            create: (_) => BookingCubit(
              getIt<AppointmentRepository>(),
              doctor,
            ),
            child: BookingScreen(doctor: doctor),
          ),
        );

      default:
        return _notFound(settings.name);
    }
  }

  Route<dynamic> _notFound(String? name) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: Center(
          child: Text('No route defined for ${name ?? 'unknown'}'),
        ),
      ),
    );
  }
}
