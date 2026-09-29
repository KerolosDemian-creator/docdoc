import 'package:dartz/dartz.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_response.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';

class SignUpRepoImp implements SignUpRepo {
  final ApiService apiService;

  SignUpRepoImp(this.apiService);
  @override
  Future<Either<ErrorHandler, SignUpResponse>> signUp(
    SignUpRequestBody signUpRequestBody,
  ) async {
    try {
      final response = await apiService.signUp(signUpRequestBody);
      return right(response);
    } catch (e) {
      return left(ErrorHandler.handle(e));
    }
  }
}
