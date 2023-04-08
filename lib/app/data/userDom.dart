import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String? photoUrl;
  String? country;
  String? countryCode;
  String? city;
  int score;

  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHOTOURL = 'photoUrl';
  static const String SCORE = 'score';
  static const String COUNTRY = 'country';
  static const String COUNTRYCODE = 'countryCode';
  static const String CITY = 'city';

  User(this.id, this.name, this.email, this.photoUrl, this.score, this.country,
      this.countryCode, this.city);

  User.fromDocStanpshot(Map<String, dynamic> snapshot)
      : this(
          snapshot[ID],
          snapshot[NAME],
          snapshot[EMAIL],
          snapshot.containsKey(PHOTOURL) ? snapshot[PHOTOURL] : '',
          snapshot[SCORE],
          snapshot.containsKey(COUNTRY) ? snapshot[COUNTRY] : '',
          snapshot.containsKey(COUNTRYCODE) ? snapshot[COUNTRYCODE] : '',
          snapshot.containsKey(CITY) ? snapshot[CITY] : '',
        );

  @override
  String toString() {
    return '$name $email $id $score';
  }
}
