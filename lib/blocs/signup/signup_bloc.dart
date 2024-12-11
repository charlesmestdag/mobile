// lib/blocs/signup/signup_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<SignupButtonPressed>(_onSignupButtonPressed);
  }

  Future<void> _onSignupButtonPressed(SignupButtonPressed event,
      Emitter<SignupState> emit) async {
    emit(SignupLoading());

    // Vérifie que les mots de passe correspondent
    if (event.password != event.confirmPassword) {
      emit(SignupFailure(error: 'Les mots de passe ne correspondent pas.'));
      return;
    }

    // Vérifie la force du mot de passe
    if (!_isPasswordStrong(event.password)) {
      emit(SignupFailure(
          error: 'Le mot de passe doit contenir au moins 8 caractères, une lettre majuscule, une lettre minuscule et un chiffre.'));
      return;
    }

    try {
      await authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(error: e.toString()));
    }
  }

// Fonction pour vérifier la force du mot de passe
  bool _isPasswordStrong(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(password);
  }
}