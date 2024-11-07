import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehicle.dart';

class AddVehicleScreen extends StatelessWidget {
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController modeleController = TextEditingController();
  final TextEditingController anneeController = TextEditingController();

  AddVehicleScreen({Key? key}) : super(key: key);

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
              onPressed: () {
                final marque = marqueController.text;
                final modele = modeleController.text;
                final annee = int.tryParse(anneeController.text);

                if (marque.isNotEmpty && modele.isNotEmpty && annee != null) {
                  final newVehicle = Vehicle(
                    id: DateTime.now().toString(),
                    marque: marque,
                    modele: modele,
                    annee: annee,
                  );

                  // Envoie de l'événement AddVehicle au bloc
                  context.read<VehicleBloc>().add(AddVehicle(newVehicle));

                  // Retour à l'écran précédent après l'ajout
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter le véhicule'),
            ),
          ],
        ),
      ),
    );
  }
}
