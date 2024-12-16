import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import 'dart:io';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late TextEditingController typeController;
  late TextEditingController costController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.expense.type);
    costController = TextEditingController(text: widget.expense.cost.toString());
    selectedDate = widget.expense.date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    final updatedExpense = Expense(
      id: widget.expense.id,
      vehicleId: widget.expense.vehicleId,
      type: typeController.text,
      cost: double.tryParse(costController.text) ?? widget.expense.cost,
      date: selectedDate,
      imagePath: widget.expense.imagePath,
    );

    context.read<VehicleBloc>().add(UpdateExpense(updatedExpense));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la facture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type de dépense'),
            ),
            TextField(
              controller: costController,
              decoration: const InputDecoration(labelText: 'Coût (€)'),
              keyboardType: TextInputType.number,
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text('Sélectionner la date : ${selectedDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveExpense,
              child: const Text('Enregistrer'),
            ),
            if (widget.expense.imagePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(
                  File(widget.expense.imagePath!),
                  height: 100,
                ),
              ),
          ],
        ),
      ),
    );
  }
}