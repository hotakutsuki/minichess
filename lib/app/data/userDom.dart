import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  String? photoUrl;
  int score;

  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHOTOURL = 'photoUrl';
  static const String SCORE = 'score';

  User(this.id, this.name, this.email, this.photoUrl, this.score);

  User.fromDocStanpshot(DocumentSnapshot snapshot)
      : this(snapshot["id"], snapshot["name"], snapshot["email"],
            snapshot["photoUrl"], snapshot["score"]);

  @override
  String toString() {
    return '$name $email $id $score';
  }
}
