import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/onboarding/ui/widgets/doc_img_and_text.dart';
import 'package:docdoc/features/onboarding/ui/widgets/doc_logo_and_name.dart';
import 'package:docdoc/features/onboarding/ui/widgets/get_start_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                DocLogoAndName(),
                SizedBox(height: 50.h),
                DocImgAndText(),
                SizedBox(height: 35.h),
                // todo
                Text(
                  'Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.',
                  style: AppTextStyles.font11Gray400W,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 35.h),
                GetStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
