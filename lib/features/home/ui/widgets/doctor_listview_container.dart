import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DoctorListviewContainer extends StatelessWidget {
  const DoctorListviewContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      width: double.infinity,
      height: 130.h,
      child: Row(
        children: [
          Image.asset('assets/images/listview_doctor_image.png'),
          horizantalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dr. Randy Wigham',
                  style: AppTextStyles.font16DarkBlue700W,
                ),
                verticalSpace(10),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text('General', style: AppTextStyles.font12Gray500W),

                      VerticalDivider(
                        thickness: 2,
                        width: 10.w,
                        color: AppColors.gray,
                        indent: 2,
                        endIndent: 2,
                      ),
                      Text(
                        'RSUD Gatot Subroto',
                        style: AppTextStyles.font12Gray500W,
                      ),
                    ],
                  ),
                ),
                verticalSpace(10),

                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.warning),
                    horizantalSpace(2.w),
                    Text('4.8', style: AppTextStyles.font12Gray500W),
                    horizantalSpace(2.w),
                    Text(
                      '(4,279 reviews)',
                      style: AppTextStyles.font12Gray500W,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
