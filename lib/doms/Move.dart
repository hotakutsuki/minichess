
import 'Tile.dart';

class Move {
  Move(this.initialTile, this.finalTile);

  Tile? initialTile;
  Tile? finalTile;

  @override
  String toString() {
    return '${initialTile?.char.toString()} ${initialTile?.i}${initialTile?.j}->${finalTile?.i}${finalTile?.j}';
  }
}