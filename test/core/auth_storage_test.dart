import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/auth_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences preferences;
  late AuthStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    storage = AuthStorage(preferences);
  });

  test('register creates an account and starts a session', () async {
    final user = await storage.register(
      name: 'Mona Ali',
      email: 'MONA@example.com ',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    expect(user.name, 'Mona Ali');
    expect(user.email, 'mona@example.com');
    expect(storage.isLoggedIn, isTrue);
    expect(storage.currentUser?.email, 'mona@example.com');
  });

  test('passwords are not stored in plain text', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    final rawAccounts = preferences.getString('docdoc_accounts_v1') ?? '';
    expect(rawAccounts, isNotEmpty);
    expect(rawAccounts, isNot(contains('Strong1!')));
  });

  test('duplicate emails are rejected', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    expect(
      () => storage.register(
        name: 'Other User',
        email: 'mona@example.com',
        phone: '01112345678',
        gender: 'Male',
        password: 'Another1!',
      ),
      throwsA(isA<AuthException>()),
    );
  });

  test('login accepts the right password and rejects a wrong one', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );
    await storage.logout();

    final user = await storage.login(
      email: 'mona@example.com',
      password: 'Strong1!',
    );
    expect(user.name, 'Mona Ali');
    expect(storage.isLoggedIn, isTrue);

    await storage.logout();
    expect(
      () => storage.login(
        email: 'mona@example.com',
        password: 'Wrong1!',
      ),
      throwsA(isA<AuthException>()),
    );
  });

  test('logout clears the session but keeps the account', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    await storage.logout();
    expect(storage.isLoggedIn, isFalse);

    final user = await storage.login(
      email: 'mona@example.com',
      password: 'Strong1!',
    );
    expect(user.name, 'Mona Ali');
  });

  test('updating the name persists it to the session', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );

    final updated = await storage.updateName('Mona Ahmed');
    expect(updated.name, 'Mona Ahmed');
    expect(storage.currentUser?.name, 'Mona Ahmed');
  });

  test('resetPassword changes the stored password', () async {
    await storage.register(
      name: 'Mona Ali',
      email: 'mona@example.com',
      phone: '01012345678',
      gender: 'Female',
      password: 'Strong1!',
    );
    await storage.logout();

    await storage.resetPassword(
      email: 'mona@example.com',
      newPassword: 'NewPass1!',
    );

    final user = await storage.login(
      email: 'mona@example.com',
      password: 'NewPass1!',
    );
    expect(user.email, 'mona@example.com');
  });

  test('onboarding state is persisted', () async {
    expect(storage.hasSeenOnboarding, isFalse);
    await storage.markOnboardingSeen();
    expect(storage.hasSeenOnboarding, isTrue);
  });
}
