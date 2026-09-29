import 'package:dartz/dartz.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/model/login_response.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';

class LoginRepoImp implements LoginRepo {
  final ApiService _apiService;

  LoginRepoImp(this._apiService);
  @override
  Future<Either<ErrorHandler, LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e.toString()));
    }
  }
}
