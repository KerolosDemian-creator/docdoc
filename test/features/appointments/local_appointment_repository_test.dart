import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:docdoc/features/appointments/data/repo/local_appointment_repository.dart';
import 'package:docdoc/features/home/data/repo/mock_doctor_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late LocalAppointmentRepository repository;
  final doctor = const MockDoctorRepository().getDoctors().first;
  final futureDate = DateTime.now().add(const Duration(days: 2));

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    repository = LocalAppointmentRepository(
      preferences,
      userKey: () => 'mona@example.com',
    );
  });

  test('books, lists and cancels an appointment', () async {
    final appointment = await repository.book(
      doctor: doctor,
      date: futureDate,
      time: '09:00',
      reason: 'Annual checkup',
    );

    expect(appointment.status, AppointmentStatus.confirmed);
    expect(appointment.doctorId, doctor.id);
    expect(appointment.reason, 'Annual checkup');

    final appointments = await repository.getAppointments();
    expect(appointments, hasLength(1));
    expect(await repository.countUpcoming(), 1);

    await repository.cancel(appointment.id);

    final updated = await repository.getAppointments();
    expect(updated.single.status, AppointmentStatus.cancelled);
    expect(await repository.countUpcoming(), 0);
  });

  test('rejects a duplicate slot for the same doctor', () async {
    await repository.book(
      doctor: doctor,
      date: futureDate,
      time: '09:00',
    );

    expect(
      () => repository.book(
        doctor: doctor,
        date: futureDate,
        time: '09:00',
      ),
      throwsA(isA<BookingException>()),
    );
  });

  test('allows a different time on the same day', () async {
    await repository.book(
      doctor: doctor,
      date: futureDate,
      time: '09:00',
    );
    final second = await repository.book(
      doctor: doctor,
      date: futureDate,
      time: '10:30',
    );

    expect(second.time, '10:30');
    expect(await repository.getAppointments(), hasLength(2));
  });

  test('returns an empty list for fresh storage', () async {
    expect(await repository.getAppointments(), isEmpty);
    expect(await repository.countUpcoming(), 0);
  });

  test('keeps each user\'s appointments separate', () async {
    final otherUserRepository = LocalAppointmentRepository(
      preferences,
      userKey: () => 'other@example.com',
    );

    await repository.book(
      doctor: doctor,
      date: futureDate,
      time: '09:00',
    );

    expect(await repository.getAppointments(), hasLength(1));
    expect(await otherUserRepository.getAppointments(), isEmpty);
  });
}
