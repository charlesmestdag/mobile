// lib/blocs/vehicle/vehicle_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';
import '../../models/expense.dart';
import '../../models/planning.dart';
import '../../repositories/vehicle_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleLoading()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle); // Enregistrement du gestionnaire
    on<AddExpense>(_onAddExpense);
    on<AddPlanning>(_onAddPlanning);
    on<RemovePlanning>(_onRemovePlanning);
    on<LoadPlannings>(_onLoadPlannings);
    on<UpdateExpense>(_onUpdateExpense);

    // Ajoutez d'autres gestionnaires d'événements si nécessaire
  }

  // **Gestionnaire pour ajouter un véhicule**
  Future<void> _onAddVehicle(
      AddVehicle event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.addVehicle(event.vehicle);
        print("Véhicule ajouté avec succès : ${event.vehicle.marque} ${event.vehicle.modele}");
        // Recharger les véhicules après ajout
        add(LoadVehicles());
      } catch (e) {
        print("Erreur lors de l'ajout du véhicule : $e");
        emit(VehicleError(error: "Erreur lors de l'ajout du véhicule."));
      }
    }
  }
  // **Gestionnaire pour mettre à jour un véhicule**
  Future<void> _onUpdateVehicle(
      UpdateVehicle event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.updateVehicle(event.vehicle);
        print("Véhicule mis à jour avec succès : ${event.vehicle.marque} ${event.vehicle.modele}");
        // Recharger les véhicules après mise à jour
        add(LoadVehicles());
      } catch (e) {
        print("Erreur lors de la mise à jour du véhicule : $e");
        emit(VehicleError(error: "Erreur lors de la mise à jour du véhicule."));
      }
    }
  }

  Future<void> _onLoadVehicles(
      LoadVehicles event, Emitter<VehicleState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      emit(VehicleError(error: "Vous devez être connecté pour charger les véhicules."));
      return;
    }

    emit(VehicleLoading());

    try {
      final vehicles = await vehicleRepository.getVehicles();
      print("Véhicules chargés: ${vehicles.length}");

      // Initialiser la carte des dépenses et plannings
      Map<String, List<Expense>> expenses = {};
      Map<String, List<Planning>> plannings = {};

      // Récupérer les dépenses et plannings pour chaque véhicule
      for (var vehicle in vehicles) {
        final vehicleExpenses = await vehicleRepository.getExpenses(vehicle.id!);
        expenses[vehicle.id!] = vehicleExpenses;
        print("Véhicule ID: ${vehicle.id}, Nombre de dépenses: ${vehicleExpenses.length}");

        final vehiclePlannings = await vehicleRepository.getPlannings(vehicle.id!);
        plannings[vehicle.id!] = vehiclePlannings;
        print("Véhicule ID: ${vehicle.id}, Nombre de plannings: ${vehiclePlannings.length}");
      }

      emit(VehicleLoaded(
        vehicles: vehicles,
        expenses: expenses,
        plannings: plannings,
      ));
    } catch (e, stacktrace) {
      print("Erreur lors du chargement des véhicules : $e");
      print(stacktrace);
      emit(VehicleError(error: "Impossible de charger les véhicules."));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.addExpense(event.expense);
        // Recharger les véhicules et dépenses après ajout
        add(LoadVehicles());
      } catch (e) {
        emit(VehicleError(error: "Erreur lors de l'ajout de la dépense."));
      }
    }
  }

  Future<void> _onAddPlanning(
      AddPlanning event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.addPlanning(event.planning);
        // Recharger les plannings après ajout
        add(LoadVehicles());
      } catch (e) {
        emit(VehicleError(error: "Erreur lors de l'ajout du planning."));
      }
    }
  }

  Future<void> _onRemovePlanning(
      RemovePlanning event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.removePlanning(event.vehicleId, event.planningId);
        // Recharger les plannings après suppression
        add(LoadVehicles());
      } catch (e) {
        emit(VehicleError(error: "Erreur lors de la suppression du planning."));
      }
    }
  }



  Future<void> _onLoadPlannings(
      LoadPlannings event, Emitter<VehicleState> emit) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      emit(VehicleError(error: "Vous devez être connecté pour charger les plannings."));
      return;
    }

    try {
      final plannings = await vehicleRepository.getPlannings(event.vehicleId);
      if (state is VehicleLoaded) {
        final currentState = state as VehicleLoaded;
        final updatedPlannings = Map<String, List<Planning>>.from(currentState.plannings);
        updatedPlannings[event.vehicleId] = plannings;

        emit(VehicleLoaded(
          vehicles: currentState.vehicles,
          expenses: currentState.expenses,
          plannings: updatedPlannings,
        ));
      }
    } catch (e) {
      emit(VehicleError(error: "Impossible de charger les plannings."));
    }
  }

  Future<void> _onUpdateExpense(UpdateExpense event, Emitter<VehicleState> emit) async {
    if (state is VehicleLoaded) {
      try {
        await vehicleRepository.updateExpense(event.expense);
        add(LoadVehicles());
      } catch (e) {
        emit(VehicleError(error: "Erreur lors de la mise à jour de la dépense."));
      }
    }
  }

}


