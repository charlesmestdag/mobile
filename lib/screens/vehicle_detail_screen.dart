// lib/screens/vehicle_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../blocs/vehicle/vehicle_bloc.dart';
import '../blocs/vehicle/vehicle_state.dart';
import '../models/expense.dart';
import '../models/vehicle.dart';
import 'add_expense_screen.dart';
import 'edit_vehicle_screen.dart';
import 'expense_detail_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({Key? key, required this.vehicle}) : super(key: key);

  Future<void> generatePdf(BuildContext context, Vehicle vehicle, List<Expense> expenses) async {
    // Votre code pour générer le PDF reste inchangé
  }

  void _exportPdf(BuildContext context, List<Expense> expenses) async {
    await generatePdf(context, vehicle, expenses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.marque} ${vehicle.modele} (${vehicle.annee})'),
        actions: [
          BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () {
                  if (state is VehicleLoaded) {
                    final expenses = state.expenses[vehicle.id] ?? [];
                    _exportPdf(context, expenses);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Les données ne sont pas encore chargées.')),
                    );
                  }
                },
                tooltip: 'Exporter en PDF',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditVehicleScreen(vehicle: vehicle),
                ),
              );
            },
            tooltip: 'Modifier les informations du véhicule',
          ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoaded) {
            final expenses = state.expenses[vehicle.id] ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Marque : ${vehicle.marque}', style: const TextStyle(fontSize: 18)),
                  Text('Modèle : ${vehicle.modele}', style: const TextStyle(fontSize: 18)),
                  Text('Année : ${vehicle.annee}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Text(
                    'Historique des Factures',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: expenses.isEmpty
                        ? const Center(
                      child: Text(
                        'Aucune facture ajoutée.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(expense.type),
                            subtitle: Text(
                                'Coût: ${expense.cost}€ - Date: ${expense.date.toLocal().toString().split(' ')[0]}'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ExpenseDetailScreen(expense: expense),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VehicleError) {
            return Center(child: Text('Erreur : ${state.error}'));
          } else {
            return const Center(child: Text('Chargement...'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(vehicle: vehicle),
            ),
          );
        },
        tooltip: 'Ajouter une facture',
        child: const Icon(Icons.add),
      ),
    );
  }
}
