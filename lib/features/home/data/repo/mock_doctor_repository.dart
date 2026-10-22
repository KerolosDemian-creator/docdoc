import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/data/model/specialty.dart';
import 'package:docdoc/features/home/data/repo/doctor_repository.dart';

/// Local, deterministic doctor catalogue used by the offline demo.
class MockDoctorRepository implements DoctorRepository {
  const MockDoctorRepository();

  static const _specialties = [
    Specialty(name: 'General'),
    Specialty(name: 'Cardiology'),
    Specialty(name: 'Neurology'),
    Specialty(name: 'Pediatrics'),
    Specialty(name: 'Orthopedic'),
    Specialty(name: 'Dermatology'),
    Specialty(name: 'ENT'),
    Specialty(name: 'Ophthalmology'),
    Specialty(name: 'Gynecology'),
  ];

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  static const _morningSlots = ['09:00', '10:30', '12:00', '14:30', '16:00'];
  static const _lateSlots = ['10:00', '11:30', '13:00', '15:00', '17:30'];

  static const _doctors = [
    Doctor(
      id: 'doc-001',
      name: 'Dr. Randy Wigham',
      specialty: 'General',
      rating: 4.8,
      reviews: 4279,
      experienceYears: 12,
      patients: 8500,
      address: 'RSUD Gatot Subroto',
      about:
          'A friendly general practitioner focused on preventive care, '
          'everyday illnesses and long-term health planning.',
      fee: 25,
      availableDays: _weekdays,
      timeSlots: _morningSlots,
    ),
    Doctor(
      id: 'doc-002',
      name: 'Dr. Sarah Mitchell',
      specialty: 'Cardiology',
      rating: 4.9,
      reviews: 3120,
      experienceYears: 15,
      patients: 10200,
      address: 'City Heart Center',
      about:
          'Cardiologist with a special interest in hypertension, arrhythmia '
          'and preventive heart care for adults.',
      fee: 40,
      availableDays: ['Mon', 'Wed', 'Fri'],
      timeSlots: _morningSlots,
    ),
    Doctor(
      id: 'doc-003',
      name: 'Dr. David Chen',
      specialty: 'Neurology',
      rating: 4.7,
      reviews: 1890,
      experienceYears: 10,
      patients: 5400,
      address: 'Neuro Care Clinic',
      about:
          'Treats headaches, migraine, nerve pain and movement disorders with '
          'a calm, evidence-based approach.',
      fee: 45,
      availableDays: ['Tue', 'Thu', 'Sat'],
      timeSlots: _lateSlots,
    ),
    Doctor(
      id: 'doc-004',
      name: 'Dr. Aisha Rahman',
      specialty: 'Pediatrics',
      rating: 4.9,
      reviews: 5210,
      experienceYears: 9,
      patients: 11800,
      address: 'Kids Health Medical',
      about:
          'Pediatrician who supports parents through newborn care, growth '
          'checks, vaccinations and childhood illnesses.',
      fee: 30,
      availableDays: ['Mon', 'Tue', 'Wed', 'Thu'],
      timeSlots: _morningSlots,
    ),
    Doctor(
      id: 'doc-005',
      name: 'Dr. Michael Brown',
      specialty: 'Orthopedic',
      rating: 4.6,
      reviews: 1420,
      experienceYears: 14,
      patients: 7100,
      address: 'Bone & Joint Hospital',
      about:
          'Specializes in sports injuries, joint pain and rehabilitation for '
          'active patients of all ages.',
      fee: 50,
      availableDays: ['Wed', 'Thu', 'Fri'],
      timeSlots: _lateSlots,
    ),
    Doctor(
      id: 'doc-006',
      name: 'Dr. Emily Carter',
      specialty: 'Dermatology',
      rating: 4.8,
      reviews: 2340,
      experienceYears: 8,
      patients: 6300,
      address: 'Skin Wellness Clinic',
      about:
          'Helps patients manage acne, eczema, allergies and general skin '
          'health with practical treatment plans.',
      fee: 35,
      availableDays: ['Tue', 'Thu', 'Sat'],
      timeSlots: _morningSlots,
    ),
    Doctor(
      id: 'doc-007',
      name: 'Dr. James Wilson',
      specialty: 'ENT',
      rating: 4.5,
      reviews: 980,
      experienceYears: 11,
      patients: 4700,
      address: 'Ear, Nose & Throat Center',
      about:
          'Treats sinus problems, hearing concerns, sore throats and other '
          'ear, nose and throat conditions.',
      fee: 38,
      availableDays: ['Mon', 'Wed', 'Sat'],
      timeSlots: _lateSlots,
    ),
    Doctor(
      id: 'doc-008',
      name: 'Dr. Olivia Martinez',
      specialty: 'Ophthalmology',
      rating: 4.7,
      reviews: 1670,
      experienceYears: 13,
      patients: 8900,
      address: 'Vision Eye Institute',
      about:
          'Eye specialist covering routine vision checks, dry eye, cataracts '
          'and common eye infections.',
      fee: 42,
      availableDays: ['Tue', 'Wed', 'Fri'],
      timeSlots: _morningSlots,
    ),
    Doctor(
      id: 'doc-009',
      name: 'Dr. Daniel Lee',
      specialty: 'General',
      rating: 4.6,
      reviews: 2030,
      experienceYears: 7,
      patients: 4100,
      address: 'Downtown Medical',
      about:
          'General practice doctor offering checkups, sick visits and '
          'guidance on healthy lifestyle changes.',
      fee: 28,
      availableDays: ['Mon', 'Tue', 'Thu', 'Fri'],
      timeSlots: _lateSlots,
    ),
    Doctor(
      id: 'doc-010',
      name: 'Dr. Sophia Turner',
      specialty: 'Gynecology',
      rating: 4.9,
      reviews: 2880,
      experienceYears: 16,
      patients: 9600,
      address: "Women's Health Center",
      about:
          'Provides compassionate care for reproductive health, pregnancy '
          'planning and routine screenings.',
      fee: 48,
      availableDays: ['Mon', 'Wed', 'Fri'],
      timeSlots: _morningSlots,
    ),
  ];

  @override
  List<Doctor> getDoctors() => List.unmodifiable(_doctors);

  @override
  List<Specialty> getSpecialties() => List.unmodifiable(_specialties);

  @override
  List<Doctor> search({String? specialty, String query = ''}) {
    final normalizedQuery = query.trim().toLowerCase();
    final hasSpecialty = specialty != null && specialty != 'All';

    return _doctors.where((doctor) {
      final matchesSpecialty =
          !hasSpecialty || doctor.specialty == specialty;
      if (!matchesSpecialty) return false;
      if (normalizedQuery.isEmpty) return true;

      return doctor.name.toLowerCase().contains(normalizedQuery) ||
          doctor.specialty.toLowerCase().contains(normalizedQuery) ||
          doctor.address.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
