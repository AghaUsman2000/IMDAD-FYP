import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Data/JSON/post_json.dart';

class PostRequestsProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  List<PostJson> posts = [];

  void getPosts() async {
    notifyListeners();
  }

  void fetchPosts() async {
    print('Inside fetch posts function posts requests');

    await db
        .collection("posts")
        .where('accepted', isEqualTo: 0)
        .where('uid', isEqualTo: userId)
        .get()
        .then((e) {
      posts = e.docs
          .map((e) => PostJson.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });

    notifyListeners();
  }

  void acceptPost(String nid, String pid) async {
    final data = {"nid": nid, "accepted": 1};
    db.collection("posts").doc(pid).set(data, SetOptions(merge: true));
    print("NID: " + nid);
    print("PID: " + pid);

    notifyListeners();
  }
}
