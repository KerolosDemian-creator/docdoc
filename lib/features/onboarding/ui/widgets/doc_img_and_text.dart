import 'package:docdoc/constants/images.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DocImgAndText extends StatelessWidget {
  const DocImgAndText({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AppImages.docdocLogoLowOpacity),
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.14, 0.4],
            ),
          ),
          child: Image.asset(AppImages.onboardingDoctorImg),
        ),
        // todo
        Positioned(
          bottom: -10.h,
          right: 0.h,
          left: 0.w,
          child: Text(
            'Best Doctor\nAppointment App',
            textAlign: TextAlign.center,
            style: AppTextStyles.font32BlueBold.copyWith(height: 1.3.sp),
          ),
        ),
      ],
    );
  }
}
