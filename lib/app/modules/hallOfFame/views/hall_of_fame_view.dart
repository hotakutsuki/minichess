import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/userDom.dart';
import '../../../routes/app_pages.dart';
import '../controllers/hall_of_fame_controller.dart';

class HallOfFameView extends GetView<HallOfFameController> {
  const HallOfFameView({Key? key}) : super(key: key);

  Widget stremBuilder(query) {
    return StreamBuilder<QuerySnapshot>(
      stream: query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Something went wrong'));
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
      children: snapshot.data!.docs.asMap().entries.map<Widget>((entry) {
        int idx = entry.key + 1;
        DocumentSnapshot document = entry.value;
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ListTile(
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
          title: Text(data[User.NAME]),
          trailing: Text(data[User.SCORE].toString()),
          subtitle: data[User.COUNTRYCODE] != null
              ? Text(data[User.COUNTRYCODE])
              : null,
        );
      }).toList() as List<Widget>,
    );
  }

  // List<Widget> getPages(){
  //   List<Widget> list = ;
  //   // if (controller.localUsersStream.value != null){
  //   //   list.add(stremBuilder(controller.localUsersStream.value));
  //   // }
  //   return list;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hall of Fame',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          FloatingActionButton(
            elevation: 0,
            heroTag: 'close',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () => Get.offAndToNamed(Routes.HOME),
            child: const Icon(Icons.close, color: Colors.black87),
          )
        ],
      ),
      body: PageView(
          controller: controller.pageViewController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            stremBuilder(controller.globalUsersStream),
            stremBuilder(controller.localUsersStream.value),
          ]),
      bottomNavigationBar: controller.localUsersStream.value == null
          ? null
          : Obx(() {
              return BottomNavigationBar(
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
                          controller.authController.user.value?.country ?? '',
                    ),
                  ]);
            }),
    );
  }
}
