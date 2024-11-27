// lib/screens/add_vehicle_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../models/vehicle.dart';

class AddVehicleScreen extends StatelessWidget {
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController modeleController = TextEditingController();
  final TextEditingController anneeController = TextEditingController();

  AddVehicleScreen({Key? key}) : super(key: key);

  void _addVehicle(BuildContext context) {
    final marque = marqueController.text;
    final modele = modeleController.text;
    final annee = int.tryParse(anneeController.text);

    if (marque.isNotEmpty && modele.isNotEmpty && annee != null) {
      final newVehicle = Vehicle(
        // Laissez l'ID vide pour que Firestore le génère
        marque: marque,
        modele: modele,
        annee: annee,
      );

      context.read<VehicleBloc>().add(AddVehicle(newVehicle));

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un véhicule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: marqueController,
              decoration: const InputDecoration(labelText: 'Marque'),
            ),
            TextField(
              controller: modeleController,
              decoration: const InputDecoration(labelText: 'Modèle'),
            ),
            TextField(
              controller: anneeController,
              decoration: const InputDecoration(labelText: 'Année'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addVehicle(context),
              child: const Text('Ajouter le véhicule'),
            ),
          ],
        ),
      ),
    );
  }
}
