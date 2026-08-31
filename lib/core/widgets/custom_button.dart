import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height,
    this.width,
    this.buttonColor,
    this.borderRadius,
    required this.buttonText,
    this.buttonTextStyle,
  });
  final double? height;
  final double? width;
  final Color? buttonColor;
  final double? borderRadius;
  final String buttonText;
  final TextStyle? buttonTextStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,

      height: height ?? 50.h,
      decoration: BoxDecoration(
        color: buttonColor ?? AppColors.mainBlue,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
      ),
      child: Center(
        child: Text(
          buttonText,
          style: buttonTextStyle ?? AppTextStyles.font16White600W,
        ),
      ),
    );
  }
}
