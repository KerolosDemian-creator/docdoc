import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/empty_state.dart';
import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/appointments/logic/appointments_cubit.dart';
import 'package:docdoc/features/appointments/ui/widgets/appointment_date_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key, required this.onFindDoctor});

  final VoidCallback onFindDoctor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
        builder: (context, state) {
          return ResponsiveCenter(
            maxWidth: AppBreakpoints.content,
            child: RefreshIndicator(
              color: AppColors.mainBlue,
              onRefresh: () => context.read<AppointmentsCubit>().load(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                children: [
                  Text('My Appointments', style: AppTextStyles.font24Black700W),
                  verticalSpace(6),
                  Text(
                    state.upcomingCount == 0
                        ? 'Your upcoming visits will appear here.'
                        : 'You have ${state.upcomingCount} upcoming '
                            '${state.upcomingCount == 1 ? 'visit' : 'visits'}.',
                    style: AppTextStyles.font14Gray400W,
                  ),
                  verticalSpace(20),
                  if (state.isLoading && state.appointments.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.h),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else if (state.errorMessage != null &&
                      state.appointments.isEmpty)
                    EmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Something went wrong',
                      message: state.errorMessage!,
                      actionLabel: 'Try again',
                      onAction: () => context.read<AppointmentsCubit>().load(),
                    )
                  else if (state.appointments.isEmpty)
                    EmptyState(
                      icon: Icons.calendar_month_outlined,
                      title: 'No appointments yet',
                      message:
                          'Find a doctor and book your first appointment in a '
                          'few taps.',
                      actionLabel: 'Find a doctor',
                      onAction: onFindDoctor,
                    )
                  else
                    ...state.appointments.map(
                      (appointment) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _AppointmentCard(appointment: appointment),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final isCancelled = appointment.status == AppointmentStatus.cancelled;
    final isUpcoming = appointment.isUpcoming;
    final statusLabel = isCancelled
        ? 'Cancelled'
        : isUpcoming
            ? 'Confirmed'
            : 'Completed';
    final statusColor = isCancelled
        ? const Color(0xFFB3261E)
        : isUpcoming
            ? const Color(0xFF12B76A)
            : AppColors.gray;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.lightestGray, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppointmentDateBadge(
                day: DateFormat('d').format(appointment.date),
                month: DateFormat('MMM').format(appointment.date),
              ),
              horizantalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: AppTextStyles.font16DarkBlue700W,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    verticalSpace(4),
                    Text(
                      appointment.specialty,
                      style: AppTextStyles.font12Gray500W,
                    ),
                    verticalSpace(6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 15,
                          color: AppColors.gray,
                        ),
                        horizantalSpace(4),
                        Flexible(
                          child: Text(
                            '${DateFormat('EEE, d MMM').format(appointment.date)}'
                            ' at ${_formatTime(appointment.time)}',
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
              horizantalSpace(8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (isUpcoming) ...[
            Divider(height: 24.h, color: AppColors.lightestGray),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Visit fee: \$${appointment.fee.toStringAsFixed(0)}',
                    style: AppTextStyles.font12DarkGray400W,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _confirmCancellation(context),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFB3261E),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancellation(BuildContext context) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: Text(
          'Cancel your visit with ${appointment.doctorName} on '
          '${DateFormat('EEE, d MMM').format(appointment.date)} at '
          '${_formatTime(appointment.time)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel appointment'),
          ),
        ],
      ),
    );

    if (shouldCancel != true || !context.mounted) return;

    final cancelled = await context.read<AppointmentsCubit>().cancel(
          appointment.id,
        );
    if (!context.mounted) return;
    showAppSnackBar(
      context,
      cancelled
          ? 'Appointment cancelled.'
          : 'Could not cancel the appointment. Please try again.',
      isError: !cancelled,
    );
  }

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateFormat('h:mm a').format(DateTime(2000, 1, 1, hour, minute));
  }
}
