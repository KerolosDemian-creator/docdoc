part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(true) bool isLoading,
    @Default([]) List<Doctor> doctors,
    @Default([]) List<Specialty> specialties,
    @Default('All') String selectedSpecialty,
    @Default('') String query,
  }) = _HomeState;
}
