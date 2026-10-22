enum AppointmentStatus { confirmed, cancelled }

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.fee,
    required this.status,
    required this.createdAt,
    this.reason,
  });

  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;

  /// The appointment day at midnight.
  final DateTime date;

  /// 24-hour time such as `09:00`.
  final String time;
  final double fee;
  final AppointmentStatus status;
  final DateTime createdAt;
  final String? reason;

  DateTime get startsAt {
    final parts = time.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  bool get isUpcoming =>
      status == AppointmentStatus.confirmed && startsAt.isAfter(DateTime.now());

  bool get isPast => startsAt.isBefore(DateTime.now());

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      doctorName: json['doctorName'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      time: json['time'] as String? ?? '00:00',
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
      status: AppointmentStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => AppointmentStatus.confirmed,
      ),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'specialty': specialty,
    'date': date.toIso8601String(),
    'time': time,
    'fee': fee,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'reason': reason,
  };

  Appointment copyWith({AppointmentStatus? status}) {
    return Appointment(
      id: id,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      date: date,
      time: time,
      fee: fee,
      status: status ?? this.status,
      createdAt: createdAt,
      reason: reason,
    );
  }
}
