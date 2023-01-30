import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hall_of_fame_controller.dart';

class HallOfFameView extends GetView<HallOfFameController> {
  const HallOfFameView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HallOfFameView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'HallOfFameView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
