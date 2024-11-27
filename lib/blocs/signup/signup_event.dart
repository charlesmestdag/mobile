// lib/blocs/signup/signup_event.dart

abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;

  SignupButtonPressed({required this.email, required this.password});
}
