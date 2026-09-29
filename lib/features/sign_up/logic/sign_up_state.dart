part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.loading() = Loading;
  const factory SignUpState.failure({required String errMessage}) = Failure;
  const factory SignUpState.success(SignUpResponse user) = Success;
}
