import '../utils/Enums.dart';
import 'Tile.dart';

class GameState {
  GameState(this.board, this.myGraveyard, this.enemyGraveyard, this.playersTurn);

  List<List<Tile>> board = [[]];
  List<Tile> myGraveyard = [];
  List<Tile> enemyGraveyard = [];
  player playersTurn;
}