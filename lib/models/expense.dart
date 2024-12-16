// lib/models/expense.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String? id;
  final String vehicleId;
  final String type;
  final double cost;
  final DateTime date;
  final String? imagePath;

  const Expense({
    this.id,
    required this.vehicleId,
    required this.type,
    required this.cost,
    required this.date,
    this.imagePath,
  });

  // Conversion depuis un DocumentSnapshot
  factory Expense.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Expense(
      id: snapshot.id,
      vehicleId: data['vehicleId'] ?? '',
      type: data['type'] ?? '',
      cost: (data['cost'] as num).toDouble(), // Conversion flexible
      date: (data['date'] as Timestamp).toDate(),
      imagePath: data['imagePath'],
    );
  }

  // Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'type': type,
      'cost': cost,
      'date': Timestamp.fromDate(date),
      'imagePath': imagePath,
    };
  }

  @override
  List<Object?> get props => [id, vehicleId, type, cost, date, imagePath];
}
