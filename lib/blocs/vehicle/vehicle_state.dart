// lib/blocs/vehicle/vehicle_state.dart

import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';
import '../../models/expense.dart';
import '../../models/planning.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  final Map<String, List<Expense>> expenses;
  final Map<String, List<Planning>> plannings;

  const VehicleLoaded({
    required this.vehicles,
    required this.expenses,
    required this.plannings,
  });

  @override
  List<Object?> get props => [vehicles, expenses, plannings];
}

class VehicleError extends VehicleState {
  final String error;
  const VehicleError({required this.error});

  @override
  List<Object?> get props => [error];
}
