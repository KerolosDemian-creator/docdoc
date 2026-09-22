import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_up_request_body.g.dart';

@JsonSerializable()
class SignUpRequestBody {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String password;
  final String passwordConfirmation;

  SignUpRequestBody({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.password,
    @JsonKey(name: 'password_confirmation') required this.passwordConfirmation,
  });
  Map<String, dynamic> toJson() => _$SignUpRequestBodyToJson(this);
}
