import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/enums.dart';
import '../../language/controllers/language_controller.dart';
import 'home_controller.dart';

class IntroTaleController extends GetxController with GetSingleTickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();
  LanguageController l = Get.find<LanguageController>();
  final pages = <TalePage>[].obs;
  late AnimationController aController = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(reverse: true);

  var pageController = PageController(
    initialPage: 0,
  );

  var diablePrev = true.obs;
  var disableNext = false.obs;

  final audioPlayer = AudioPlayer();
  void playButtonSound(int page) {
    audioPlayer.stop();
    if (homeController.withSound.value && homeController.showTale.value){
      String lang = l.language.value?.name == 'es' ? 'es' : 'en';
      String file = 'sounds/${lang}/${page+1}.mp3';
      audioPlayer.play(AssetSource(file), volume: 1);
    }
  }

  hideTale() async {
    audioPlayer.stop();
    homeController.showTale.value = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sharedPrefs.showTale.name, false);
    pageController.jumpToPage(0);
  }

  showTale() async {
    pageController = PageController(
      initialPage: 0,
    );
    homeController.showTale.value = true;
    handleOnPageChange(0);
  }

  void handleNextPage() {
    if (pageController.page == pages.length - 1) {
      hideTale();
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void handlePreviousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  void handleOnPageChange(int page) {
    playButtonSound(page);
    //switch off all shows
    for (var page in pages) {
      for (var layer in page.layers) {
        layer.showing.value = false;
      }
    }
    //switch on shows for current page
    for (var layer in (pages[page].layers)) {
      Future.delayed(Duration(milliseconds: layer.delay), () {
        layer.showing.value = true;
      });
    }

    diablePrev.value = page == 0;
    disableNext.value = page == pages.length - 1;
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 1000));
    pages.value = [TalePage(title: 'page1', text: l.g('Page1'), layers: [
    TaleLayer(asset: Image.asset('assets/images/tale/SC1/Ink-Lore_BG4-01.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/Ink-Lore_BG3-01.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/Ink-Lore_BG2-01.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/Ink-Lore_BG1-01.png', fit: BoxFit.fitHeight),
        hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/Ink-Lore_CH-01.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),]),

      TalePage(title: 'page2', text: l.g('Page2'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/Ink-Lore_BG4-02.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/Ink-Lore_BG3-02.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/Ink-Lore_BG1-02.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC2/Ink-Lore_CH-02.png', fit: BoxFit.fitHeight),
        hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),]),

      TalePage(title: 'page3', text: l.g('Page3'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/Ink-Lore_BG4-03.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/Ink-Lore_BG3-03.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/Ink-Lore_BG2-03.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/Ink-Lore_BG1-03.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/Ink-Lore_CH-03.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page4', text: l.g('Page4'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/Ink-Lore_BG4-04.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/Ink-Lore_BG3-04.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/Ink-Lore_BG2-04.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/Ink-Lore_BG1-04.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/Ink-Lore_CH-04.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page5', text: l.g('Page5'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/Ink-Lore_BG4-05.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/Ink-Lore_BG3-05.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/Ink-Lore_BG2-05.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/Ink-Lore_BG1-05.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/Ink-Lore_CH-05.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page6', text: l.g('Page6'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/Ink-Lore_BG4-06.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/Ink-Lore_BG3-06.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/Ink-Lore_BG2-06.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/Ink-Lore_BG1-06.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/Ink-Lore_CH-06.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,)]),

      TalePage(title: 'page7', text: l.g('Page7'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/Ink-Lore_BG4-07.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/Ink-Lore_BG3-07.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/Ink-Lore_CH-07.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page8', text: l.g('Page8'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/Ink-Lore_BG4-08.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/Ink-Lore_BG3-08.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/Ink-Lore_CH-08.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page9', text: l.g('Page9'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/Ink-Lore_BG4-09.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/Ink-Lore_BG3-09.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/Ink-Lore_BG2-09.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/Ink-Lore_BG1-09.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,)]),

      TalePage(title: 'page10', text: l.g('Page10'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC10/Ink-Lore_BG4-10.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC10/Ink-Lore_CH-10.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 400, showing: false.obs,)]),

      // TalePage(title: 'page11', text: l.g('Page11'), layers: [
      //   TaleLayer(asset: Image.asset('assets/images/tale/page11/1.png', fit: BoxFit.fitHeight),
      //         hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [50, 500, 100, 50], delay: 400, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [200, 200, 200, 200], delay: 500, showing: false.obs,)]),
      // TalePage(title: 'page12', text: l.g('Page12'), layers: [
      //   TaleLayer(asset: Image.asset('assets/images/tale/page12/1.png', fit: BoxFit.fitHeight),
      //         hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [50, 500, 100, 50], delay: 400, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [200, 200, 200, 200], delay: 500, showing: false.obs,)]),
      // TalePage(title: 'page13', text: l.g('Page13'), layers: [
      //   TaleLayer(asset: Image.asset('assets/images/tale/page13/1.png', fit: BoxFit.fitHeight),
      //         hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [50, 500, 100, 50], delay: 400, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [200, 200, 200, 200], delay: 500, showing: false.obs,)]),
      // TalePage(title: 'page14', text: l.g('Page14'), layers: [
      //   TaleLayer(asset: Image.asset('assets/images/tale/page14/1.png', fit: BoxFit.fitHeight),
      //         hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [50, 500, 100, 50], delay: 400, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [200, 200, 200, 200], delay: 500, showing: false.obs,)]),
      // TalePage(title: 'page15', text: l.g('Page15'), layers: [
      //   TaleLayer(asset: Image.asset('assets/images/tale/page15/1.png', fit: BoxFit.fitHeight),
      //         hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [50, 500, 100, 50], delay: 400, showing: false.obs,),
      //   TaleLayer(asset: const Placeholder(color: Colors.black38,),
      //         hwxy: [200, 200, 200, 200], delay: 500, showing: false.obs,)]),
    ];
    handleOnPageChange(0);
  }

  @override
  void onClose() {
    print('closing');
    print(pageController);
    for (final page in pages) {
      for (final layer in page.layers) {
        layer.showing.close();
      }
    }
    pageController.dispose();
    super.onClose();
  }

}

class TalePage {
  final String title;
  final List<TaleLayer> layers;
  final String text;

  TalePage({
    required this.title,
    required this.layers,
    required this.text,
  });
}

class TaleLayer {
  final Widget asset;
  final List<double> hwxy; //height with x axis y axis
  final double? width;
  final double? height;
  final int delay;
  final Rx<bool> showing;

  TaleLayer({
    required this.asset,
    required this.hwxy,
    this.width,
    this.height,
    required this.delay,
    required this.showing,
  });
}
