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

  Future<void> _onSignupButtonPressed(
      SignupButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
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

  @override
  Future<void> close() {
    // Fermez les streams ou autres ressources si nécessaire
    return super.close();
  }
}
