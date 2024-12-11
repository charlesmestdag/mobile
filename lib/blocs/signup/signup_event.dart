// lib/blocs/signup/signup_event.dart

abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;
  final String confirmPassword;

  SignupButtonPressed({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}


