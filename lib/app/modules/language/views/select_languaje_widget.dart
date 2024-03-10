import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../controllers/language_controller.dart';
import '../../../data/enums.dart';

Widget LanguageSelectionWidget(){
  LanguageController l = Get.find<LanguageController>();

  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(() =>
            ToggleButtons(
              isSelected: [
                l.language.value == languages.en,
                l.language.value == languages.es,
                l.language.value == languages.ki,
              ],
              onPressed: (index) {
                l.setLanguage(
                    index == 0 ? languages.en : index == 1 ? languages.es : languages.ki);
              },
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0),
                    child: const Text('English')
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0),
                    child: const Text('Español')),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 0),
                    child: const Text('Kichwa')),
              ],
            )),
      ]);
}