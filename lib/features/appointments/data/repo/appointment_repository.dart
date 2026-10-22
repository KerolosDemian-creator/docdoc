import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();

  Future<Appointment> book({
    required Doctor doctor,
    required DateTime date,
    required String time,
    String? reason,
  });

  Future<void> cancel(String appointmentId);

  Future<int> countUpcoming();
}

class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}
