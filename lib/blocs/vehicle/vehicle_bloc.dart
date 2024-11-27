import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/vehicle.dart';
import '../../models/expense.dart';
import '../../models/planning.dart';
import '../../repositories/vehicle_repository.dart';
import '../../services/notification_service.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<AddExpense>(_onAddExpense);
    on<AddPlanning>(_onAddPlanning);
    on<RemovePlanning>(_onRemovePlanning);
  }

  Future<void> _onLoadVehicles(
      LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final vehicles = await vehicleRepository.getVehicles();
      final expenses = await vehicleRepository.getAllExpenses();
      final plannings = await vehicleRepository.getAllPlannings();

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

  Future<void> _onAddVehicle(
      AddVehicle event, Emitter<VehicleState> emit) async {
    if (event.vehicle.marque.isEmpty || event.vehicle.modele.isEmpty) {
      emit(VehicleError(error: "Les champs du véhicule sont obligatoires."));
      return;
    }
    try {
      await vehicleRepository.addVehicle(event.vehicle);
      add(LoadVehicles());
    } catch (e) {
      print("Erreur lors de l'ajout du véhicule : $e");
      emit(VehicleError(error: "Impossible d'ajouter le véhicule."));
    }
  }

  Future<void> _onUpdateVehicle(
      UpdateVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleRepository.updateVehicle(event.vehicle);
      add(LoadVehicles());
    } catch (e) {
      print("Erreur lors de la mise à jour du véhicule : $e");
      emit(VehicleError(error: "Impossible de mettre à jour le véhicule."));
    }
  }

  Future<void> _onAddExpense(
      AddExpense event, Emitter<VehicleState> emit) async {
    try {
      await vehicleRepository.addExpense(event.expense);
      add(LoadVehicles());
    } catch (e) {
      print("Erreur lors de l'ajout de la dépense : $e");
      emit(VehicleError(error: "Impossible d'ajouter la dépense."));
    }
  }

  Future<void> _onAddPlanning(
      AddPlanning event, Emitter<VehicleState> emit) async {
    try {
      await vehicleRepository.addPlanning(event.planning);

      if (event.planning.sendNotification) {
        NotificationService().scheduleNotification(
          event.planning.hashCode,
          'Rappel de planification',
          'La planification pour ${event.planning.type} est prévue pour le ${event.planning.date}.',
          event.planning.date,
        );
      }

      add(LoadVehicles());
    } catch (e) {
      print("Erreur lors de l'ajout de la planification : $e");
      emit(VehicleError(error: "Impossible d'ajouter la planification."));
    }
  }

  Future<void> _onRemovePlanning(
      RemovePlanning event, Emitter<VehicleState> emit) async {
    try {
      await vehicleRepository.removePlanning(event.vehicleId, event.planningId);

      NotificationService().cancelNotification(event.planningId.hashCode);

      add(LoadVehicles());
    } catch (e) {
      print("Erreur lors de la suppression de la planification : $e");
      emit(VehicleError(error: "Impossible de supprimer la planification."));
    }
  }
}
