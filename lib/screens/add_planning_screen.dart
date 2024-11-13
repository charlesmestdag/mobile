import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/planning.dart';
import '../models/vehicle.dart';
import '../services/notification_service.dart';

class AddPlanningScreen extends StatefulWidget {
  final Vehicle vehicle;

  const AddPlanningScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  _AddPlanningScreenState createState() => _AddPlanningScreenState();
}

class _AddPlanningScreenState extends State<AddPlanningScreen> {
  final TextEditingController typeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool sendNotification = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _savePlanning() {
    final planning = Planning(
      id: DateTime.now().toString(),
      vehicleId: widget.vehicle.id,
      type: typeController.text,
      date: selectedDate,
      sendNotification: sendNotification,
    );

    context.read<VehicleBloc>().add(AddPlanning(planning));

    // Programmer une notification si l'utilisateur a choisi cette option
    if (sendNotification) {
      NotificationService().scheduleNotification(
        planning.hashCode, // Utiliser l'ID unique du planning comme identifiant
        'Rappel de planification',
        'La planification pour ${planning.type} est prévue pour aujourd\'hui.',
        selectedDate,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une planification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: typeController,
              decoration:
              const InputDecoration(labelText: 'Type de planification'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                  'Sélectionner la date: ${selectedDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Envoyer une notification:'),
                Switch(
                  value: sendNotification,
                  onChanged: (value) {
                    setState(() {
                      sendNotification = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePlanning,
              child: const Text('Ajouter la planification'),
            ),
          ],
        ),
      ),
    );
  }
}
