import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Data/JSON/post_json.dart';
import '../../Domain/post_repository.dart';

class TrackNgoProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<PostJson> posts = [];

  void getPosts() async {
    notifyListeners();
  }

  void fetchPosts(String uid) async {
    print("Inside function: " + uid.toString());
    await db
        .collection("posts")
        .where('accepted', whereIn: [1, 3])
        .where('nid', isEqualTo: uid)
        .get()
        .then((e) {
          posts = e.docs.map((e) => PostJson.fromJson(e.data(), e.id)).toList();
        });
    notifyListeners();
  }

  void updatePost(String pid) async {
    final data = {"accepted": 2};
    db.collection("posts").doc(pid).set(data, SetOptions(merge: true));

    notifyListeners();
  }
}
