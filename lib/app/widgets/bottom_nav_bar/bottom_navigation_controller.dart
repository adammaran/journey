import 'package:fishing_helper/app/models/notifications/notification_response.dart';
import 'package:fishing_helper/app/modules/profile/views/profile_view.dart';
import 'package:fishing_helper/app/routes/app_pages.dart';
import 'package:fishing_helper/app/service/notification_service.dart';
import 'package:fishing_helper/app/service/state_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  StateService state = Get.find<StateService>();

  void changeScreen(int index) {
    state.navIndex.value = index;
    goToScreen(index);
  }

  void goToScreen(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(AppPages.INITIAL);
        break;
      case 1:
        Get.toNamed(AppPages.notifications);
        break;
      case 2:
        Get.offAllNamed(AppPages.profile);
        break;
    }
  }

  bool hasNewNotification() {
    for (NotificationResponse hasNew
        in Get.find<NotificationService>().notifications) {
      if (!hasNew.isRead.value) {
        return true;
      }
    }
    return false;
  }
}
