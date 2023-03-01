import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:minichess/app/data/enums.dart';
import 'package:minichess/app/modules/auth/controllers/auth_controller.dart';
import 'package:minichess/app/services/database.dart';

import '../../../data/userDom.dart';

class HallOfFameController extends GetxController {
  var pageIdx = 0.obs;
  var pageViewController = PageController(
    initialPage: 0,

  );
  DatabaseController dbController = Get.find<DatabaseController>();
  AuthController authController = Get.find<AuthController>();
  late Stream<QuerySnapshot> globalUsersStream = FirebaseFirestore.instance
      .collection(collections.users.name)
      .orderBy(User.SCORE, descending: true)
      .snapshots();
  Rxn<Stream<QuerySnapshot>> localUsersStream =
      Rxn<Stream<QuerySnapshot>>(null);

  @override
  void onInit() {
    if (authController.user.value != null) {
      print('authController.user.value ${authController.user.value}');
      localUsersStream.value = FirebaseFirestore.instance
          .collection(collections.users.name)
          .where(User.COUNTRYCODE,
              isEqualTo: authController.user.value!.countryCode)
          .orderBy(User.SCORE, descending: true)
          .snapshots();
    }
    super.onInit();
  }

  changePage(int page) {
    pageIdx.value = page;
    pageViewController.animateToPage(
      page,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 100),
    );
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
