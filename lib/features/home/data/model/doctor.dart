class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.experienceYears,
    required this.patients,
    required this.address,
    required this.about,
    required this.fee,
    required this.availableDays,
    required this.timeSlots,
  });

  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final int experienceYears;
  final int patients;
  final String address;
  final String about;
  final double fee;

  /// Short weekday names, e.g. `Mon`.
  final List<String> availableDays;

  /// 24-hour slots, e.g. `09:00`.
  final List<String> timeSlots;

  String get initials {
    final parts = name
        .replaceFirst('Dr. ', '')
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'DR';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
