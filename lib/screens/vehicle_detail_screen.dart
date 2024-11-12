import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../blocs/vehicle_bloc.dart';
import '../models/expense.dart';
import '../models/vehicle.dart';
import 'add_expense_screen.dart';
import 'edit_vehicle_screen.dart';
import 'expense_detail_screen.dart';
import 'package:flutter/services.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({Key? key, required this.vehicle}) : super(key: key);

  Future<void> generatePdf(BuildContext context, Vehicle vehicle, List<Expense> expenses) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Détails du Véhicule',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Marque : ${vehicle.marque}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Modèle : ${vehicle.modele}', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Année : ${vehicle.annee}', style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Historique des Factures',
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                if (expenses.isEmpty)
                  pw.Text('Aucune facture disponible.', style: pw.TextStyle(fontSize: 16))
                else
                  for (var expense in expenses)
                    pw.Container(
                      margin: const pw.EdgeInsets.only(bottom: 16),
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Type de dépense : ${expense.type}',
                            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text('Coût : ${expense.cost}€', style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                            'Date : ${expense.date.toLocal().toString().split(' ')[0]}',
                            style: pw.TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
              ],
            );
          },
        ),
      );

      // Enregistrer le fichier PDF
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/historique_vehicule_${vehicle.marque}_${vehicle.modele}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Ouvrir le fichier PDF
      await OpenFile.open(file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF généré avec succès !')),
      );
    } catch (e, stackTrace) {
      print("Erreur lors de la génération du PDF: $e");
      print(stackTrace);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la génération du PDF : $e')),
      );
    }
  }

  void _exportPdf(BuildContext context) async {
    final expenses = context.read<VehicleBloc>().state.expenses[vehicle.id] ?? [];
    await generatePdf(context, vehicle, expenses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.marque} ${vehicle.modele} (${vehicle.annee})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportPdf(context),
            tooltip: 'Exporter en PDF',
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
      body: Padding(
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
              child: BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  final expenses = state.expenses[vehicle.id] ?? [];
                  if (expenses.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucune facture ajoutée.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<VehicleBloc>(),
                child: AddExpenseScreen(vehicle: vehicle),
              ),
            ),
          );
        },
        tooltip: 'Ajouter une facture',
        child: const Icon(Icons.add),
      ),
    );
  }
}
