import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/Domain/post_repository.dart';

import '../../Data/JSON/user_json.dart';

class ProfileProvidor extends ChangeNotifier{

  final db = FirebaseFirestore.instance;
  List<UserJson> list = [];


  void getUserDetails(String uid) async {

    await db.collection("users").doc(uid).get().then((e) {
      list.add(UserJson.fromJson(e.data() as Map<String, dynamic>));
    });

    notifyListeners();
  }

}