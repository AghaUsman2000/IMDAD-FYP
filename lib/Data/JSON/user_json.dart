class UserJson {
  final String email;
  final int isngo;
  final String name;
  final String number;
  final String organisation;

  UserJson({
    required this.email,
    required this.isngo,
    required this.name,
    required this.number,
    required this.organisation,
  });


  static UserJson fromJson(Map<String, dynamic> json) =>

      UserJson(
        email: json['email'],
        isngo: json['isngo'],
        name: json['name'],
        number: json['number'],
        organisation: json['organisation'],
      );
}