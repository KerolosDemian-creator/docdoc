import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, required this.onTap});

  final Doctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.lightestGray, width: 1.2),
          ),
          child: Row(
            children: [
              DoctorAvatar(initials: doctor.initials, size: 62),
              horizantalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: AppTextStyles.font16DarkBlue700W,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalSpace(4),
                    Text(
                      '${doctor.specialty}  •  ${doctor.address}',
                      style: AppTextStyles.font12Gray500W,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalSpace(8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 18.r,
                        ),
                        horizantalSpace(2),
                        Text(
                          doctor.rating.toStringAsFixed(1),
                          style: AppTextStyles.font12Gray500W,
                        ),
                        horizantalSpace(4),
                        Expanded(
                          child: Text(
                            '(${_formatCount(doctor.reviews)} reviews)',
                            style: AppTextStyles.font12Gray500W,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        horizantalSpace(6),
                        Text(
                          '\$${doctor.fee.toStringAsFixed(0)}',
                          style: AppTextStyles.font14MainBlue500W.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              horizantalSpace(6),
              const Icon(
                Icons.chevron_right,
                color: AppColors.lightGray,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      final value = count / 1000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}k';
    }
    return count.toString();
  }
}
