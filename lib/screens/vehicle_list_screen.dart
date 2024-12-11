import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../blocs/vehicle/vehicle_event.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_menu_screen.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Charger les véhicules dès l'affichage de l'écran
    context.read<VehicleBloc>().add(LoadVehicles());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Véhicules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
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
                child: Text('Aucun véhicule trouvé. Ajoutez-en un pour commencer.'),
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
              child: Text('Une erreur inconnue est survenue.'),
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
