import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:minichess/app/data/enums.dart';
import 'package:minichess/app/modules/errors/controllers/errors_controller.dart';
import 'package:minichess/app/modules/match/controllers/match_making_controller.dart';

import '../data/matchDom.dart';
import '../data/userDom.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../utils/gameObjects/move.dart';

class DatabaseController extends GetxController {
  late final AuthController authController;
  late final MatchMakingController matchMakingController;
  late final ErrorsController errorsController;
  late final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    List<Move>moves = [];
    print(
        'adding match ${authController.googleAccount.value!.id}, ${gameState.open.name}');
    var docRef = _firestore.collection(collections.matches.name).doc();
    var asd = MatchDom.nameNoGuest(
      id: docRef.id,
      state: gameState.open,
      hostPlayerId: authController.googleAccount.value!.id.toString(),
      moves: moves,
    ).toMap();
    print('Match: $asd');
    return docRef.set(asd)
        // return _firestore
        //     .collection(collections.matches.name)
        //     .add(asd)
        .then((value) {
      // matchMakingController.gameId.value = value.id;
      print("Match added starting...");
      return true;
    }).catchError((error) {
      print("Failed to start match: $error");
      errorsController.showGenericError(error.toString());
      return false;
    });
  }

  Future<bool> joinToAMatch() {
    print('id: ${matchMakingController.gameId.value}');
    return _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value)
        .update({
          MatchDom.INVITEDPLAYERID: authController.googleAccount.value!.id,
          MatchDom.STATE: gameState.playing.name,
        })
        .then((value) => true)
        .catchError((e) {
          errorsController.showGenericError(e);
          return false;
        });
  }

  Future<bool> createNewUser(User user) async {
    try {
      await _firestore.collection("users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
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
    matchMakingController = Get.find<MatchMakingController>();
    authController = Get.find<AuthController>();
    errorsController = Get.find<ErrorsController>();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
