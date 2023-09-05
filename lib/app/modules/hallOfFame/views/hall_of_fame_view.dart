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

      children: ListTile.divideTiles(
        color: Colors.white38,
          tiles: snapshot.data!.docs.asMap().entries.map<Widget>((entry) {
        int idx = entry.key + 1;
        DocumentSnapshot document = entry.value;
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
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
          title: Text(data[User.NAME], style: const TextStyle(color: Colors.white70)),
          trailing: Text(data[User.SCORE].toString(), style: const TextStyle(color: Colors.white70)),
          subtitle: data[User.COUNTRYCODE] != null
              ? Text(data[User.COUNTRYCODE], style: const TextStyle(color: Colors.white70))
              : null,
        );
      }).toList() as List<Widget>).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      body: Stack(
        // alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/backgrounds/bg2.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              AppBar(
                elevation: 0,
                title: const Text(
                  'Hall of Fame',
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
            ],
          ),
        ],
      ),
      bottomNavigationBar: controller.localUsersStream.value == null
          ? null
          : Obx(() {
              return BottomNavigationBar(
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
                          controller.authController.user.value?.country ?? '',
                    ),
                  ]);
            }),
    );
  }
}
