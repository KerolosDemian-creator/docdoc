import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:docdoc/features/booking/logic/booking_dates.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_state.dart';
part 'booking_cubit.freezed.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._repository, this.doctor)
    : super(_initialStateFor(doctor));

  final AppointmentRepository _repository;
  final Doctor doctor;

  static BookingState _initialStateFor(Doctor doctor) {
    final dates = availableDatesFor(doctor);
    for (final date in dates) {
      final slots = availableTimeSlotsFor(doctor, date);
      if (slots.isNotEmpty) {
        return BookingState(selectedDate: date, selectedTime: slots.first);
      }
    }
    return BookingState(
      selectedDate: dates.isEmpty ? DateTime.now() : dates.first,
    );
  }

  void selectDate(DateTime date) {
    if (state.isSubmitting) return;

    final slots = availableTimeSlotsFor(doctor, date);
    final selectedTime = slots.contains(state.selectedTime)
        ? state.selectedTime
        : (slots.isEmpty ? null : slots.first);

    emit(
      BookingState(selectedDate: date, selectedTime: selectedTime),
    );
  }

  void selectTime(String time) {
    if (state.isSubmitting) return;
    emit(
      BookingState(
        selectedDate: state.selectedDate,
        selectedTime: time,
      ),
    );
  }

  Future<void> book({String? reason}) async {
    final time = state.selectedTime;
    if (state.isSubmitting || time == null) return;

    emit(
      BookingState(
        selectedDate: state.selectedDate,
        selectedTime: time,
        isSubmitting: true,
      ),
    );

    try {
      final appointment = await _repository.book(
        doctor: doctor,
        date: state.selectedDate,
        time: time,
        reason: reason,
      );
      if (isClosed) return;
      emit(
        BookingState(
          selectedDate: state.selectedDate,
          selectedTime: time,
          bookedAppointment: appointment,
        ),
      );
    } on BookingException catch (error) {
      if (isClosed) return;
      emit(
        BookingState(
          selectedDate: state.selectedDate,
          selectedTime: time,
          errorMessage: error.message,
        ),
      );
    } on Object {
      if (isClosed) return;
      emit(
        BookingState(
          selectedDate: state.selectedDate,
          selectedTime: time,
          errorMessage:
              'Unable to book this appointment right now. Please try again.',
        ),
      );
    }
  }
}
