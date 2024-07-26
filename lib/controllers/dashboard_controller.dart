import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void onInit() {
    super.onInit();
    sideMenu.addListener((int index) {
      pageController.jumpToPage(index);
    });
  }
}
