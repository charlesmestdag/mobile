// lib/screens/edit_vehicle_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';
import '../models/vehicle.dart';

class EditVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;

  const EditVehicleScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  _EditVehicleScreenState createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  late TextEditingController marqueController;
  late TextEditingController modeleController;
  late TextEditingController anneeController;

  @override
  void initState() {
    super.initState();
    marqueController = TextEditingController(text: widget.vehicle.marque);
    modeleController = TextEditingController(text: widget.vehicle.modele);
    anneeController = TextEditingController(text: widget.vehicle.annee.toString());
  }

  void _updateVehicle() {
    final updatedVehicle = Vehicle(
      id: widget.vehicle.id,
      marque: marqueController.text,
      modele: modeleController.text,
      annee: int.parse(anneeController.text),
    );

    context.read<VehicleBloc>().add(UpdateVehicle(updatedVehicle));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    marqueController.dispose();
    modeleController.dispose();
    anneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le véhicule')),
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
              onPressed: _updateVehicle,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
