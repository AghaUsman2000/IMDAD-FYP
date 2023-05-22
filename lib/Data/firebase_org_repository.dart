import 'package:cloud_firestore/cloud_firestore.dart';
import '../Domain/org_entity.dart';
import '../Domain/org_respository.dart';
import 'JSON/donor_json.dart';
import 'JSON/org_json.dart';

class FirebaseOrgRepository implements OrgRepository {
  final db = FirebaseFirestore.instance;

  @override
  Future<List<OrgJson>> getOrgs() async {

    //final orgList = await db.collection("organizations").get();

    List<OrgJson> orgs = [];

    await db.collection("organizations").get().then((e) {
      // for (var doc in event.docs) {
      //   print("${doc.id} => ${doc.data()}");
      //   print('Hello!');
      // }
      orgs = e.docs.map((e) => OrgJson.fromJson(e.data() as Map<String, dynamic>))
          .toList();
          // .map((e) => OrgEntity(name: e.name, description: e.description))
          // .toList();


      print("Length: " + orgs.length.toString());
    });

    return orgs;

    // final list = orgList.docs
    //     .map((e) => OrgJson.fromJson(e as Map<String, dynamic>))
    //     .toList()
    //     .map((e) => OrgEntity(name: e.name, description: e.description))
    //     .toList();
    //
    // print(list);

  }


}