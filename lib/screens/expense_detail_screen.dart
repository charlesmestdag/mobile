import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/expense.dart';
import '../blocs/vehicle/vehicle_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.expense.type);
    costController = TextEditingController(text: widget.expense.cost.toString());
    selectedDate = widget.expense.date;
    _selectedImage = widget.expense.imagePath != null ? File(widget.expense.imagePath!) : null;
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
    final updatedExpense = Expense(
      id: widget.expense.id,
      vehicleId: widget.expense.vehicleId,
      type: typeController.text,
      cost: double.tryParse(costController.text) ?? widget.expense.cost,
      date: selectedDate,
      imagePath: _selectedImage?.path,
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
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              if (_selectedImage != null)
                Image.file(
                  _selectedImage!,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}