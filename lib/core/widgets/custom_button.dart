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
    this.onTap,
    this.isLoading = false,
  });

  final double? height;
  final double? width;
  final Color? buttonColor;
  final double? borderRadius;
  final String buttonText;
  final TextStyle? buttonTextStyle;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = buttonColor ?? AppColors.mainBlue;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.65),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                buttonText,
                style: buttonTextStyle ?? AppTextStyles.font16White600W,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
