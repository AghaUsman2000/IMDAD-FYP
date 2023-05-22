import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Data/JSON/user_json.dart';
import 'package:flutterdemo/Domain/org_respository.dart';
import 'package:flutterdemo/Domain/user_repository.dart';
import '../../Data/JSON/post_json.dart';

class LoginProvidor with ChangeNotifier {

  final db = FirebaseFirestore.instance;

  List<PostJson> posts = [];
  List<UserJson> list = [];

  bool isPostsFetching = false;


  void validateUser(String email) async {

    await db.collection("users").where('email', isEqualTo: email).get().then((e) {
      list = e.docs.map((e) => UserJson.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    });
    notifyListeners();
  }
}