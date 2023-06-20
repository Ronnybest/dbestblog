abstract class RegistrationEvents {
  const RegistrationEvents();
}

class UserNameEvent extends RegistrationEvents {
  final String username;
  UserNameEvent({required this.username});
}

class EmailEvent extends RegistrationEvents {
  final String email;
  EmailEvent({required this.email});
}

class PasswordEvent extends RegistrationEvents {
  final String password;
  PasswordEvent({required this.password});
}

class RePasswordEvent extends RegistrationEvents {
  final String rePassword;
  RePasswordEvent({required this.rePassword});
}

class ResetRegistr extends RegistrationEvents {
  const ResetRegistr();
}
