part of 'booking_cubit.dart';

@freezed
abstract class BookingState with _$BookingState {
  const factory BookingState({
    required DateTime selectedDate,
    String? selectedTime,
    @Default(false) bool isSubmitting,
    String? errorMessage,
    Appointment? bookedAppointment,
  }) = _BookingState;
}
