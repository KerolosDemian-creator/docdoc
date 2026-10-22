import 'package:docdoc/features/home/data/repo/mock_doctor_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repository = MockDoctorRepository();

  test('exposes the local doctor catalogue', () {
    final doctors = repository.getDoctors();
    final specialties = repository.getSpecialties();

    expect(doctors, hasLength(10));
    expect(specialties, hasLength(9));
    expect(doctors.map((doctor) => doctor.id).toSet(), hasLength(10));
  });

  test('filters doctors by specialty', () {
    final cardiologists = repository.search(specialty: 'Cardiology');

    expect(cardiologists, hasLength(1));
    expect(cardiologists.single.name, 'Dr. Sarah Mitchell');
  });

  test('filters by search text regardless of case', () {
    final results = repository.search(query: 'SARAH');

    expect(results, hasLength(1));
    expect(results.single.specialty, 'Cardiology');
  });

  test('search matches specialty and address too', () {
    final bySpecialty = repository.search(query: 'pediatrics');
    final byAddress = repository.search(query: 'heart');

    expect(bySpecialty.single.name, 'Dr. Aisha Rahman');
    expect(byAddress.single.name, 'Dr. Sarah Mitchell');
  });

  test('returns everything for the All filter', () {
    expect(repository.search(specialty: 'All'), hasLength(10));
  });
}
