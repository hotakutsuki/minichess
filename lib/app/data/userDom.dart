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
          snapshot.containsKey(EMAIL) ? snapshot[EMAIL] : null,
          snapshot.containsKey(PHOTOURL) ? snapshot[PHOTOURL] : null,
          snapshot[SCORE],
          snapshot.containsKey(COUNTRY) ? snapshot[COUNTRY] : null,
          snapshot.containsKey(COUNTRYCODE) ? snapshot[COUNTRYCODE] : null,
          snapshot.containsKey(CITY) ? snapshot[CITY] : null,
          snapshot.containsKey(PASSWORD) ? snapshot[PASSWORD] : null,
        );

  getProperty(String fieldName){
    switch (fieldName){
      case ID:
        return id;
      case NAME:
        return name;
      case EMAIL:
        return email;
      case PHOTOURL:
        return photoUrl;
      case SCORE:
        return score;
      case COUNTRY:
        return country;
      case COUNTRYCODE:
        return countryCode;
      case CITY:
        return city;
      case PASSWORD:
        return password;
    }
  }

  @override
  String toString() {
    return '$name $id $score';
  }
}
