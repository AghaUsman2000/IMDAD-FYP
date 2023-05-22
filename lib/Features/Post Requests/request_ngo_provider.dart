import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Data/JSON/post_json.dart';
import '../../Data/JSON/user_json.dart';

class RequestNgoProvider with ChangeNotifier {

  final db = FirebaseFirestore.instance;

  List<PostJson> posts = [];
  List<UserJson> list = [];

  void getPosts() async {

    notifyListeners();
  }
  void fetchPosts() async{
    print('Inside fetch posts function posts requests');

    await db.collection("posts").where('accepted', isEqualTo: 0).get().then((e) {
      posts = e.docs.map((e) => PostJson.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });

    notifyListeners();
  }

  void acceptPost(String nid,  String pid, String name, String number) async{

    final data = {"nid": nid, "accepted": 1, "nname" : name, "nnumber": number};
    db.collection("posts").doc(pid).set(data, SetOptions(merge: true));
    print("NID: " + nid);
    print("PID: " + pid);

    notifyListeners();
  }

  void getUserDetails(String uid) async {

    await db.collection("users").doc(uid).get().then((e) {
      list.add(UserJson.fromJson(e.data() as Map<String, dynamic>));
    });

    notifyListeners();
  }


}