import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/data/model/specialty.dart';
import 'package:docdoc/features/home/data/repo/doctor_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeState());

  final DoctorRepository _repository;

  void load() {
    emit(
      HomeState(
        isLoading: false,
        doctors: _repository.search(
          specialty: state.selectedSpecialty,
          query: state.query,
        ),
        specialties: _repository.getSpecialties(),
        selectedSpecialty: state.selectedSpecialty,
        query: state.query,
      ),
    );
  }

  void selectSpecialty(String specialty) {
    emit(
      state.copyWith(
        selectedSpecialty: specialty,
        doctors: _repository.search(
          specialty: specialty,
          query: state.query,
        ),
      ),
    );
  }

  void search(String query) {
    emit(
      state.copyWith(
        query: query,
        doctors: _repository.search(
          specialty: state.selectedSpecialty,
          query: query,
        ),
      ),
    );
  }

  void clearFilters() {
    emit(
      state.copyWith(
        selectedSpecialty: 'All',
        query: '',
        doctors: _repository.search(),
      ),
    );
  }
}
