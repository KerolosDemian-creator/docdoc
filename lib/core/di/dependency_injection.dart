import 'package:dio/dio.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/core/networking/dio_factory.dart';
import 'package:docdoc/features/appointments/data/repo/appointment_repository.dart';
import 'package:docdoc/features/appointments/data/repo/local_appointment_repository.dart';
import 'package:docdoc/features/appointments/logic/appointments_cubit.dart';
import 'package:docdoc/features/home/data/repo/doctor_repository.dart';
import 'package:docdoc/features/home/data/repo/mock_doctor_repository.dart';
import 'package:docdoc/features/home/logic/home_cubit.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';
import 'package:docdoc/features/login/data/repo/login_repo_imp.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo_imp.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> getItSetup() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);

  getIt.registerLazySingleton<AuthStorage>(() => AuthStorage(getIt()));

  // Kept ready for a future backend. The demo uses the local repositories.
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  getIt.registerLazySingleton<LoginRepo>(() => LoginRepoImp(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  getIt.registerLazySingleton<SignUpRepo>(() => SignUpRepoImp(getIt()));
  getIt.registerFactory<SignUpCubit>(() => SignUpCubit(getIt()));

  getIt.registerLazySingleton<DoctorRepository>(
    () => const MockDoctorRepository(),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  getIt.registerLazySingleton<AppointmentRepository>(
    () => LocalAppointmentRepository(
      getIt(),
      userKey: () => getIt<AuthStorage>().currentUser?.email ?? 'guest',
    ),
  );
  getIt.registerFactory<AppointmentsCubit>(
    () => AppointmentsCubit(getIt()),
  );
}
