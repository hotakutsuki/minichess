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
      String lang = l.language.value?.name == languages.es.name ? 'es'
          : l.language.value?.name == languages.ki.name ? 'ki'
          : 'en';
      String file = 'sounds/${lang}/${page+1}.mp3';
      print('playing $file');
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
    pages.value = [TalePage(title: 'page1', text: 'Page1', layers: [
    TaleLayer(asset: Image.asset('assets/images/tale/SC1/bg4.png', fit: BoxFit.cover),
    hwxy: [0, 0, 0, 0], delay: 900, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/bg3.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/bg2.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/bg1.png', fit: BoxFit.fitHeight),
        hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC1/ch.png', fit: BoxFit.fitHeight),
    hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,),]),

      TalePage(title: 'page2', text: 'Page2', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/bg4.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/bg3.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC2/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
      TaleLayer(asset: Image.asset('assets/images/tale/SC2/bg1.png', fit: BoxFit.fitHeight),
        hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,),]),

      TalePage(title: 'page3', text: 'Page3', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 900, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/bg3.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC3/bg1.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,)]),

      TalePage(title: 'page4', text: 'Page4', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 900, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/bg3.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/bg1.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC4/ch.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page5', text: 'Page5', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 900, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/bg3.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/bg1.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC5/ch.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page6', text: 'Page6', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 900, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/bg3.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/bg1.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC6/ch.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page7', text: 'Page7', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/bg3.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC7/bg1.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page8', text: 'Page8', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/bg3.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC8/bg1.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page9', text: l.g('Page9'), layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg4.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg3.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg1.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),

      TalePage(title: 'page10', text: 'Page10', layers: [
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg4.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 700, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg3.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 500, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg2.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 300, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC9/bg1.png', fit: BoxFit.fitHeight),
          hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,),
        TaleLayer(asset: Image.asset('assets/images/tale/SC10/ch.png', fit: BoxFit.fitHeight),
              hwxy: [0, 0, 0, 0], delay: 100, showing: false.obs,)]),
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
