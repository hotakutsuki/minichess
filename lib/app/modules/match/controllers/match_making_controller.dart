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
    super.onClose();
  }
}
