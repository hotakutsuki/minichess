import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;

  User(this.id, this.name, this.email);

  User.fromDocStanpshot(DocumentSnapshot snapshot)
      : this(snapshot.id, snapshot["name"], snapshot["email"]);
}
