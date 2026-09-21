import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({  
    super.key,
    this.suffixIcon,
    this.fillColor,
    required this.hintText,
    this.hintStyle,
    this.borderColor,
    this.textFormFieldWidth,
    this.borderRadius,
    this.isObsecured,
    this.visibilityAction,
    this.controller,
    required this.validator,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
  });
  final Icon? suffixIcon;
  final Color? fillColor;
  final String hintText;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final double? textFormFieldWidth;
  final double? borderRadius;
  final bool? isObsecured;
  final VoidCallback? visibilityAction;
  final TextEditingController? controller;
  final Function(String?) validator;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObsecured ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
        fillColor: fillColor ?? AppColors.lightWhite,
        filled: true,

        hintText: hintText,
        hintStyle: hintStyle ?? AppTextStyles.font14LightGray500W,
        suffixIcon: suffixIcon == null
            ? null
            : GestureDetector(
                onTap: visibilityAction ?? () {},
                child: suffixIcon,
              ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lighterGray,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0.r),
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lighterGray,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0.r),
            ),

        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? Colors.red,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0.r),
            ),
        focusedErrorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? Colors.red,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0.r),
            ),
      ),
      validator: (value) {
        return validator(value);
      },
    );
  }
}
