import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.inputFormatters,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
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
  final FormFieldValidator<String> validator;
  final OutlineInputBorder? enabledBorder;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? focusedErrorBorder;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 16.r);

    return TextFormField(
      controller: controller,
      obscureText: isObsecured ?? false,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      style: AppTextStyles.font14DarkBlue500W,
      cursorColor: AppColors.mainBlue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 20.w),
        fillColor: fillColor ?? AppColors.lightWhite,
        filled: true,
        errorText: errorText,
        errorMaxLines: 2,
        hintText: hintText,
        hintStyle: hintStyle ?? AppTextStyles.font14LightGray500W,
        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: visibilityAction,
                icon: suffixIcon!,
                color: AppColors.gray,
                splashRadius: 20.r,
              ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.lighterGray,
                width: 1.3,
              ),
              borderRadius: radius,
            ),
        disabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.lightestGray,
                width: 1.3,
              ),
              borderRadius: radius,
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? AppColors.mainBlue,
                width: 1.3,
              ),
              borderRadius: radius,
            ),
        errorBorder:
            errorBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: radius,
            ),
        focusedErrorBorder:
            focusedErrorBorder ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: radius,
            ),
      ),
      validator: validator,
    );
  }
}
