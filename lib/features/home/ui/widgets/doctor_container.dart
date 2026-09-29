import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DoctorContainer extends StatelessWidget {
  const DoctorContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 183.h,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      child: Image.asset(
                        'assets/images/home_doctor_background_container.png',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // مهم: الـ Column ياخد حجم محتواه بس
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book and\nschedule with\nnearest doctor',
                            style: AppTextStyles.font18White500W,
                          ),
                          verticalSpace(15.h),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              overlayColor: Colors.white24,
                              minimumSize: Size.zero, // يلغي الحد الأدنى 64x48
                              tapTargetSize: MaterialTapTargetSize
                                  .shrinkWrap, // يلغي الـ 48 الافتراضية
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              'Find Nearby',
                              style: AppTextStyles.font12MainBlue400W,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.h,
                    right: 15.w,
                    child: SizedBox(
                      height: 180.h,
                      width: 136.w,
                      child: Image.asset('assets/images/home_doctor_image.png'),
                    ),
                  ),
                ],
              ),
            );
  }
}