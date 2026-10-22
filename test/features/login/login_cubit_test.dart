import 'package:dartz/dartz.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/features/login/data/model/login_request_body.dart';
import 'package:docdoc/features/login/data/repo/login_repo.dart';
import 'package:docdoc/features/login/logic/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLoginRepo implements LoginRepo {
  _FakeLoginRepo(this.result);

  final Either<ErrorHandler, LocalUser> result;

  @override
  Future<Either<ErrorHandler, LocalUser>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    return result;
  }
}

void main() {
  const request = LoginRequestBody(
    email: 'mona@example.com',
    password: 'Strong1!',
  );

  test('emits loading then success', () async {
    final cubit = LoginCubit(
      _FakeLoginRepo(
        right(const LocalUser(name: 'Mona Ali', email: 'mona@example.com')),
      ),
    );

    final future = cubit.emitLoginState(request);
    expect(cubit.state, const LoginState.loading());

    await future;

    expect(cubit.state, isA<Success>());
    expect((cubit.state as Success).user.name, 'Mona Ali');
  });

  test('emits a user friendly failure message', () async {
    final cubit = LoginCubit(
      _FakeLoginRepo(left(ErrorHandler.local('Incorrect email or password.'))),
    );

    await cubit.emitLoginState(request);

    expect(cubit.state, isA<Failure>());
    expect(
      (cubit.state as Failure).errMessage,
      'Incorrect email or password.',
    );
  });
}
