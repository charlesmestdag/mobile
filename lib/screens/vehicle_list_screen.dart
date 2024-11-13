import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehicle.dart';
import 'vehicle_menu_screen.dart';
import 'add_vehicle_screen.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Véhicules'),
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state.vehicles.isEmpty) {
            return const Center(
              child: Text('Aucun véhicule ajouté.'),
            );
          }

          return ListView.builder(
            itemCount: state.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = state.vehicles[index];
              return ListTile(
                title: Text('${vehicle.marque} ${vehicle.modele}'),
                subtitle: Text('Année : ${vehicle.annee}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VehicleMenuScreen(vehicle: vehicle),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddVehicleScreen(), // Retirez le mot-clé const ici
            ),
          );
        },
        tooltip: 'Ajouter un véhicule',
        child: const Icon(Icons.add),
      ),
    );
  }
}
