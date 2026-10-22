import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:docdoc/core/auth/auth_exception.dart';
import 'package:docdoc/core/auth/local_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores demo accounts, the active session and onboarding state locally.
///
/// Passwords are hashed before being written to [SharedPreferences]. This is
/// still a demo-only solution: a real app must verify credentials on a server.
class AuthStorage {
  AuthStorage(this._preferences);

  final SharedPreferences _preferences;

  static const _accountsKey = 'docdoc_accounts_v1';
  static const _sessionKey = 'docdoc_session_v1';
  static const _onboardingKey = 'docdoc_onboarding_seen_v1';
  static const _salt = 'docdoc-offline-demo-v1';

  bool get hasSeenOnboarding =>
      _preferences.getBool(_onboardingKey) ?? false;

  Future<void> markOnboardingSeen() async {
    await _preferences.setBool(_onboardingKey, true);
  }

  LocalUser? get currentUser {
    final raw = _preferences.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final user = LocalUser.fromJson(decoded);
        if (user.email.isNotEmpty) return user;
      }
    } on FormatException {
      // Corrupt data - treat the user as signed out.
    }
    return null;
  }

  bool get isLoggedIn => currentUser != null;

  Future<LocalUser> register({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = _readAccounts();

    if (accounts.containsKey(normalizedEmail)) {
      throw const AuthException(
        'An account with this email already exists. Please sign in instead.',
      );
    }

    final account = _StoredAccount(
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      gender: gender,
      passwordHash: _hashPassword(normalizedEmail, password),
    );

    accounts[normalizedEmail] = account;
    await _writeAccounts(accounts);

    final user = LocalUser(name: account.name, email: account.email);
    await _startSession(user);
    return user;
  }

  Future<LocalUser> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final account = _readAccounts()[normalizedEmail];

    if (account == null ||
        account.passwordHash != _hashPassword(normalizedEmail, password)) {
      throw const AuthException('Incorrect email or password.');
    }

    final user = LocalUser(name: account.name, email: account.email);
    await _startSession(user);
    return user;
  }

  Future<void> logout() async {
    await _preferences.remove(_sessionKey);
  }

  Future<LocalUser> updateName(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.length < 2) {
      throw const AuthException('Please enter a valid name.');
    }

    final user = currentUser;
    if (user == null) {
      throw const AuthException('Your session has expired. Please sign in.');
    }

    final accounts = _readAccounts();
    final account = accounts[user.email];
    if (account != null) {
      accounts[user.email] = account.copyWith(name: trimmedName);
      await _writeAccounts(accounts);
    }

    final updatedUser = user.copyWith(name: trimmedName);
    await _startSession(updatedUser);
    return updatedUser;
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final accounts = _readAccounts();
    final account = accounts[normalizedEmail];

    if (account == null) {
      throw const AuthException('No account was found for that email.');
    }

    accounts[normalizedEmail] = account.copyWith(
      passwordHash: _hashPassword(normalizedEmail, newPassword),
    );
    await _writeAccounts(accounts);
  }

  Future<void> _startSession(LocalUser user) async {
    await _preferences.setString(_sessionKey, jsonEncode(user.toJson()));
  }

  Map<String, _StoredAccount> _readAccounts() {
    final raw = _preferences.getString(_accountsKey);
    if (raw == null || raw.isEmpty) return {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return {};

      return decoded.map((email, value) {
        return MapEntry(
          email,
          _StoredAccount.fromJson(Map<String, dynamic>.from(value as Map)),
        );
      });
    } on Object {
      return {};
    }
  }

  Future<void> _writeAccounts(Map<String, _StoredAccount> accounts) async {
    final encoded = accounts.map(
      (email, account) => MapEntry(email, account.toJson()),
    );
    await _preferences.setString(_accountsKey, jsonEncode(encoded));
  }

  String _hashPassword(String email, String password) {
    return sha256.convert(utf8.encode('$email|$password|$_salt')).toString();
  }
}

class _StoredAccount {
  const _StoredAccount({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.passwordHash,
  });

  final String name;
  final String email;
  final String phone;
  final String gender;
  final String passwordHash;

  factory _StoredAccount.fromJson(Map<String, dynamic> json) {
    return _StoredAccount(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      passwordHash: json['passwordHash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
    'passwordHash': passwordHash,
  };

  _StoredAccount copyWith({String? name, String? passwordHash}) {
    return _StoredAccount(
      name: name ?? this.name,
      email: email,
      phone: phone,
      gender: gender,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }
}
