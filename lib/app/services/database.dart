import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:minichess/app/data/enums.dart';
import 'package:minichess/app/modules/errors/controllers/errors_controller.dart';
import 'package:minichess/app/modules/match/controllers/match_making_controller.dart';

import '../data/matchDom.dart';
import '../data/userDom.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/match/controllers/match_controller.dart';
import '../utils/gameObjects/tile.dart';

class DatabaseController extends GetxController {
  late final AuthController authController;
  late MatchMakingController matchMakingController;
  late final ErrorsController errorsController;
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MatchController? matchController;
  Stream? documentStream;

  Future<List<MatchDom>> getOpenMatches() async {
    List<MatchDom> list = [];
    var matchesSnapshots = await _firestore
        .collection(collections.matches.name)
        .where('state', isEqualTo: gameState.open.name)
        .get();
    print('docs number: ${matchesSnapshots.docs.length}');
    list.addAll(matchesSnapshots.docs
        .map((e) => MatchDom.fromSnapshot(e.id, e.data()))
        .toList());
    return list;
  }

  Future<bool> addMatch() {
    matchMakingController = Get.find<MatchMakingController>();
    List<Tile> tiles = [];
    var docRef = _firestore.collection(collections.matches.name).doc();
    matchMakingController.gameId.value = docRef.id;
    print(
        'adding match ${matchMakingController.gameId.value}, ${gameState.open
            .name}');
    var newMatch = MatchDom.noGuest(
      matchMakingController.gameId.value,
      gameState.open,
      tiles,
      authController.googleAccount.value!.id.toString(),
    ).toMap();
    print('Match: $newMatch');
    return docRef.set(newMatch).then((value) {
      print("Match added starting...");
      return true;
    }).catchError((error) {
      print("Failed to start match: $error");
      errorsController.showGenericError(error.toString());
      return false;
    });
  }

  void closeMatch() {
    print(
        'closeing match ${matchMakingController.gameId.value}, ${gameState.open
            .name}');
    documentStream = null;
    var docRef = _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value);
    docRef.update({MatchDom.STATE: gameState.finished.name});
  }

  startListenersOfMatch() {
    print('starting listeners and linking matchController...');
    matchController = Get.find<MatchController>();

    if (documentStream == null) {
      documentStream = FirebaseFirestore.instance
          .collection(collections.matches.name)
          .doc(matchMakingController.gameId.value)
          .snapshots();
      print('documentStream2: $documentStream, $matchController');
      documentStream!
          .listen((event) => matchController!.whenMatchStateChange(event));
    }
  }

  Future<bool> addPlayedTile(Tile tile) {
    print('played tile: $tile');
    print('documentStream1: $documentStream');
    print('gameId: ${matchMakingController.gameId.value}');
    print('remoteTiles: ${matchController!.remoteTiles}');
    return _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value)
        .update({
      MatchDom.TILES: [...matchController!.remoteTiles, tile.toString()],
    })
        .then((value) => true)
        .catchError((e) {
      errorsController.showGenericError(e);
      return false;
    });
  }

  Future<bool> joinToAMatch() {
    matchMakingController = Get.find<MatchMakingController>();
    print('id: ${matchMakingController.gameId.value}');
    return _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value)
        .update({
      MatchDom.INVITEDPLAYERID: authController.googleAccount.value!.id,
      MatchDom.STATE: gameState.playing.name,
    }).then((value) {
      return true;
    }).catchError((e) {
      errorsController.showGenericError(e);
      return false;
    });
  }

  Future<bool> createNewUser(User user) async {
    try {
      await _firestore.collection("users").doc().set({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "photoUrl": user.photoUrl,
        "score": user.score,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection("users").doc(uid).get();
      return User.fromDocStanpshot(doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> getUserByUserId(String uid) async {
    print('tryin to get user uid: $uid');
    try {
      var docs =
      await _firestore.collection(collections.users.name).where(
          'id', isEqualTo: uid).get();
      if (docs.docs.isNotEmpty) {
        print(docs.docs[0].toString());
        return User.fromDocStanpshot(docs.docs[0]);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> getUserDocIByUserId(String uid) async {
    print('tryin to get user uid: $uid');
    try {
      var docs =
      await _firestore.collection(collections.users.name).where(
          'id', isEqualTo: uid).get();
      if (docs.docs.isNotEmpty) {
        return docs.docs[0].id;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  updateScore(int score) async {
    String? docId = await getUserDocIByUserId(authController.user.value!.id);
    if (docId != null){
      var docRef = _firestore
          .collection(collections.users.name)
          .doc(docId);
      await docRef.update({User.SCORE: score});
      authController.user.value!.score = score;
    }
  }

  updateProfilePic(String url) async {
    String? docId = await getUserDocIByUserId(authController.user.value!.id);
    if (docId != null){
      var docRef = _firestore
          .collection(collections.users.name)
          .doc(docId);
      await docRef.update({User.PHOTOURL: url});
      authController.user.value!.photoUrl = url;
    }
  }

  getCurrentMatch() {
    final Stream<DocumentSnapshot> _MatchDocumentSnapshot = _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value)
        .snapshots();

    _MatchDocumentSnapshot.listen((event) {
      print(event);
    });
  }

  @override
  void onInit() {
    print('databasecontroller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('databasecontroller ready');
    // matchMakingController = Get.find<MatchMakingController>();
    authController = Get.find<AuthController>();
    errorsController = Get.find<ErrorsController>();
    // print(
    //     'controllers: $matchMakingController, $authController, $errorsController');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
