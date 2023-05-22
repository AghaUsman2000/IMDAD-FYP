import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterdemo/Domain/post_repository.dart';

class FirebasePostRepository implements PostRepository {
  final db = FirebaseFirestore.instance;

  @override
  addPosts(String title, String description, String quantity, String uid,
      double lat, double long, String name, String number, String image1,String image2, String image3) {
    //notifyListeners();
    db.collection("posts").add({
      "title": title,
      "description": description,
      "quantity": quantity,
      "uid": uid,
      // "rid": "undefined",
      "accepted": 0,
      "nid": "undefined",
      "lat": lat,
      "long": long,
      "name": name,
      "number": number,
      "nname": "undefined",
      "nnumber": "undefined",
      "image1": image1,
      "image2": image2,
      "image3":image3
    }).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }
}
