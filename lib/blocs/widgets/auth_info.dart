import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class auth_info extends StatelessWidget {
  const auth_info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        CircleAvatar(
          child: Text(
            user?.displayName?.substring(0, 1).toUpperCase() ?? '?',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user?.displayName ?? 'Utilisateur anonyme',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? 'Email non disponible',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
