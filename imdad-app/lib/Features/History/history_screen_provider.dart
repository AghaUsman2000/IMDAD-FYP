import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Data/JSON/post_json.dart';

class HistoryScreenProvider with ChangeNotifier {
  final db = FirebaseFirestore.instance;

  Future<List<PostJson>> fetchPosts(String uid) async {
    List<PostJson> posts = [];
    await db
        .collection("posts")
        .where('accepted', isEqualTo: 2)
        .where('nid', isEqualTo: uid)
        .get()
        .then((e) {
      posts = e.docs.map((e) => PostJson.fromJson(e.data(), e.id)).toList();
    });
    print(posts);
    return posts;
  }
}
