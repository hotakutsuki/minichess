import 'package:minichess/app/services/database.dart';
import '../../../data/enums.dart';
import 'package:get/get.dart';
import '../../../data/matchDom.dart';
import '../../home/controllers/home_controller.dart';

class MatchMakingController extends GetxController {
  final homeController = Get.find<HomeController>();
  final dbController = Get.find<DatabaseController>();
  final gameId = ''.obs;
  final isHost = Rxn<bool>();
  Rx<bool> searching = false.obs;
  Rxn<bool> isWinner = Rxn<bool>();
  Rxn<int> myLocalScore = Rxn<int>();
  Rxn<int> change = Rxn<int>();

  void startMatch() async {
    List<MatchDom> openMatches = await dbController.getOpenMatches();
    print('openMatches $openMatches');
    if (openMatches.isEmpty) {
      print('creating new match');
      isHost.value = true;
      var result = await dbController.addMatch();
      print('result $result');
      if (result) {
        homeController.setMode(gameMode.online);
      }
    } else {
      gameId.value = openMatches[0].id;
      print('joining to match ${gameId.value}');
      isHost.value = false;
      var result = await dbController.joinToAMatch();
      print('result $result');
      if (result) {
        homeController.setMode(gameMode.online);
      }
    }
  }

  void updateScore(bool imWinner, myScore, oponentScore) {
    //TODO:Enhance this
    print('isWinner: $imWinner');
    print('myScore: $myScore');
    print('oponentScore: $oponentScore');
    bool imBetter = myScore > oponentScore;
    double ratio = 1;
    if (imWinner && imBetter) {
      ratio = oponentScore / myScore; // lit/big = little
    }
    if (!imWinner && !imBetter) {
      ratio = myScore / oponentScore; // lit/big = little
    }
    if (imWinner && !imBetter) {
      ratio = oponentScore / myScore; // big/lit = big
    }
    if (!imWinner && imBetter) {
      ratio = myScore / oponentScore; // big/lit = big
    }
    isWinner.value = imWinner;
    myLocalScore.value = myScore;
    change.value = (100 * ratio).round();
    int newScore = imWinner ? myScore + change.value : myScore - change.value;
    print('radio: $ratio, change: ${change.value}');
    dbController.updateScore(newScore);
  }

  @override
  void onInit() {
    print('initing match making controller');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    print('closing match making controller');
    super.onClose();
  }
}
