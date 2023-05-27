import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addRiderToFirestore({
  required String uid,
  required String email,
  required String name,
  required int age,
  required bool isRider,
  required Timestamp joinDate,
  required GeoPoint? location,
  required int phoneNumber,
  required double rating,
  required String status,
  required String? vehicleType,
  required String vehicleNumber,
}) async {
  CollectionReference riders = FirebaseFirestore.instance.collection('riders');
  return riders.doc(uid).set({
    'email': email,
    'name': name,
    'age': age,
    'isRider': true,
    'join_date': joinDate,
    'location': location,
    'phone_number': phoneNumber,
    'rating': rating,
    'status': status,
    'vehicle_type': vehicleType,
    'vehicle_number': vehicleNumber
  });
}
