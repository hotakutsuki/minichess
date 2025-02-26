import 'package:inti_the_inka_chess_game/app/modules/home/controllers/home_controller.dart';

import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums.dart';
import '../../../utils/utils.dart';
import '../../language/controllers/language_controller.dart';

class CreditsView extends GetView {
  CreditsView({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final LanguageController l = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InkWell(
            onTap: () {
              Get.back();
              // Get.offNamed(Routes.HOME);
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l.g('Credits:'), style: const TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 30),
                Text(l.g('Game Design & Development:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                InkWell(child: Text(l.g('Josue Ortiz (Haku) 🔗'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  onTap: () {
                    homeController.goToUrl('https://www.linkedin.com/in/josue-ortiz-developer/');
                  },
                ),
                const SizedBox(height: 20),
                Text(l.g('Illustrations & Graphic Design:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                InkWell(child: Text(l.g('Jonathan Nuo 🔗'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  onTap: () {
                    homeController.goToUrl('https://www.instagram.com/nuomation/');
                  },
                ),
                const SizedBox(height: 20),
                Text(l.g('Lore & Texts:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                InkWell(child: Text(l.g('Lilia Escudero 🔗'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  onTap: () {
                    homeController.goToUrl('https://www.instagram.com/lilibelula_esc/');
                  },
                ),
                const SizedBox(height: 20),
                Text(l.g('Voice Talents:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                Text(l.g('Liisa Bäumler (English)'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                Text(l.g('Paola Ortiz (Spanish)'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                Text(l.g('Emily Guajan (Kichwa)'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 5),
                Text(l.g('The Flutter Community'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 20),
                Text(l.g('Powered by:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                Text(l.g('GetX & Flutter'), style: const TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 20),
                Text(l.g('Version:'), style: const TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),
                Text(l.g('1.1.0'), style: const TextStyle(fontSize: 16, color: Colors.white)),
              ],
            )
          ),
        ],
      ),
    );
  }
}
