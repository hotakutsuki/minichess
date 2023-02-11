import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/gameObjects/move.dart';
import 'enums.dart';

class MatchDom {
  static const String ID = 'id';
  static const String STATE = 'state';
  static const String MOVES = 'moves';
  static const String HOSTPLAYERID = 'hostPlayerId';
  static const String INVITEDPLAYERID = 'invitedPlayerId';

  MatchDom(
      this.id, this.state, this.moves, this.hostPlayerId, [this.guestPlayerId]);

  MatchDom.named({id, state, moves, hostPlayerId, invitedPlayerId})
      : this(id, state, moves, hostPlayerId, invitedPlayerId);

  MatchDom.nameNoGuest({id, state, moves, hostPlayerId})
      : this(id, state, moves, hostPlayerId);

  // MatchDom.fromSnapshot(DocumentSnapshot doc) {
  //   id = doc.id;
  //   state = gameState.values.firstWhere((e) => e.name == doc["state"]);
  //   moves = doc["moves"];
  //   hostPlayerId = doc["hostPlayerId"];
  //   guestPlayerId = doc["guestPlayerId"];
  // }

  String id;
  gameState state;
  List<Move> moves;
  String hostPlayerId;
  String? guestPlayerId;

  MatchDom.fromSnapshot(String id, Map<String, dynamic> doc)
      : this(
          id,
          gameState.values.firstWhere((e) => e.name == doc["state"]),
          doc['moves'].isNotEmpty ? doc['moves'].map((e) => Move.fromString(e)) : [],
          doc["hostPlayerId"] ?? '',
          doc["invitedPlayerId"] ?? '',
        );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = HashMap();
    map['id'] = id;
    map["state"] = state.name;
    map["moves"] = moves;
    map["hostPlayerId"] = hostPlayerId;
    map["invitedPlayerId"] = guestPlayerId;
    return map;
  }

  @override
  String toString() {
    return '$hostPlayerId vs $guestPlayerId';
  }
}
