import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Data/JSON/org_json.dart';
import 'package:flutterdemo/Domain/org_respository.dart';
import '../../Domain/org_entity.dart';

class HomeDonorProvider with ChangeNotifier {

  final db = FirebaseFirestore.instance;

  List<OrgEntity> list = [];

  final OrgRepository orgRepository;
  HomeDonorProvider(this.orgRepository);

  void getOrgs() async {
  //list = await orgRepository.getOrgs();
  notifyListeners();
  }

  void fetchOrgs() async{
    await db.collection("organizations").get().then((e) {
      list = e.docs.map((e) => OrgJson.fromJson(e.data() as Map<String, dynamic>))
          .toList()
          .map((e) => OrgEntity(name: e.name, description: e.description, image: e.image, lat: e.lat, long: e.long))
       .toList();
      notifyListeners();
    });
  }
}