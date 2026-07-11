import '../../data/enums.dart';

class Tile {
  Tile(this.char, this.owner, this.i, this.j,
      {this.idleTurns = 0, this.felledTurns = 0});

  Tile.fromTile(Tile otherTile) :
        char = otherTile.char,
        owner = otherTile.owner;

  Tile.fromParameters(chrt nC, possession nP) :
        char = nC,
        owner = nP;

  Tile.fromString(String s){
    var splited = s.split(' ');
    owner = possession.values.firstWhere((p) => p.name == splited[0]);
    char = chrt.values.firstWhere((c) => c.name == splited[1]);
    //TODO: enhance this
    i = splited[2] == 'null' ? null : int.parse(splited[2]);
    j = splited[3] == 'null' ? null : int.parse(splited[3]);
  }

  late chrt char;
  late possession owner;
  late int? i;
  late int? j;
  bool isSelected = false;
  bool isOption = false;

  /// Consecutive turns this piece's owner has left it unmoved. Used by the
  /// "Marchitar" rule modifier; carried across board copies/rotations, reset to
  /// 0 when the piece moves.
  int idleTurns = 0;

  /// Turns this square stays "felled" (inaccessible to the blocked side). Used
  /// by the dynamic "Tala el tablero" modifier; 0 == normal. Carried across
  /// board copies/rotations so a felled square stays felled as the board turns.
  int felledTurns = 0;

  @override
  String toString() {
    return '${owner.name} ${char.name} $i $j $isSelected';
  }

  String toStingWithTimeStamp(){
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    return '${owner.name} ${char.name} $i $j $isSelected $timeStamp';
  }
}