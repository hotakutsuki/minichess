import '../utils/Enums.dart';

class Tile {
  Tile(this.char, this.owner, this.i, this.j);

  Tile.fromTile(Tile otherTile) :
        char = otherTile.char,
        owner = otherTile.owner;

  Tile.fromParameters(chrt nC, possession nP) :
        char = nC,
        owner = nP;

  chrt char;
  possession owner;
  int? i;
  int? j;
  bool isSelected = false;
  bool isOption = false;

  @override
  String toString() {
    return '${owner.name}${char.name}$i$j';
  }
}