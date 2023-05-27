import 'package:flutterdemo/Domain/user_entity.dart';

abstract class PostRepository {
  //Future<List<UserEntity>> getUsers();
  addPosts(
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
    String? image3,
  );
//Future<void> updateUser(name, org);
}
