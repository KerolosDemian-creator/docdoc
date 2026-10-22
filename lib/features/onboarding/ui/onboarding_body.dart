import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/onboarding/ui/widgets/doc_img_and_text.dart';
import 'package:docdoc/features/onboarding/ui/widgets/doc_logo_and_name.dart';
import 'package:docdoc/features/onboarding/ui/widgets/get_start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: 520,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 30.w),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: () async {
                      await getIt<AuthStorage>().markOnboardingSeen();
                      if (!context.mounted) return;
                      context.pushReplacementNamed(Routes.login);
                    },
                    child: Text(
                      'Skip',
                      style: AppTextStyles.font14MainBlue500W,
                    ),
                  ),
                ),
                DocLogoAndName(),
                SizedBox(height: 36.h),
                DocImgAndText(),
                SizedBox(height: 35.h),
                Text(
                  'Manage and schedule all of your medical appointments easily '
                  'with Docdoc to get a new experience.',
                  style: AppTextStyles.font11Gray400W.copyWith(height: 1.6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35.h),
                const GetStartButton(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
