import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minichess/screens/HallOfFame.dart';
import 'package:minichess/widgets/ChessGame.dart';
import 'package:minichess/utils/LoginController.dart';
import '../utils/Enums.dart';
import 'Tutorial.dart';

class HomeScreen extends StatelessWidget {
  setMode(context, gameMode mode) {
    Get.to(ChessGame(gamemode: mode));
  }

  final controller = Get.put(LoginController());
  CollectionReference matches = FirebaseFirestore.instance.collection('users');

  addMatch() async {
    try {
      return await matches
          .add({'player1': 'player1', 'player2': 'player2', 'moves': []});
    } catch (error) {
      Get.snackbar(
        'title',
        "Failed to add user: $error",
      );
    }
  }

  void checkLogin(context) {
    if (controller.googleAccount.value == null) {
      showDialog(
        context: context,
        builder: (_) => buildDialog(context),
        barrierDismissible: true,
      );
    } else {
      startNewMatch(context);
    }
  }

  startNewMatch(context){
    setMode(context, gameMode.online);
    addMatch();
  }

  Widget buildLoginButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Login"),
            IconButton(
                onPressed: () => Get.back(closeOverlays: true),
                icon: const Icon(Icons.close))
          ],
        ),
        const Text('We need you to login in order to establish your score'),
        FloatingActionButton.extended(
          icon: Image.asset(
            'assets/images/glogo.png',
            height: 25,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          label: const Text('Login with google'),
          onPressed: () => controller.login(),
        ),
        const Divider(
          color: Colors.transparent,
        ),
      ],
    );
  }

  Widget buildProfileView(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Divider(color: Colors.transparent),
        CircleAvatar(
          backgroundImage:
              Image.network(controller.googleAccount.value?.photoUrl ?? '')
                  .image,
          radius: 75,
        ),
        const Divider(color: Colors.transparent),
        Text(controller.googleAccount.value?.displayName ?? ''),
        Text(controller.googleAccount.value?.email ?? ''),
        const Divider(color: Colors.transparent),
        ElevatedButton(
            onPressed: () => startNewMatch(context),
            child: const Text("Start Match")),
        const Divider(color: Colors.transparent),
        OutlinedButton(
            onPressed: () => controller.logout(), child: const Text("logout")),
      ],
    );
  }

  AlertDialog buildDialog(context) {
    return AlertDialog(
      content: SizedBox(
        height: 400,
        child: Obx(() {
          if (controller.googleAccount.value == null) {
            return buildLoginButton();
          } else {
            return buildProfileView(context);
          }
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Minichess',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 200,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => setMode(context, gameMode.solo),
                      child: const Text(
                        'Vs PC',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => setMode(context, gameMode.vs),
                      child: const Text(
                        '2 players',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () => checkLogin(context),
                      child: const Text(
                        'Multiplayer online',
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   width: 150,
                  //   child: ElevatedButton(
                  //     onPressed: () => setMode(context, gameMode.training),
                  //     child: const Text(
                  //       'Training',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 180,
        child: Column(
          children: [
            FloatingActionButton(
                heroTag: 'records',
                child: const Icon(Icons.stacked_bar_chart),
                onPressed: () {
                  Get.to(HallOfFame());
                }),
            const SizedBox(
              height: 12,
            ),
            FloatingActionButton(
                heroTag: 'tutorial',
                child: const Icon(CupertinoIcons.question),
                onPressed: () {
                  Get.to(const Tutorial());
                }),
            const Text('Tutorial'),
          ],
        ),
      ),
    );
  }
}
