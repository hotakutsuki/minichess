import '../utils/Enums.dart';

class Tile {
  Tile(this.char, this.owner, this.i, this.j);

  Tile.fromTile(Tile otherTile) :
        char = otherTile.char,
        owner = otherTile.owner;

  Tile.fromParameters(character nC, player nP) :
        char = nC,
        owner = nP;

  character char;
  player owner;
  int? i;
  int? j;
  bool isSelected = false;
  bool isOption = false;
}