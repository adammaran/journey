import 'package:fishing_helper/app/cloud/notifications_api.dart';
import 'package:fishing_helper/app/models/notifications/notification_response.dart';
import 'package:fishing_helper/app/service/state_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/page_widget.dart';

class NotificationService extends GetxService {
  Rx<PageState> state = PageState.loading.obs;

  final NotificationApi _api = NotificationApi();

  RxList<NotificationResponse> notifications = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  void sendNotification(List<String> uids, String journeyId, String journeyName) {
    _api.sendNotification(uids, journeyId, journeyName);
  }

  void getNotifications() async {
    notifications.value = await _api.getNotifications();
    if (notifications.isEmpty) {
      state.value = PageState.empty;
    } else {
      state.value = PageState.success;
    }
  }

  void waitForNotifications() {
      _api.listenToNotifications().listen((event) {
        notifications.clear();
        getNotifications();
      });
  }

  void setIsRead(String notificationId) {
    _api.setIsRead(notificationId);
  }
}
