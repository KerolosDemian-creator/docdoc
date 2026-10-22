import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointments_state.dart';
part 'appointments_cubit.freezed.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit(this._repository) : super(const AppointmentsState());

  final AppointmentRepository _repository;

  Future<void> load() async {
    emit(
      AppointmentsState(
        isLoading: true,
        appointments: state.appointments,
      ),
    );

    try {
      final appointments = await _repository.getAppointments();
      if (isClosed) return;
      emit(
        AppointmentsState(
          isLoading: false,
          appointments: appointments,
          upcomingCount: appointments.where((item) => item.isUpcoming).length,
        ),
      );
    } on Object {
      if (isClosed) return;
      emit(
        const AppointmentsState(
          isLoading: false,
          errorMessage: 'Unable to load your appointments. Please try again.',
        ),
      );
    }
  }

  Future<bool> cancel(String appointmentId) async {
    try {
      await _repository.cancel(appointmentId);
      await load();
      return true;
    } on Object {
      if (isClosed) return false;
      emit(
        AppointmentsState(
          isLoading: false,
          appointments: state.appointments,
          errorMessage: 'Unable to cancel the appointment. Please try again.',
        ),
      );
      return false;
    }
  }
}
