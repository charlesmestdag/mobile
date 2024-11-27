
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';
import '../models/expense.dart';
import '../models/planning.dart';

class VehicleRepository {
  final CollectionReference _vehiclesCollection =
  FirebaseFirestore.instance.collection('vehicles');

  // Ajouter un véhicule
  Future<void> addVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.add(vehicle.toMap());
  }

  // Mettre à jour un véhicule
  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toMap());
  }

  // Récupérer tous les véhicules
  Future<List<Vehicle>> getVehicles() async {
    final snapshot = await _vehiclesCollection.get();
    return snapshot.docs.map((doc) {
      return Vehicle.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();
  }

  // Ajouter une dépense
  Future<void> addExpense(Expense expense) async {
    final expensesCollection = _vehiclesCollection
        .doc(expense.vehicleId)
        .collection('expenses');
    await expensesCollection.add(expense.toMap());
  }

  // Ajouter un planning
  Future<void> addPlanning(Planning planning) async {
    final planningsCollection = _vehiclesCollection
        .doc(planning.vehicleId)
        .collection('plannings');
    await planningsCollection.add(planning.toMap());
  }

  // Supprimer un planning
  Future<void> removePlanning(String vehicleId, String planningId) async {
    final planningsCollection = _vehiclesCollection
        .doc(vehicleId)
        .collection('plannings');
    await planningsCollection.doc(planningId).delete();
  }

    Future<Map<String, List<Planning>>> getAllPlannings() async {
      final Map<String, List<Planning>> plannings = {};

      final vehiclesSnapshot = await _vehiclesCollection.get();
      for (var vehicleDoc in vehiclesSnapshot.docs) {
        final planningsCollection = vehicleDoc.reference.collection('plannings');
        final planningsSnapshot = await planningsCollection.get();
        plannings[vehicleDoc.id] = planningsSnapshot.docs.map((doc) {
          return Planning.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      }

      return plannings;
    }

  Future<Map<String, List<Expense>>> getAllExpenses() async {
    final Map<String, List<Expense>> expenses = {};

    final vehiclesSnapshot = await _vehiclesCollection.get();
    for (var vehicleDoc in vehiclesSnapshot.docs) {
      final expensesCollection = vehicleDoc.reference.collection('expenses');
      final expensesSnapshot = await expensesCollection.get();
      expenses[vehicleDoc.id] = expensesSnapshot.docs.map((doc) {
        return Expense.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    }

    return expenses;
  }


// Autres méthodes pour récupérer les dépenses et les plannings si nécessaire
}
