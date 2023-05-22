import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Domain/org_respository.dart';
import '../../Data/JSON/post_json.dart';
import '../../Domain/post_entity.dart';

class HomeNgoProvider with ChangeNotifier {

  final db = FirebaseFirestore.instance;

  List<PostJson> list = [];
  //
  final OrgRepository orgRepository;
  HomeNgoProvider(this.orgRepository);

  void getPosts() async {
    //list = await orgRepository.getOrgs();
    notifyListeners();
  }

  void fetchPosts() async{

    print('Inside fetch posts function NGO MAP');
    await db.collection("posts").where('accepted', isEqualTo: 0).get().then((e) {
      list = e.docs.map((e) => PostJson.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
          // .map((e) => PostEntity(nid: e.nid, uid: e.uid, title: e.title, description: e.description, quantity: e.quantity, lat: e.lat, long: e.long, accepted: e.accepted ))
          // .toList();
    });
    notifyListeners();
  }

  void fetchUser(String uid) async{

  }
}