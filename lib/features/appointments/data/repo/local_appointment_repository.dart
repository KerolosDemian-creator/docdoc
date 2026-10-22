import 'dart:convert';

import 'package:docdoc/features/appointments/data/model/appointment.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAppointmentRepository implements AppointmentRepository {
  LocalAppointmentRepository(
    this._preferences, {
    String Function()? userKey,
  }) : _userKey = userKey ?? (() => 'guest');

  final SharedPreferences _preferences;
  final String Function() _userKey;

  String get _storageKey => 'docdoc_appointments_v1_${_userKey()}';

  @override
  Future<List<Appointment>> getAppointments() async {
    final appointments = _read();
    appointments.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return appointments;
  }

  @override
  Future<Appointment> book({
    required Doctor doctor,
    required DateTime date,
    required String time,
    String? reason,
  }) async {
    final appointments = _read();
    final hasConflict = appointments.any(
      (appointment) =>
          appointment.status == AppointmentStatus.confirmed &&
          appointment.doctorId == doctor.id &&
          _isSameDay(appointment.date, date) &&
          appointment.time == time,
    );

    if (hasConflict) {
      throw const BookingException(
        'You already have an appointment with this doctor at that time.',
      );
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!_dateTimeFor(normalizedDate, time).isAfter(DateTime.now())) {
      throw const BookingException(
        'That time slot has already passed. Please pick another one.',
      );
    }

    final appointment = Appointment(
      id: 'appt-${DateTime.now().microsecondsSinceEpoch}',
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialty: doctor.specialty,
      date: normalizedDate,
      time: time,
      fee: doctor.fee,
      status: AppointmentStatus.confirmed,
      createdAt: DateTime.now(),
      reason: reason,
    );

    appointments.add(appointment);
    await _write(appointments);
    return appointment;
  }

  @override
  Future<void> cancel(String appointmentId) async {
    final appointments = _read();
    final index = appointments.indexWhere(
      (appointment) => appointment.id == appointmentId,
    );
    if (index == -1) return;

    appointments[index] = appointments[index].copyWith(
      status: AppointmentStatus.cancelled,
    );
    await _write(appointments);
  }

  @override
  Future<int> countUpcoming() async {
    final appointments = _read();
    return appointments.where((appointment) => appointment.isUpcoming).length;
  }

  List<Appointment> _read() {
    final raw = _preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map(
            (item) => Appointment.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } on FormatException {
      return [];
    }
  }

  Future<void> _write(List<Appointment> appointments) async {
    await _preferences.setString(
      _storageKey,
      jsonEncode(
        appointments.map((appointment) => appointment.toJson()).toList(),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _dateTimeFor(DateTime date, String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
