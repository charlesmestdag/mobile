import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/expense.dart';
import '../models/vehicle.dart';
import 'dart:io';
import 'add_expense_screen.dart';


class ExpenseListScreen extends StatelessWidget {
  final Vehicle vehicle;

  const ExpenseListScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factures pour ${vehicle.marque} ${vehicle.modele}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          final expenses = state.expenses[vehicle.id] ?? [];

          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                'Aucune facture ajoutée.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              final formattedDate = DateFormat('dd-MM-yyyy').format(expense.date);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: ListTile(
                  leading: expense.imagePath != null
                      ? Image.file(
                    File(expense.imagePath!),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.receipt, size: 50),
                  title: Text(
                    expense.type,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Date: $formattedDate'),
                      Text('Coût: ${expense.cost}€'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
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
      ),
    );
  }
}
