// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/signup/signup_bloc.dart';
import '../blocs/signup/signup_event.dart';
import '../blocs/signup/signup_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onSignupButtonPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<SignupBloc>().add(
      SignupButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erreur : ${state.error}')),
            );
          } else if (state is SignupSuccess) {
            Navigator.of(context).pop(); // Retour à l'écran précédent
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Compte créé avec succès')),
            );
          }
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            if (state is SignupLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                    onPressed: _onSignupButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Créer un compte'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
