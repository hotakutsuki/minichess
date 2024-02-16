import 'dart:ui';

enum chrt { empty, pawn, rock, king, bishop, knight, queen }
enum player { white, black, none }
enum possession { mine, enemy, none }
enum gameMode { vs, solo, online, training }
enum gameState { open, playing, finished, blocked, fake, unknown }
enum collections {matches, users, tokens}
enum sharedPrefs {userName, firstTimeToOpen, showTale, difficult}
enum difficult {easy, normal, hard}
Color brackgroundColor = const Color.fromRGBO(23, 55, 96, 0.38);
Color brackgroundColorSolid = const Color.fromRGBO(23, 55, 96, 1);
Color brackgroundColorSemi = const Color.fromRGBO(23, 55, 96, 0.95);
Color brackgroundColorLight = const Color.fromRGBO(108, 185, 241, 1);
Color brackgroundColorLightTrans = const Color.fromRGBO(108, 185, 241, 0.25);
Color whitePlayerColor = const Color.fromRGBO(204, 172, 75, 1);
Color blackPlayerColor = const Color.fromRGBO(238, 97, 54, 1);
double graveyardHeight = 47; //60
double graveyardTileWide = 282; //360
String gameName = 'Inti: The Inka Chess Game';