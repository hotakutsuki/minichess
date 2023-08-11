class User {
  String id;
  String name;
  String? email;
  String? photoUrl;
  int score;
  String? country;
  String? countryCode;
  String? city;
  String? password;


  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHOTOURL = 'photoUrl';
  static const String SCORE = 'score';
  static const String COUNTRY = 'country';
  static const String COUNTRYCODE = 'countryCode';
  static const String CITY = 'city';
  static const String PASSWORD = 'password';

  User(this.id, this.name, this.email, this.photoUrl, this.score, this.country,
      this.countryCode, this.city, this.password);

  User.basicUser(this.id, this.name, this.score);

  User.fromDocStanpshot(Map<String, dynamic> snapshot, String id)
      : this(
          id,
          snapshot[NAME],
          snapshot.containsKey(EMAIL) ? snapshot[EMAIL] : '',
          snapshot.containsKey(PHOTOURL) ? snapshot[PHOTOURL] : '',
          snapshot[SCORE],
          snapshot.containsKey(COUNTRY) ? snapshot[COUNTRY] : '',
          snapshot.containsKey(COUNTRYCODE) ? snapshot[COUNTRYCODE] : '',
          snapshot.containsKey(CITY) ? snapshot[CITY] : '',
          snapshot.containsKey(PASSWORD) ? snapshot[PASSWORD] : '',
        );

  @override
  String toString() {
    return '$name $id $score';
  }
}
