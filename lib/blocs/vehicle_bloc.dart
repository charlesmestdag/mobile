import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle.dart';
import '../models/expense.dart';

// Définition des événements
abstract class VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);
}

class UpdateVehicle extends VehicleEvent {
  final Vehicle updatedVehicle;
  UpdateVehicle(this.updatedVehicle);
}

class RemoveVehicle extends VehicleEvent {
  final String vehicleId;
  RemoveVehicle(this.vehicleId);
}

class AddExpense extends VehicleEvent {
  final Expense expense;
  AddExpense(this.expense);
}

// Définition de l'état
class VehicleState {
  final List<Vehicle> vehicles;
  final Map<String, List<Expense>> expenses;

  VehicleState({required this.vehicles, required this.expenses});

  VehicleState copyWith({
    List<Vehicle>? vehicles,
    Map<String, List<Expense>>? expenses,
  }) {
    return VehicleState(
      vehicles: vehicles ?? this.vehicles,
      expenses: expenses ?? this.expenses,
    );
  }
}

// Bloc pour gérer les événements et les états
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleState(vehicles: [], expenses: {})) {
    on<AddVehicle>((event, emit) {
      emit(state.copyWith(
        vehicles: List.from(state.vehicles)..add(event.vehicle),
      ));
    });

    on<UpdateVehicle>((event, emit) {
      final updatedVehicles = state.vehicles.map((vehicle) {
        return vehicle.id == event.updatedVehicle.id ? event.updatedVehicle : vehicle;
      }).toList();
      emit(state.copyWith(vehicles: updatedVehicles));
    });

    on<RemoveVehicle>((event, emit) {
      emit(state.copyWith(
        vehicles: state.vehicles.where((v) => v.id != event.vehicleId).toList(),
        expenses: Map.from(state.expenses)..remove(event.vehicleId),
      ));
    });

    on<AddExpense>((event, emit) {
      final updatedExpenses = Map<String, List<Expense>>.from(state.expenses);
      updatedExpenses[event.expense.vehicleId] = List.from(
        updatedExpenses[event.expense.vehicleId] ?? [],
      )..add(event.expense);
      emit(state.copyWith(expenses: updatedExpenses));
    });
  }
}
