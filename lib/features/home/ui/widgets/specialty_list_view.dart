import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/features/home/data/model/specialty.dart';
import 'package:docdoc/features/home/ui/widgets/specialty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class SpecialtyListView extends StatelessWidget {
  const SpecialtyListView({
    super.key,
    required this.specialties,
    required this.selectedSpecialty,
    required this.onSelected,
  });

  final List<Specialty> specialties;
  final String selectedSpecialty;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length + 1,
        separatorBuilder: (_, _) => horizantalSpace(16.w),
        itemBuilder: (context, index) {
          final name = index == 0 ? 'All' : specialties[index - 1].name;
          final isSelected = selectedSpecialty == name;

          return GestureDetector(
            onTap: () => onSelected(name),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 58.r,
                  width: 58.r,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainBlue
                        : AppColors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    specialtyIcon(name),
                    color: isSelected ? Colors.white : AppColors.mainBlue,
                    size: 26.r,
                  ),
                ),
                verticalSpace(8),
                SizedBox(
                  width: 72.w,
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font11DarkGray400W.copyWith(
                      color: isSelected
                          ? AppColors.mainBlue
                          : AppColors.darkGray,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
