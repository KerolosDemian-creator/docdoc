import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_container.dart';
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
            DoctorContainer()
          ],
        ),
      ),
    );
  }
}