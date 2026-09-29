import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';

class DoctorSpecialityListView extends StatelessWidget {
  const DoctorSpecialityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(9),
                height: 55.h,
                width: 55.w,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: SvgPicture.asset('assets/svgs/doctor_white_coat.svg'),
              ),
              Text('General'),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return horizantalSpace(16.w);
        },
      ),
    );
  }
}
