import 'package:docdoc/constants/images.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/svg.dart';

class DocLogoAndName extends StatelessWidget {
  const DocLogoAndName({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppImages.docdocLogo),
        SizedBox(width: 10.w),
        Text('Docdoc', style: AppTextStyles.font24Black700W),
      ],
    );
  }
}
