import 'dart:async';

import 'package:docdoc/constants/images.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1400), _openNextScreen);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openNextScreen() {
    if (!mounted) return;

    final authStorage = getIt<AuthStorage>();
    final String nextRoute;
    if (authStorage.isLoggedIn) {
      nextRoute = Routes.home;
    } else if (authStorage.hasSeenOnboarding) {
      nextRoute = Routes.login;
    } else {
      nextRoute = Routes.onboarding;
    }

    context.pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.lightBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(AppImages.docdocLogo, width: 86),
              const SizedBox(height: 18),
              Text('Docdoc', style: AppTextStyles.font32BlueBold),
              const SizedBox(height: 10),
              Text(
                'Your health, one tap away.',
                style: AppTextStyles.font14Gray400W,
              ),
              const Spacer(),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.mainBlue,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
