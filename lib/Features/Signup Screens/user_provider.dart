import 'package:flutter/material.dart';
import '../../Domain/user_entity.dart';
import '../../Domain/user_repository.dart';

class UserProvider with ChangeNotifier {

  UserProvider(this.userRepository);

  final UserRepository userRepository;

  List<UserEntity> users = [];
  //
  // Future<void> fetchUsers() async {
  //   users = await userRepository.getUsers();
  //   notifyListeners();
  // }
  //
  // Future<void> updateUser(String name, String org) async {
  //   userRepository.updateUser(name, org);
  //   notifyListeners();
  // }
  //
  // Future<void> saveChanges() async {
  //   notifyListeners();
  // }

  // Future<void> addUser(String ID, String description, String quantity,String id) async {
  //
  //   await db.collection("posts").add({
  //     "title": title,
  //     "description": description,
  //     "quantity": quantity,
  //     "id":id,
  //   }).then((DocumentReference doc) =>
  //       print('DocumentSnapshot added with ID: ${doc.id}'));
  // }

}