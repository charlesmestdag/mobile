// lib/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // Connexion avec email et mot de passe
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erreur de connexion : ${e.toString()}');
    }
  }

  // Création d'un compte avec email et mot de passe
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erreur lors de la création du compte : ${e.toString()}');
    }
  }

  // Déconnexion
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  // Stream pour suivre l'état de l'utilisateur
  Stream<User?> get user => _firebaseAuth.authStateChanges();
}
