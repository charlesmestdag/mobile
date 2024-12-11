import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/expense.dart';
import '../models/planning.dart';

class VehicleRepository {
  final CollectionReference _vehiclesCollection =
  FirebaseFirestore.instance.collection('vehicles');


  // Ajouter un véhicule
  Future<void> addVehicle(Vehicle vehicle) async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final userVehiclesCollection = FirebaseFirestore.instance
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
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toMap());
  }

  // Récupérer les véhicules par utilisateur
  Future<List<Vehicle>> getVehicles() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final userVehiclesCollection = FirebaseFirestore.instance
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
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final expensesCollection = _vehiclesCollection
          .doc(expense.vehicleId)
          .collection('expenses');
      await expensesCollection.add({
        ...expense.toMap(),
        'userId': userId, // Associer la dépense à l'utilisateur connecté
      });
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }


  // Ajouter un planning
  Future<void> addPlanning(Planning planning) async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final userPlanningsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plannings');

      await userPlanningsCollection.add(planning.toMap());
    } else {
      throw Exception('Utilisateur non connecté.');
    }
  }



  // Supprimer un planning
  Future<void> removePlanning(String vehicleId, String planningId) async {
    final planningsCollection = _vehiclesCollection
        .doc(vehicleId)
        .collection('plannings');
    await planningsCollection.doc(planningId).delete();
  }

  Future<List<Planning>> getAllPlannings() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final userPlanningsCollection = FirebaseFirestore.instance
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



  Future<Map<String, List<Expense>>> getAllExpenses() async {
    final Map<String, List<Expense>> expenses = {};
    final userId = FirebaseAuth.instance.currentUser?.uid; // Récupérer l'utilisateur connecté
    if (userId != null) {
      final vehiclesSnapshot = await _vehiclesCollection.where('userId', isEqualTo: userId).get(); // Filtrer par utilisateur
      for (var vehicleDoc in vehiclesSnapshot.docs) {
        final expensesCollection = vehicleDoc.reference.collection('expenses');
        final expensesSnapshot = await expensesCollection.get();
        expenses[vehicleDoc.id] = expensesSnapshot.docs.map((doc) {
          return Expense.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      }
    } else {
      throw Exception('Utilisateur non connecté.');
    }

    return expenses;
  }





// Autres méthodes pour récupérer les dépenses et les plannings si nécessaire
}
