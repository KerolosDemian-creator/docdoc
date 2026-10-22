import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class GetStartButton extends StatelessWidget {
  const GetStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await getIt<AuthStorage>().markOnboardingSeen();
        if (!context.mounted) return;
        context.pushReplacementNamed(Routes.login);
      },
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.mainBlue),
        minimumSize: WidgetStatePropertyAll(
          Size(double.infinity, 52.h),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
      child: Text('Get Started', style: AppTextStyles.font16White600W),
    );
  }
}
