// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../blocs/signup/signup_bloc.dart'; // Import du SignupBloc
import 'signup_screen.dart';
import 'vehicle_list_screen.dart';
import '../repositories/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onLoginButtonPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<LoginBloc>().add(
      LoginButtonPressed(email: email, password: password),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BlocProvider<SignupBloc>(
            create: (context) => SignupBloc(
              authRepository: context.read<AuthRepository>(),
            ),
            child: const SignupScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur : ${state.error}')),
            );
          } else if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const VehicleListScreen(),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration:
                    const InputDecoration(labelText: 'Adresse e-mail'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration:
                    const InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onLoginButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Se connecter'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _navigateToSignup,
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
