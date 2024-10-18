import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  final String name;
  final GeoPoint geopoint;

  LocationModel({
    required this.name,
    required this.geopoint
  });

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      name: data['name'],
      geopoint: data['geopoint'],
    );
  }
}