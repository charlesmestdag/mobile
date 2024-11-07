class Expense {
  final String id;
  final String vehicleId;
  final String type;
  final double cost;
  final DateTime date;
  final String? imagePath; // Nouveau champ pour le chemin de l'image

  Expense({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.cost,
    required this.date,
    this.imagePath,
  });
}
