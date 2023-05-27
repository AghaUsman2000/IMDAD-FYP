class OrgJson {
  final String name;
  final String description;
  final String image;
  final double lat;
  final double long;

  OrgJson({
    required this.name,
    required this.description,
    required this.image,
    required this.lat,
    required this.long,
  });

  static OrgJson fromJson(Map<String, dynamic> json) => OrgJson(
        name: json['name'] as String,
        description: json['description'] as String,
        image: json['image'],
        lat: json['lat'],
        long: json['long'],
      );
}
