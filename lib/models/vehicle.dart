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
      marque: data['marque'] ?? 'Inconnu',
      modele: data['modele'] ?? 'Inconnu',
      annee: (data['annee'] ?? 0).toInt(),
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

  // Conversion JSON (facultatif)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marque': marque,
      'modele': modele,
      'annee': annee,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      marque: json['marque'],
      modele: json['modele'],
      annee: json['annee'],
    );
  }

  @override
  List<Object?> get props => [id, marque, modele, annee];
}
