// lib/blocs/vehicle/vehicle_event.dart

import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';
import '../../models/expense.dart';
import '../../models/planning.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehicles extends VehicleEvent {}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  const AddVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class UpdateVehicle extends VehicleEvent {
  final Vehicle vehicle;
  const UpdateVehicle(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

class AddExpense extends VehicleEvent {
  final Expense expense;
  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class AddPlanning extends VehicleEvent {
  final Planning planning;
  const AddPlanning(this.planning);

  @override
  List<Object?> get props => [planning];
}

class RemovePlanning extends VehicleEvent {
  final String planningId;
  final String vehicleId;
  const RemovePlanning({required this.planningId, required this.vehicleId});

  @override
  List<Object?> get props => [planningId, vehicleId];
}