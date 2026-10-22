import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AppointmentDateBadge extends StatelessWidget {
  const AppointmentDateBadge({
    super.key,
    required this.day,
    required this.month,
  });

  final String day;
  final String month;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            month.toUpperCase(),
            style: AppTextStyles.font11MainBlue600W,
          ),
          Text(
            day,
            style: AppTextStyles.font18DarkBlue700W.copyWith(
              color: AppColors.mainBlue,
            ),
          ),
        ],
      ),
    );
  }
}
