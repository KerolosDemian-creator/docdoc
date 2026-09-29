import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, Omar!', style: AppTextStyles.font18DarkBlue700W),
            Text('How Are you Today?', style: AppTextStyles.font11DarkGray400W),
          ],
        ),
      const  Spacer(),
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.lightestGray,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: SvgPicture.asset('assets/svgs/Notification_icon.svg'),
          ),
        ),
      ],
    );
  }
}
