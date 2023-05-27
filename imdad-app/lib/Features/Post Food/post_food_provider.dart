import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterdemo/Domain/post_repository.dart';

import '../../Data/JSON/user_json.dart';

class PostFoodProvider extends ChangeNotifier {
  PostFoodProvider(this.postRepository);

  final db = FirebaseFirestore.instance;
  final PostRepository postRepository;

  List<UserJson> list = [];

  void addposts(
      String title,
      String description,
      String quantity,
      String uid,
      double lat,
      double long,
      String name,
      String number,
      String? image1,
      String? image2,
      String image3) {
    //isUsersFetching = true;
    //notifyListeners();
    postRepository.addPosts(title, description, quantity, uid, lat, long, name,
        number, image1, image2, image3);
    //isUsersFetching = false;
    notifyListeners();
  }

  void getUserDetails(String uid) async {
    await db.collection("users").doc(uid).get().then((e) {
      list.add(UserJson.fromJson(e.data() as Map<String, dynamic>));
    });

    notifyListeners();
  }
}
