import 'package:flutterdemo/Domain/user_entity.dart';

abstract class PostRepository {

  //Future<List<UserEntity>> getUsers();
  addPosts(String title, String description, String quantity, String uid, double lat, double long, String name, String number);
//Future<void> updateUser(name, org);

}