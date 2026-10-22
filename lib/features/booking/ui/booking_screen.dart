import 'package:docdoc/core/helpers/extensions.dart';
import 'package:docdoc/core/helpers/responsive.dart';
import 'package:docdoc/core/helpers/snackbars.dart';
import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/route_arguments.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theme/app_colors.dart';
import 'package:docdoc/core/theme/styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_text_form_field.dart';
import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/booking/logic/booking_cubit.dart';
import 'package:docdoc/features/booking/logic/booking_dates.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/ui/widgets/doctor_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dates = availableDatesFor(widget.doctor);

    return BlocConsumer<BookingCubit, BookingState>(
      listenWhen: (previous, current) {
        final justBooked = previous.bookedAppointment == null &&
            current.bookedAppointment != null;
        final newError = current.errorMessage != null &&
            current.errorMessage != previous.errorMessage;
        return justBooked || newError;
      },
      listener: (context, state) {
        if (state.errorMessage != null) {
          showAppSnackBar(context, state.errorMessage!, isError: true);
          return;
        }
        final appointment = state.bookedAppointment;
        if (appointment != null) {
          _showSuccessDialog(context, appointment);
        }
      },
      builder: (context, state) {
        final timeSlots = availableTimeSlotsFor(
          widget.doctor,
          state.selectedDate,
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Book Appointment')),
          body: ResponsiveCenter(
            maxWidth: AppBreakpoints.content,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
              children: [
                _DoctorSummary(doctor: widget.doctor),
                verticalSpace(24),
                Text('Choose a date', style: AppTextStyles.font16DarkBlue600W),
                verticalSpace(12),
                SizedBox(
                  height: 86.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    separatorBuilder: (context, index) => horizantalSpace(10.w),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      return _DateCard(
                        date: date,
                        selected: DateUtils.isSameDay(
                          date,
                          state.selectedDate,
                        ),
                        onTap: () =>
                            context.read<BookingCubit>().selectDate(date),
                      );
                    },
                  ),
                ),
                verticalSpace(24),
                Text('Choose a time', style: AppTextStyles.font16DarkBlue600W),
                verticalSpace(12),
                if (timeSlots.isEmpty)
                  Text(
                    'No slots are left on this day. Please pick another date.',
                    style: AppTextStyles.font14Gray400W,
                  )
                else
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: timeSlots.map((slot) {
                      final selected = state.selectedTime == slot;
                      return ChoiceChip(
                        label: Text(_displayTime(slot)),
                        selected: selected,
                        onSelected: (_) =>
                            context.read<BookingCubit>().selectTime(slot),
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.mainBlue,
                        side: BorderSide(
                          color: selected
                              ? AppColors.mainBlue
                              : AppColors.lighterGray,
                        ),
                        labelStyle: AppTextStyles.font14DarkBlue500W.copyWith(
                          color: selected ? Colors.white : AppColors.darkBlue,
                        ),
                        showCheckmark: false,
                      );
                    }).toList(),
                  ),
                verticalSpace(24),
                Text('Reason for visit',
                    style: AppTextStyles.font16DarkBlue600W),
                verticalSpace(8),
                CustomTextFormField(
                  controller: _reasonController,
                  hintText: 'Optional note for the doctor',
                  enabled: !state.isSubmitting,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (_) => null,
                ),
                verticalSpace(20),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(
                        label: 'Doctor',
                        value: widget.doctor.name,
                      ),
                      verticalSpace(8),
                      _SummaryRow(
                        label: 'Location',
                        value: widget.doctor.address,
                      ),
                      Divider(height: 24.h, color: AppColors.lighterGray),
                      _SummaryRow(
                        label: 'Consultation fee',
                        value: '\$${widget.doctor.fee.toStringAsFixed(0)}',
                        valueStyle: AppTextStyles.font14MainBlue500W.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: ResponsiveWidth(
              maxWidth: AppBreakpoints.form,
              child: CustomButton(
                buttonText: 'Confirm Booking',
                isLoading: state.isSubmitting,
                onTap: state.selectedTime == null
                    ? null
                    : () => context.read<BookingCubit>().book(
                          reason: _reasonController.text.trim().isEmpty
                              ? null
                              : _reasonController.text.trim(),
                        ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, Appointment appointment) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF12B76A),
          size: 42,
        ),
        title: const Text('Appointment booked'),
        content: Text(
          '${appointment.doctorName}\n'
          '${DateFormat('EEE, d MMM').format(appointment.date)} at '
          '${_displayTime(appointment.time)}',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pushNamedAndRemoveUntil(
                Routes.home,
                predicate: (_) => false,
                arguments: const MainShellArguments(initialTab: 1),
              );
            },
            child: const Text('View appointments'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pushNamedAndRemoveUntil(
                Routes.home,
                predicate: (_) => false,
              );
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _displayTime(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateFormat('h:mm a').format(DateTime(2000, 1, 1, hour, minute));
  }
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(18.r),
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
                  doctor.specialty,
                  style: AppTextStyles.font12Gray500W,
                ),
                verticalSpace(4),
                Text(
                  doctor.address,
                  style: AppTextStyles.font12Gray500W,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 68.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.mainBlue : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.mainBlue : AppColors.lighterGray,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              shortWeekday(date),
              style: AppTextStyles.font11DarkGray400W.copyWith(
                color: selected ? Colors.white70 : AppColors.gray,
              ),
            ),
            verticalSpace(4),
            Text(
              DateFormat('d').format(date),
              style: AppTextStyles.font18DarkBlue700W.copyWith(
                color: selected ? Colors.white : AppColors.darkBlue,
              ),
            ),
            Text(
              DateFormat('MMM').format(date),
              style: AppTextStyles.font11DarkGray400W.copyWith(
                color: selected ? Colors.white70 : AppColors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 116.w,
          child: Text(label, style: AppTextStyles.font12Gray500W),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: valueStyle ?? AppTextStyles.font12DarkBlue500W,
          ),
        ),
      ],
    );
  }
}
