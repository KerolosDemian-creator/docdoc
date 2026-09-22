import 'package:dio/dio.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/core/networking/dio_factory.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';
import 'package:docdoc/features/login/data/repo/login_repo_imp.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo_imp.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> getItSetup() async {
  Dio dio = DioFactory.getDio();
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepoImp(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
  getIt.registerLazySingleton<SignUpRepo>(() => SignUpRepoImp(getIt()));

  getIt.registerLazySingleton<SignUpCubit>(() => SignUpCubit(getIt()));
}
