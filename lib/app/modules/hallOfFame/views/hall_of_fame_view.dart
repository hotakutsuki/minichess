import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/userDom.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/gameObjects/BackgroundController.dart';
import '../../language/controllers/language_controller.dart';
import '../controllers/hall_of_fame_controller.dart';

class HallOfFameView extends GetView<HallOfFameController> {
  HallOfFameView({Key? key}) : super(key: key);
  BackgroundController backgroundController = Get.find<BackgroundController>();
  LanguageController l = Get.find<LanguageController>();

  Widget stremBuilder(query) {
    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text(l.g('SomethingWentWrong')));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return getListView(snapshot);
      },
    );
  }

  ListView getListView(snapshot) {
    return ListView(
      children: ListTile.divideTiles(
              color: Colors.white38,
              tiles: snapshot.data!.docs.asMap().entries.map<Widget>((entry) {
                int idx = entry.key + 1;
                DocumentSnapshot document = entry.value;
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  tileColor: Colors.white10,
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (idx == 1)
                        const Icon(Icons.star_rounded,
                            color: Colors.amberAccent, size: 50),
                      SizedBox(
                        width: 50,
                        child: Text(
                          idx.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  title: Text(data[User.NAME],
                      style: const TextStyle(color: Colors.white70)),
                  trailing: Text(data[User.SCORE].toString(),
                      style: const TextStyle(color: Colors.white70)),
                  subtitle: data[User.COUNTRYCODE] != null
                      ? Text(data[User.COUNTRYCODE],
                          style: const TextStyle(color: Colors.white70))
                      : null,
                );
              }).toList() as List<Widget>)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      body: Stack(
        // alignment: Alignment.center,
        children: [
          backgroundController.backGround(context),
          Column(
            children: [
              AppBar(
                elevation: 0,
                title: Text(
                  l.g('HallOfFame'),
                  style: TextStyle(color: Colors.white70),
                ),
                backgroundColor: Colors.white10,
                centerTitle: true,
                actions: [
                  FloatingActionButton(
                    elevation: 0,
                    heroTag: 'close',
                    mini: true,
                    onPressed: () => Get.offAndToNamed(Routes.HOME),
                    child: const Icon(Icons.close, color: Colors.white60),
                  )
                ],
              ),
              Expanded(
                child: PageView(
                    controller: controller.pageViewController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      stremBuilder(controller.globalUsersStream),
                      stremBuilder(controller.localUsersStream.value),
                    ]),
              ),
              if (controller.localUsersStream.value != null)
                Obx(() {
                  return BottomNavigationBar(
                      unselectedItemColor: Colors.white60,
                      selectedItemColor: Colors.white,
                      backgroundColor: Colors.white10,
                      currentIndex: controller.pageIdx.value,
                      onTap: controller.changePage,
                      items: [
                        const BottomNavigationBarItem(
                          icon: Icon(Icons.public),
                          label: 'World',
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.location_on),
                          label:
                              controller.authController.user.value?.country ??
                                  '',
                        ),
                      ]);
                }),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: controller.localUsersStream.value == null
      //     ? null
      //     : Obx(() {
      //         return BottomNavigationBar(
      //             // unselectedLabelStyle: const TextStyle(color: Colors.white, fontSize: 14),
      //             // fixedColor: Colors.white,
      //             unselectedItemColor: Colors.white,
      //           backgroundColor: Colors.white10,
      //             currentIndex: controller.pageIdx.value,
      //             onTap: controller.changePage,
      //             items: [
      //               const BottomNavigationBarItem(
      //                 icon: Icon(Icons.public, color: Colors.white),
      //                 label: 'World',
      //
      //               ),
      //               BottomNavigationBarItem(
      //                 icon: const Icon(Icons.location_on, color: Colors.white),
      //                 label:
      //                     controller.authController.user.value?.country ?? '',
      //               ),
      //             ]);
      //       }),
    );
  }
}
