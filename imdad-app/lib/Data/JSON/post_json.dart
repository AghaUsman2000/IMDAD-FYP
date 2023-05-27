class PostJson {
  final String pid;
  final String uid;
  final String nid;
  String? riderUid;
  final String title;
  final String description;
  final String quantity;
  final int accepted;
  final double lat;
  final double long;
  final String name;
  final String number;
  final String nname;
  final String nnumber;
  double? riderRating;
  String? image1;
  String? image2;
  String? image3;

  PostJson({
    required this.pid,
    required this.uid,
    required this.nid,
    required this.riderUid,
    required this.title,
    required this.description,
    required this.quantity,
    required this.lat,
    required this.long,
    required this.accepted,
    required this.name,
    required this.number,
    required this.nname,
    required this.nnumber,
    required this.riderRating,
    this.image1,
    this.image2,
    this.image3,
  });

  static PostJson fromJson(Map<String, dynamic> json, String id) => PostJson(
        pid: id,
        uid: json['uid'],
        nid: json['nid'],
        riderUid: json['riderUid'],
        title: json['title'],
        description: json['description'],
        quantity: json['quantity'],
        lat: json['lat'],
        long: json['long'],
        accepted: json['accepted'],
        number: json['number'],
        name: json['name'],
        nnumber: json['nnumber'],
        nname: json['nname'],
        riderRating: json['riderRating'],
        image1: json['image1'],
        image2: json['image2'],
        image3: json['image3'],
      );
}
