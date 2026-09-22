import 'package:docdoc/features/login/data/model/login_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sign_up_response.g.dart';

@JsonSerializable()
class SignUpResponse {
  final String? message;
  @JsonKey(name: 'data')
  final UserData userData;
  final bool? status;
  final int? code;

  SignUpResponse({
    required this.message,
    required this.status,
    required this.code,
    required this.userData,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);
}
