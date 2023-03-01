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
    var newMatch = MatchDom.noGuest(
      matchMakingController.gameId.value,
      gameState.open,
      tiles,
      authController.googleAccount.value!.id.toString(),
    ).toMap();
    return docRef.set(newMatch).then((value) {
      return true;
    }).catchError((error) {
      print("Failed to start match: $error");
      errorsController.showGenericError(error.toString());
      return false;
    });
  }

  void closeMatch() {
    documentStream = null;
    var docRef = _firestore
        .collection(collections.matches.name)
        .doc(matchMakingController.gameId.value);
    docRef.update({MatchDom.STATE: gameState.finished.name});
  }

  startListenersOfMatch() {
    matchController = Get.find<MatchController>();

    if (documentStream == null) {
      documentStream = FirebaseFirestore.instance
          .collection(collections.matches.name)
          .doc(matchMakingController.gameId.value)
          .snapshots();
      documentStream!
          .listen((event) => matchController!.whenMatchStateChange(event));
    }
  }

  Future<bool> addPlayedTile(Tile tile) {
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
      await _firestore.collection(collections.users.name).doc().set({
        User.ID: user.id,
        User.NAME: user.name,
        User.EMAIL: user.email,
        User.PHOTOURL: user.photoUrl,
        User.SCORE: user.score,
        User.COUNTRY: user.country,
        User.COUNTRYCODE: user.countryCode,
        User.CITY: user.city,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();
      if (doc.data() != null) {
        return User.fromDocStanpshot(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> getUserByUserId(String uid) async {
    try {
      var docs = await _firestore
          .collection(collections.users.name)
          .where(User.ID, isEqualTo: uid)
          .get();
      if (docs.docs.isNotEmpty) {
        return User.fromDocStanpshot(docs.docs[0].data());
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> getUserDocIByUserId(String uid) async {
    try {
      var docs = await _firestore
          .collection(collections.users.name)
          .where(User.ID, isEqualTo: uid)
          .get();
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
    if (docId != null) {
      var docRef = _firestore.collection(collections.users.name).doc(docId);
      await docRef.update({User.SCORE: score});
      authController.user.value!.score = score;
    }
  }

  updateInfo(photoUrl, country, countryCode, city) async {
    String? docId = await getUserDocIByUserId(authController.user.value!.id);
    if (docId != null) {
      var docRef = _firestore.collection(collections.users.name).doc(docId);
      await docRef.update({
        User.PHOTOURL: photoUrl,
        User.COUNTRY: country,
        User.COUNTRYCODE: countryCode,
        User.CITY: city,
      });
      authController.user.value!.photoUrl = photoUrl;
      authController.user.value!.country = country;
      authController.user.value!.countryCode = countryCode;
      authController.user.value!.city = city;
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
    super.onInit();
  }

  @override
  void onReady() {
    authController = Get.find<AuthController>();
    errorsController = Get.find<ErrorsController>();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
