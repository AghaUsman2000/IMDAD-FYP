class DonorJson {
  final String name;
  final double lat;
  final double lng;
  final String description;
  final String ntn;
  final String email;
  final String contact;

  DonorJson({
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
    required this.ntn,
    required this.email,
    required this.contact
  });

  static DonorJson fromJson(Map<String, dynamic> json) => DonorJson(
    name: json['name'],
    lat: json['lat'],
    lng: json['lng'],
    description: json['description'],
    ntn: json['ntn'],
    email: json['email'],
    contact: json['contact'],
  );

  Map<String, dynamic> tojson() => {
    'name': name,
    'lat': lat,
    'lng': lng,
    'description': description,
    'ntn': ntn,
    'email': email,
    'contact': contact,
  };
}