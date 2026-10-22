import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/sign_up/data/model/sign_up_request_body.dart';
import 'package:docdoc/features/sign_up/data/repo/sign_up_repo.dart';
import 'package:docdoc/features/sign_up/logic/sign_up_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSignUpRepo implements SignUpRepo {
  _FakeSignUpRepo(this.result);

  final Either<ErrorHandler, LocalUser> result;

  @override
  Future<Either<ErrorHandler, LocalUser>> signUp(
    SignUpRequestBody signUpRequestBody,
  ) async {
    return result;
  }
}

void main() {
  final request = SignUpRequestBody(
    name: 'Mona Ali',
    email: 'mona@example.com',
    phone: '01012345678',
    gender: 'Female',
    password: 'Strong1!',
    passwordConfirmation: 'Strong1!',
  );

  test('emits loading then success', () async {
    final cubit = SignUpCubit(
      _FakeSignUpRepo(
        right(const LocalUser(name: 'Mona Ali', email: 'mona@example.com')),
      ),
    );

    final future = cubit.emitSignUpState(request);
    expect(cubit.state, const SignUpState.loading());

    await future;

    expect(cubit.state, isA<Success>());
    expect((cubit.state as Success).user.email, 'mona@example.com');
  });

  test('emits the repository error message', () async {
    final cubit = SignUpCubit(
      _FakeSignUpRepo(
        left(
          ErrorHandler.local(
            'An account with this email already exists. Please sign in instead.',
          ),
        ),
      ),
    );

    await cubit.emitSignUpState(request);

    expect(cubit.state, isA<Failure>());
    expect(
      (cubit.state as Failure).errMessage,
      contains('already exists'),
    );
  });
}
