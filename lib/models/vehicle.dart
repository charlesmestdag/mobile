// lib/models/vehicle.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String? id;
  final String marque;
  final String modele;
  final int annee;

  const Vehicle({
    this.id,
    required this.marque,
    required this.modele,
    required this.annee,
  });

  // Conversion depuis un DocumentSnapshot
  factory Vehicle.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Vehicle(
      id: snapshot.id,
      marque: data['marque'],
      modele: data['modele'],
      annee: data['annee'],
    );
  }

  // Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'marque': marque,
      'modele': modele,
      'annee': annee,
    };
  }

  @override
  List<Object?> get props => [id, marque, modele, annee];
}
