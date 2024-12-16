// lib/repositories/vehicle_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/expense.dart';
import '../models/planning.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un véhicule
  Future<void> addVehicle(Vehicle vehicle) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userVehiclesCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles');

      await userVehiclesCollection.add(vehicle.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Mettre à jour un véhicule
  Future<void> updateVehicle(Vehicle vehicle) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userVehicleDoc = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicle.id);

      await userVehicleDoc.update(vehicle.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Récupérer les véhicules par utilisateur
  Future<List<Vehicle>> getVehicles() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userVehiclesCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles');

      final snapshot = await userVehiclesCollection.get();

      return snapshot.docs.map((doc) {
        return Vehicle.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Ajouter une dépense
  Future<void> addExpense(Expense expense) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final expensesCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(expense.vehicleId)
          .collection('expenses');

      await expensesCollection.add(expense.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Récupérer les dépenses d'un véhicule
  Future<List<Expense>> getExpenses(String vehicleId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final expensesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .collection('expenses')
          .orderBy('date', descending: true)
          .get();

      return expensesSnapshot.docs.map((doc) {
        return Expense.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Ajouter un planning
  Future<void> addPlanning(Planning planning) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final planningsCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(planning.vehicleId)
          .collection('plannings');

      await planningsCollection.add(planning.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Récupérer les plannings d'un véhicule
  Future<List<Planning>> getPlannings(String vehicleId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final planningsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .collection('plannings')
          .orderBy('date', descending: true)
          .get();

      return planningsSnapshot.docs.map((doc) {
        return Planning.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Supprimer un planning
  Future<void> removePlanning(String vehicleId, String planningId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final planningsCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(vehicleId)
          .collection('plannings');

      await planningsCollection.doc(planningId).delete();
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  // Récupérer tous les plannings de tous les véhicules
  Future<Map<String, List<Planning>>> getAllPlannings() async {
    final Map<String, List<Planning>> plannings = {};
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final vehiclesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .get();

      for (var vehicleDoc in vehiclesSnapshot.docs) {
        final planningsSnapshot = await vehicleDoc.reference
            .collection('plannings')
            .orderBy('date', descending: true)
            .get();

        plannings[vehicleDoc.id] = planningsSnapshot.docs.map((doc) {
          return Planning.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      }
    } else {
      throw Exception('Utilisateur non connecté.');
    }

    return plannings;
  }

  // Récupérer tous les plannings globaux de l'utilisateur (si nécessaire)
  Future<List<Planning>> getAllUserPlannings() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userPlanningsCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('plannings');

      final snapshot = await userPlanningsCollection.get();

      return snapshot.docs.map((doc) {
        return Planning.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }

  Future<void> updateExpense(Expense expense) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final expenseDoc = _firestore
          .collection('users')
          .doc(userId)
          .collection('vehicles')
          .doc(expense.vehicleId)
          .collection('expenses')
          .doc(expense.id);

      await expenseDoc.update(expense.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }


// Autres méthodes si nécessaire
}
