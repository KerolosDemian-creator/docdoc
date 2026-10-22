import 'package:docdoc/features/home/data/model/doctor.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String shortWeekday(DateTime date) => _weekdays[date.weekday - 1];

/// Returns the next dates on which the doctor works.
List<DateTime> availableDatesFor(Doctor doctor, {int daysToScan = 21}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dates = <DateTime>[];

  for (var index = 0; index < daysToScan; index++) {
    final date = today.add(Duration(days: index));
    if (doctor.availableDays.contains(shortWeekday(date))) {
      dates.add(date);
    }
  }

  if (dates.isEmpty) {
    return List.generate(7, (index) => today.add(Duration(days: index)));
  }
  return dates;
}

/// Time slots that are still in the future for [date].
List<String> availableTimeSlotsFor(Doctor doctor, DateTime date) {
  final now = DateTime.now();
  final isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;

  if (!isToday) return doctor.timeSlots;

  return doctor.timeSlots.where((slot) {
    final parts = slot.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(now.year, now.month, now.day, hour, minute).isAfter(now);
  }).toList();
}
