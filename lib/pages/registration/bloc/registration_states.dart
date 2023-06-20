class RegistrationStates {
  final String? name;
  final String? email;
  final String? password;
  final String? rePassword;

  const RegistrationStates({
    this.name = "",
    this.email = "",
    this.password = "",
    this.rePassword = "",
  });

  RegistrationStates copyWith(
      {String? name, String? email, String? password, String? rePassword}) {
    return RegistrationStates(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      rePassword: rePassword ?? this.rePassword,
    );
  }

  RegistrationStates reset() {
    return const RegistrationStates(
      name: null,
      email: null,
      password: null,
      rePassword: null,
    );
  }
}
