part of 'appointments_cubit.dart';

@freezed
abstract class AppointmentsState with _$AppointmentsState {
  const factory AppointmentsState({
    @Default(false) bool isLoading,
    @Default([]) List<Appointment> appointments,
    @Default(0) int upcomingCount,
    String? errorMessage,
  }) = _AppointmentsState;
}
