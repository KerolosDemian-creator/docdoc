import 'package:dio/dio.dart';
import 'package:docdoc/core/networking/api_constants.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/model/login_response.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_response.dart';
import 'package:retrofit/retrofit.dart';
part 'api_service.g.dart';

@RestApi(baseUrl: ApiEndPoints.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiEndPoints.login)
  Future<LoginResponse> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiEndPoints.signUp)
  Future<SignUpResponse> signUp(@Body() SignUpRequestBody signUpRequestBody);
}
