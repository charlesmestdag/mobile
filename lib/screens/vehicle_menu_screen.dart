import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import 'vehicle_detail_screen.dart';
import 'vehicle_planning_screen.dart';

class VehicleMenuScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleMenuScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.marque} ${vehicle.modele} (${vehicle.annee})'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehicleDetailScreen(vehicle: vehicle),
                  ),
                );
              },
              child: const Text('Historique'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehiclePlanningScreen(vehicle: vehicle),
                  ),
                );
              },
              child: const Text('Plannification'),
            ),
          ],
        ),
      ),
    );
  }
}
