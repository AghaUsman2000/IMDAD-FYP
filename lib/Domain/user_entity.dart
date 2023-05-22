class UserEntity {
  final String id;
  final String email;
  bool isngo;
  String name;
  String org;
  //String display;
  List<String> posts;

  UserEntity({
    required this.id,
    required this.email,
    this.isngo = false,
    this.name = '',
    this.org = '',
    //this.display = 'https://img.icons8.com/bubbles/50/000000/user.png',
    this.posts = const [""],
  });
}