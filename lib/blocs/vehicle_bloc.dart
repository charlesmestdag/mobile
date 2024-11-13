// vehicle_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle.dart';
import '../models/expense.dart';
import '../models/planning.dart';
import '../services/notification_service.dart';

// Événements
abstract class VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);
}

class UpdateVehicle extends VehicleEvent {
  final Vehicle vehicle;
  UpdateVehicle(this.vehicle);
}

class AddExpense extends VehicleEvent {
  final Expense expense;
  AddExpense(this.expense);
}

class AddPlanning extends VehicleEvent {
  final Planning planning;
  AddPlanning(this.planning);
}

class RemovePlanning extends VehicleEvent {
  final String planningId;
  final String vehicleId;
  RemovePlanning({required this.planningId, required this.vehicleId});
}

// État
class VehicleState {
  final List<Vehicle> vehicles;
  final Map<String, List<Expense>> expenses;
  final Map<String, List<Planning>> plannings;

  VehicleState({
    required this.vehicles,
    required this.expenses,
    required this.plannings,
  });

  VehicleState copyWith({
    List<Vehicle>? vehicles,
    Map<String, List<Expense>>? expenses,
    Map<String, List<Planning>>? plannings,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      expenses: expenses ?? this.expenses,
      plannings: plannings ?? this.plannings,
    );
  }
}

// Bloc
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc()
      : super(VehicleState(vehicles: [], expenses: {}, plannings: {})) {
    on<AddVehicle>((event, emit) {
      final updatedVehicles = List<Vehicle>.from(state.vehicles)..add(event.vehicle);
      emit(state.copyWith(vehicles: updatedVehicles));
    });

    on<UpdateVehicle>((event, emit) {
      final updatedVehicles = state.vehicles.map((vehicle) {
        return vehicle.id == event.vehicle.id ? event.vehicle : vehicle;
      }).toList();
      emit(state.copyWith(vehicles: updatedVehicles));
    });

    on<AddExpense>((event, emit) {
      final updatedExpenses = Map<String, List<Expense>>.from(state.expenses);
      updatedExpenses[event.expense.vehicleId] = List.from(
        updatedExpenses[event.expense.vehicleId] ?? [],
      )..add(event.expense);
      emit(state.copyWith(expenses: updatedExpenses));
    });

    on<AddPlanning>((event, emit) {
      final updatedPlannings = Map<String, List<Planning>>.from(state.plannings);
      updatedPlannings[event.planning.vehicleId] = List.from(
        updatedPlannings[event.planning.vehicleId] ?? [],
      )..add(event.planning);
      emit(state.copyWith(plannings: updatedPlannings));

      // Programmer une notification si nécessaire
      if (event.planning.sendNotification) {
        NotificationService().scheduleNotification(
          event.planning.hashCode, // Utiliser un identifiant unique basé sur le hash
          'Rappel de planification',
          'La planification pour ${event.planning.type} est prévue pour aujourd\'hui.',
          event.planning.date,
        );
      }
    });

    on<RemovePlanning>((event, emit) {
      final updatedPlannings = Map<String, List<Planning>>.from(state.plannings);
      updatedPlannings[event.vehicleId] = List.from(
        updatedPlannings[event.vehicleId] ?? [],
      )..removeWhere((planning) {
        if (planning.id == event.planningId) {
          // Annuler la notification si elle a été programmée
          NotificationService().cancelNotification(planning.hashCode);
          return true;
        }
        return false;
      });

      emit(state.copyWith(plannings: updatedPlannings));
    });

    // Nettoyer les plannings expirés au démarrage
    removeExpiredPlannings();
  }

  void removeExpiredPlannings() {
    final today = DateTime.now();
    final updatedPlannings = <String, List<Planning>>{};

    state.plannings.forEach((vehicleId, planningList) {
      final validPlannings = planningList.where((planning) {
        final isValid = planning.date.isAfter(today);
        if (!isValid) {
          // Annuler la notification pour les plannings expirés
          NotificationService().cancelNotification(planning.hashCode);
        }
        return isValid;
      }).toList();

      if (validPlannings.isNotEmpty) {
        updatedPlannings[vehicleId] = validPlannings;
      }
    });

    emit(state.copyWith(plannings: updatedPlannings));
  }
}
