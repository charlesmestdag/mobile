// lib/screens/vehicle_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../models/vehicle.dart';
import 'vehicle_menu_screen.dart';
import 'add_vehicle_screen.dart';
import '../repositories/auth_repository.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) async {
    await RepositoryProvider.of<AuthRepository>(context).logOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Charger les véhicules au chargement de l'écran
    context.read<VehicleBloc>().add(LoadVehicles());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Véhicules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleLoaded) {
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
          } else if (state is VehicleError) {
            return Center(
              child: Text('Erreur : ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('Aucun véhicule ajouté.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddVehicleScreen(),
            ),
          );
        },
        tooltip: 'Ajouter un véhicule',
        child: const Icon(Icons.add),
      ),
    );
  }
}
