import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../language/controllers/language_controller.dart';

class ErrorsViews{
  static Widget getErrorWidget([String? err]){
    LanguageController l = Get.find<LanguageController>();
    return Text(err ?? l.g('ThereWasAnUnkownError'));
  }
}
