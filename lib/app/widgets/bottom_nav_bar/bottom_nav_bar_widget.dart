import 'package:fishing_helper/app/widgets/bottom_nav_bar/bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomActionBarWidget extends GetView<BottomNavigationController> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BottomNavigationController());
    return Obx(
      () => BottomNavigationBar(
          onTap: (index) {
            controller.changeScreen(index);
          },
          selectedItemColor: Colors.black,
          currentIndex: controller.state.navIndex.value,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Stack(alignment: Alignment.center, children: [
                  const Icon(Icons.notifications),
                  controller.hasNewNotification()
                      ? Positioned(
                          left: 12,
                          bottom: 12,
                          child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16))))
                      : const SizedBox.shrink()
                ]),
                label: 'Notifcations'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile')
          ]),
    );
  }
}
