import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_q1/blocs/widgets/auth_info.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_menu_screen.dart';
import '../widgets/auth_info.dart';
import 'edit_vehicle_screen.dart'; // Assurez-vous d'importer l'écran d'édition

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
          // Option 1 : Remplacer le bouton de déconnexion par un bouton modifier global
          /*
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditGlobalVehicleScreen(), // Créez cet écran si nécessaire
                ),
              );
            },
            tooltip: 'Modifier les véhicules',
          ),
          */

          // Option 2 : Conserver le bouton de déconnexion et ajouter un bouton modifier global
          // Vous pouvez choisir l'une des options ci-dessus selon vos besoins

          // Si vous souhaitez seulement remplacer le bouton de déconnexion, décommentez l'option 1
          // Sinon, vous pouvez conserver le bouton de déconnexion et ajouter des boutons d'édition par élément
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: const auth_info(), // Utilise ton widget AuthInfo
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur de déconnexion : $e')),
                  );
                }
              },
            ),
          ],
        ),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditVehicleScreen(vehicle: vehicle),
                        ),
                      );
                    },
                    tooltip: 'Modifier ce véhicule',
                  ),
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
