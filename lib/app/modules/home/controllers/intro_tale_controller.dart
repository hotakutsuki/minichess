import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/enums.dart';
import '../../language/controllers/language_controller.dart';
import 'home_controller.dart';

class IntroTaleController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();
  LanguageController l = Get.find<LanguageController>();
  final pages = <TalePage>[].obs;

  var pageController = PageController(
    initialPage: 0,
  );

  var diablePrev = true.obs;
  var disableNext = false.obs;

  hideTale() async {
    homeController.showTale.value = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sharedPrefs.showTale.name, false);
    pageController.jumpToPage(0);
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

  Widget getPageText(String text, [double width=400, double height=110]) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
            )],
        ),
          child: Center(child: Text(l.g(text), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w300)))),
    );
  }

  @override
  void onReady() async {
    super.onReady();
    pages.value = [TalePage(title: 'page1', layers: [
    TaleLayer(asset: Image.asset('assets/images/tale/page1/1.png', fit: BoxFit.cover),
    ltrb: [0, 0, 0, 0], delay: 300, showing: false.obs,),
    TaleLayer(asset: Image.asset('assets/images/tale/page1/2.jpeg', fit: BoxFit.cover),
    ltrb: [50, 200, 50, 300], delay: 400, showing: false.obs,),
    TaleLayer(asset: Image.asset('assets/images/tale/page1/3.png', fit: BoxFit.cover),
    ltrb: [0, 300, 0, 0], delay: 500, showing: false.obs,),
    TaleLayer(asset: getPageText('Page1', 450),
    ltrb: [100, 50, 50, 0], delay: 600, showing: false.obs,)]),
      TalePage(title: 'page2', layers: [
        TaleLayer(asset: const Placeholder(color: Colors.red,),
          ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
        TaleLayer(asset: const Placeholder(color: Colors.red,),
          ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
        TaleLayer(asset: const Placeholder(color: Colors.red,),
          ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
        TaleLayer(asset: getPageText('Page2'),
          ltrb: [150, 500, 50, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page3', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [120, 200, 80, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page3'),
              ltrb: [120, 100, 80, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page4', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page4'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page5', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page5', 500),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page6', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page6'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page7', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page7', 450),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page8', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page8'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page9', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page9', 600),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page10', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page10'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page11', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page11'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page12', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page12'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page13', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page13'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page14', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page14'),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
      TalePage(title: 'page15', layers: [
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [10, 10, 10, 10], delay: 300, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [50, 500, 100, 50], delay: 400, showing: false.obs,),
            TaleLayer(asset: const Placeholder(color: Colors.red,),
              ltrb: [200, 200, 200, 200], delay: 500, showing: false.obs,),
            TaleLayer(asset: getPageText('Page15', 450, 150),
              ltrb: [20, 200, 150, 50], delay: 600, showing: false.obs,),]),
    ];
    await Future.delayed(const Duration(milliseconds: 1000));
    handleOnPageChange(0);
  }

}

class TalePage {
  final String title;
  final List<TaleLayer> layers;

  TalePage({
    required this.title,
    required this.layers,
  });
}

class TaleLayer {
  final Widget asset;
  final List<double> ltrb;
  final double? width;
  final double? height;
  final int delay;
  final Rx<bool> showing;

  TaleLayer({
    required this.asset,
    required this.ltrb,
    this.width,
    this.height,
    required this.delay,
    required this.showing,
  });
}
