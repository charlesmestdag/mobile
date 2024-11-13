class Planning {
  final String id;
  final String vehicleId;
  final String type;
  final DateTime date;
  final bool sendNotification;

  Planning({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.sendNotification,
  });
}
