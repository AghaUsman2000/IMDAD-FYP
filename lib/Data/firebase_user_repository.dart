import 'package:cloud_firestore/cloud_firestore.dart';
import '../Domain/user_entity.dart';
import '../Domain/user_repository.dart';
import 'JSON/user_json.dart';

class FirebaseUserRepository implements UserRepository {

  final db = FirebaseFirestore.instance;
  UserEntity user = UserEntity(id: "", email: "");

  CollectionReference firebaseUser =
  FirebaseFirestore.instance.collection('users');

  UserEntity get userEntity => user;

  @override
  // Future<List<UserEntity>> getUsers() async {
  //
  // }

  @override
  Future<void> updateUser(name, org) async {
    user.name = name;
    user.org = org;
  }

}