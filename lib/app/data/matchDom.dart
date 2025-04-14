import 'dart:collection';

import '../utils/gameObjects/move.dart';
import '../utils/gameObjects/tile.dart';
import 'enums.dart';

class MatchDom {
  static const String ID = 'id';
  static const String STATE = 'state';
  static const String TILES = 'TILES';
  static const String HOSTPLAYERID = 'hostPlayerId';
  static const String INVITEDPLAYERID = 'invitedPlayerId';

  MatchDom(this.id, this.state, this.tiles, this.hostPlayerId,
      [this.guestPlayerId]);

  MatchDom.named({id, state, tiles, hostPlayerId, invitedPlayerId})
      : this(id, state, tiles, hostPlayerId, invitedPlayerId);

  MatchDom.nameNoGuest({id, state, tiles, hostPlayerId})
      : this(id, state, tiles, hostPlayerId);

  MatchDom.noGuest(id, state, tiles, hostPlayerId)
      : this(id, state, tiles, hostPlayerId);

  // MatchDom.fromSnapshot(DocumentSnapshot doc) {
  //   id = doc.id;
  //   state = gameState.values.firstWhere((e) => e.name == doc["state"]);
  //   moves = doc["moves"];
  //   hostPlayerId = doc["hostPlayerId"];
  //   guestPlayerId = doc["guestPlayerId"];
  // }

  late String id;
  late gameState state;
  late List<Tile> tiles;
  late String hostPlayerId;
  late String? guestPlayerId;

  // MatchDom.fromSnapshot(String id, Map<String, dynamic> doc)
  //     : this(
  //         id,
  //         gameState.values.firstWhere((e) => e.name == doc[STATE]),
  //         doc[TILES].isNotEmpty ? doc[TILES].map((e) => Tile.fromString(e)).toList() : [],
  //         doc[HOSTPLAYERID] ?? '',
  //         doc[INVITEDPLAYERID] ?? '',
  //       );

  MatchDom.fromSnapshot(this.id, Map<String, dynamic> doc) {
    state = gameState.values.firstWhere((e) => e.name == doc[STATE]);
    List<Tile> aux = [];
    doc[TILES].forEach((e) => aux.add(Tile.fromString(e)));
    tiles = aux;
    hostPlayerId = doc[HOSTPLAYERID] ?? '';
    guestPlayerId = doc[INVITEDPLAYERID] ?? '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = HashMap();
    map[ID] = id;
    map[STATE] = state.name;
    map[TILES] = tiles.map((m) => m.toString()).toList();
    map[HOSTPLAYERID] = hostPlayerId;
    map[INVITEDPLAYERID] = guestPlayerId;
    return map;
  }

  @override
  String toString() {
    return '$hostPlayerId vs $guestPlayerId';
  }
}
