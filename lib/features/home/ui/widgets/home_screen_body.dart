import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_container.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_speciality_list_view.dart';
import 'package:docdoc/features/home/ui/widgets/doctors_listview.dart';
import 'package:docdoc/features/home/ui/widgets/home_screen_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            HomeScreenAppBar(),
            verticalSpace(4.h),
            DoctorContainer(),
            verticalSpace(24),

            //Doctor Speciality
            Row(
              children: [
                Text(
                  'Doctor Speciality',
                  style: AppTextStyles.font18DarkBlue600W,
                ),
                Spacer(),
                Text('See All', style: AppTextStyles.font12MainBlue400W),
              ],
            ),
            verticalSpace(16),

            DoctorSpecialityListView(),
            verticalSpace(12),

            DoctorsListview(),
          ],
        ),
      ),
    );
  }
}
