class AuthorizationStates {
  final String? email;
  final String? password;
  const AuthorizationStates({this.email = "", this.password = ""});

  AuthorizationStates copyWith({String? email, String? password}) {
    return AuthorizationStates(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  AuthorizationStates reset() {
    return const AuthorizationStates(
      email: null,
      password: null,
    );
  }
}
