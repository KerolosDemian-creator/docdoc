import 'package:docdoc/constants/images.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({
    super.key,
    required this.userName,
    required this.onNotificationTap,
  });

  final String userName;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $userName!',
                style: AppTextStyles.font18DarkBlue700W,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'How are you today?',
                style: AppTextStyles.font11DarkGray400W,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onNotificationTap,
          tooltip: 'My appointments',
          icon: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.lightestGray,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: SvgPicture.asset(
              AppImages.notificationIcon,
              width: 20.r,
              height: 20.r,
            ),
          ),
        ),
      ],
    );
  }
}
