import 'package:docdoc/features/home/data/repo/mock_doctor_repository.dart';
import 'package:docdoc/features/home/logic/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeCubit cubit;

  setUp(() {
    cubit = HomeCubit(const MockDoctorRepository());
  });

  tearDown(() => cubit.close());

  test('loads all doctors and specialties', () {
    cubit.load();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.doctors, hasLength(10));
    expect(cubit.state.specialties, hasLength(9));
    expect(cubit.state.selectedSpecialty, 'All');
  });

  test('filters by specialty', () {
    cubit.load();
    cubit.selectSpecialty('Neurology');

    expect(cubit.state.doctors, hasLength(1));
    expect(cubit.state.doctors.single.specialty, 'Neurology');
  });

  test('combines search text and specialty', () {
    cubit.load();
    cubit.selectSpecialty('General');
    cubit.search('randy');

    expect(cubit.state.doctors, hasLength(1));
    expect(cubit.state.doctors.single.name, 'Dr. Randy Wigham');

    cubit.search('sarah');
    expect(cubit.state.doctors, isEmpty);
  });

  test('clearFilters resets the state', () {
    cubit.load();
    cubit.selectSpecialty('Cardiology');
    cubit.search('sarah');

    cubit.clearFilters();

    expect(cubit.state.selectedSpecialty, 'All');
    expect(cubit.state.query, isEmpty);
    expect(cubit.state.doctors, hasLength(10));
  });
}
