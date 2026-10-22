/// A lightweight user model used by the offline demo.
class LocalUser {
  const LocalUser({required this.name, required this.email});

  final String name;
  final String email;

  factory LocalUser.fromJson(Map<String, dynamic> json) {
    return LocalUser(
      name: json['name'] as String? ?? 'DocDoc User',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  LocalUser copyWith({String? name, String? email}) {
    return LocalUser(name: name ?? this.name, email: email ?? this.email);
  }
}
