import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Planning extends Equatable {
  final String? id;
  final String vehicleId;
  final String type;
  final DateTime date;
  final bool sendNotification;

  const Planning({
    this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    this.sendNotification = false,
  });

  // Conversion depuis un DocumentSnapshot
  factory Planning.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Planning(
      id: snapshot.id,
      vehicleId: data['vehicleId'],
      type: data['type'],
      date: (data['date'] as Timestamp).toDate(),
      sendNotification: data['sendNotification'],
    );
  }

  // Conversion vers Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'vehicleId': vehicleId,
      'type': type,
      'date': date,
      'sendNotification': sendNotification,
    };
  }

  @override
  List<Object?> get props => [id, vehicleId, type, date, sendNotification];
}
