// models/vehicle.dart
class Vehicle {
  final String id;
  final String marque;
  final String modele;
  final int annee;

  Vehicle({
    required this.id,
    required this.marque,
    required this.modele,
    required this.annee,
  });

  // Ajoutez la méthode copyWith
  Vehicle copyWith({
    String? marque,
    String? modele,
    int? annee,
  }) {
    return Vehicle(
      id: id, // Gardez l'ID inchangé
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
    );
  }
}
