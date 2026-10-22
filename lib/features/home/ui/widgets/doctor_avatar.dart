import 'package:docdoc/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({super.key, required this.initials, this.size = 64});

  final String initials;
  final double size;

  static const _palette = [
    Color(0xFF247CFF),
    Color(0xFF7A5AF8),
    Color(0xFF12B76A),
    Color(0xFFF79009),
    Color(0xFFEE46BC),
    Color(0xFF06AED4),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[initials.codeUnits.fold<int>(0, (a, b) => a + b) %
        _palette.length];

    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.3,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class DoctorSpecialtyBadge extends StatelessWidget {
  const DoctorSpecialtyBadge({super.key, required this.specialty});

  final String specialty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        specialty,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.mainBlue,
        ),
      ),
    );
  }
}
