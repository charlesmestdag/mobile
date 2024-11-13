import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/planning.dart';
import '../models/vehicle.dart';
import 'add_planning_screen.dart';

class VehiclePlanningScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehiclePlanningScreen({Key? key, required this.vehicle})
      : super(key: key);

  void _removePlanning(BuildContext context, String planningId) {
    context.read<VehicleBloc>().add(RemovePlanning(
      planningId: planningId,
      vehicleId: vehicle.id,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planification pour ${vehicle.marque} ${vehicle.modele}'),
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          final plannings = state.plannings[vehicle.id] ?? [];

          if (plannings.isEmpty) {
            return const Center(child: Text('Aucune planification ajoutée.'));
          }

          return ListView.builder(
            itemCount: plannings.length,
            itemBuilder: (context, index) {
              final planning = plannings[index];
              return Card(
                child: ListTile(
                  title: Text(planning.type),
                  subtitle: Text(
                      'Date : ${planning.date.toLocal().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      planning.sendNotification
                          ? const Icon(Icons.notifications_active, color: Colors.blue)
                          : const Icon(Icons.notifications_off, color: Colors.grey),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePlanning(context, planning.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VehicleBloc>(),
                child: AddPlanningScreen(vehicle: vehicle),
              ),
            ),
          );
        },
        tooltip: 'Ajouter une planification',
        child: const Icon(Icons.add),
      ),
    );
  }
}