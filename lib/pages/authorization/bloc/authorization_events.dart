abstract class AuthorizationEvents {
  const AuthorizationEvents();
}

class EmailEvent extends AuthorizationEvents {
  final String email;
  const EmailEvent({required this.email});
}

class PasswordEvent extends AuthorizationEvents {
  final String password;
  const PasswordEvent({required this.password});
}
