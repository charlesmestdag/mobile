import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/expense.dart';
import '../models/vehicle.dart';
import 'dart:io';

class AddExpenseScreen extends StatefulWidget {
  final Vehicle vehicle;

  const AddExpenseScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  File? _selectedImage;

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveExpense() {
    final expense = Expense(
      id: DateTime.now().toString(),
      vehicleId: widget.vehicle.id,
      type: typeController.text,
      cost: double.tryParse(costController.text) ?? 0.0,
      date: selectedDate,
      imagePath: _selectedImage?.path, // Enregistrer le chemin de l'image
    );

    context.read<VehicleBloc>().add(AddExpense(expense));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une dépense')),
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
              decoration: const InputDecoration(labelText: 'Coût'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text('Sélectionner la date: ${selectedDate.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Galerie'),
                ),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Caméra'),
                ),
              ],
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(_selectedImage!, height: 100),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveExpense,
              child: const Text('Ajouter la dépense'),
            ),
          ],
        ),
      ),
    );
  }
}
