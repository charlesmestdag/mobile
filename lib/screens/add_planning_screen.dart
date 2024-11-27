import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/vehicle.dart';
import '../models/planning.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_event.dart';

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
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _savePlanning() {
    if (typeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le type de planification est requis')),
      );
      return;
    }

    final planning = Planning(
      id: DateTime.now().toString(),
      vehicleId: widget.vehicle.id!,
      type: typeController.text,
      date: selectedDate,
      sendNotification: sendNotification,
    );

    context.read<VehicleBloc>().add(AddPlanning(planning));

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
              decoration: const InputDecoration(labelText: 'Type de planification'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text('Sélectionner la date : ${selectedDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Envoyer une notification :'),
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
