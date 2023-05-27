import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Data/JSON/post_json.dart';

class TrackDonarProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  List<PostJson> posts = [];

  void getPosts() async {
    notifyListeners();
  }

  void fetchPosts(String uid) async {
    await db
        .collection("posts")
        .where('accepted', whereIn: [1, 3])
        .where('uid', isEqualTo: uid)
        .get()
        .then((e) {
          posts = e.docs.map((e) => PostJson.fromJson(e.data(), e.id)).toList();
        });

    notifyListeners();
  }
}
