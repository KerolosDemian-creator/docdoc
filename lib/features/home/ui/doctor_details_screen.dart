import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: ResponsiveCenter(
        maxWidth: AppBreakpoints.content,
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            Container(
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Row(
                children: [
                  DoctorAvatar(initials: doctor.initials, size: 82),
                  horizantalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: AppTextStyles.font18DarkBlue700W,
                        ),
                        verticalSpace(6),
                        DoctorSpecialtyBadge(specialty: doctor.specialty),
                        verticalSpace(8),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 18.r,
                            ),
                            horizantalSpace(4),
                            Expanded(
                              child: Text(
                                '${doctor.rating} (${doctor.reviews} reviews)',
                                style: AppTextStyles.font12Gray500W,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(20),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: '${doctor.experienceYears}+ yrs',
                    label: 'Experience',
                  ),
                ),
                horizantalSpace(10),
                Expanded(
                  child: _StatTile(
                    value: _formatCount(doctor.patients),
                    label: 'Patients',
                  ),
                ),
                horizantalSpace(10),
                Expanded(
                  child: _StatTile(
                    value: '\$${doctor.fee.toStringAsFixed(0)}',
                    label: 'Visit fee',
                  ),
                ),
              ],
            ),
            verticalSpace(24),
            const _SectionTitle('About'),
            verticalSpace(8),
            Text(
              doctor.about,
              style: AppTextStyles.font14Gray400W.copyWith(height: 1.6),
            ),
            verticalSpace(20),
            const _SectionTitle('Location'),
            verticalSpace(8),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.mainBlue,
                  size: 20,
                ),
                horizantalSpace(8),
                Expanded(
                  child: Text(
                    doctor.address,
                    style: AppTextStyles.font14DarkGray400W,
                  ),
                ),
              ],
            ),
            verticalSpace(20),
            const _SectionTitle('Available days'),
            verticalSpace(10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctor.availableDays
                  .map(
                    (day) => Chip(
                      label: Text(day),
                      backgroundColor: AppColors.lightBlue,
                      side: BorderSide.none,
                      labelStyle: AppTextStyles.font12MainBlue400W,
                    ),
                  )
                  .toList(),
            ),
            verticalSpace(16),
            const _SectionTitle('Time slots'),
            verticalSpace(10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: doctor.timeSlots
                  .map(
                    (slot) => Chip(
                      label: Text(slot),
                      backgroundColor: AppColors.lightestGray,
                      side: BorderSide.none,
                      labelStyle: AppTextStyles.font12DarkBlue500W,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: ResponsiveWidth(
          maxWidth: AppBreakpoints.form,
          child: CustomButton(
            buttonText: 'Book Appointment',
            onTap: () => context.pushNamed(
              Routes.booking,
              arguments: doctor,
            ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.font16DarkBlue600W);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.lightestGray),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.font14MainBlue500W.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(4),
          Text(
            label,
            style: AppTextStyles.font11Gray400W,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
