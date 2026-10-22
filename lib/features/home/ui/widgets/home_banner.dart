import 'package:docdoc/constants/images.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key, required this.onFindDoctor});

  final VoidCallback onFindDoctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.mainBlue, Color(0xFF58A0FF)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 8.w, 18.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book and schedule with the nearest doctor',
                    style: AppTextStyles.font18White500W.copyWith(
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TextButton(
                    onPressed: onFindDoctor,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.mainBlue,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Find a doctor',
                      style: AppTextStyles.font12MainBlue400W,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Image.asset(
              AppImages.homeDoctorImage,
              width: 108.w,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
