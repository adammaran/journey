import 'package:fishing_helper/app/models/notifications/notification_response.dart';
import 'package:fishing_helper/app/widgets/app_bar/secondary_app_bar.dart';
import 'package:fishing_helper/app/widgets/state/page_state.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import '../../../widgets/page_widget.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(label: 'Notifications'),
        body: PageWidget(
            child: Obx(() => controller.notificationService.state.value ==
                    PageState.loading
                ? LoadingState()
                : controller.notificationService.state.value == PageState.empty
                    ? _buildEmptyState()
                    : _buildSuccessState())));
  }

  Center _buildEmptyState() => const Center(
        child: Text(
          'You don\'t have any notifications, yet',
          style: TextStyle(fontSize: 20),
        ),
      );

  Widget _buildSuccessState() => ListView.separated(
      shrinkWrap: true,
      itemBuilder: (_, index) => _buildNotificationTile(
          controller.notificationService.notifications.elementAt(index), index),
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemCount: controller.notificationService.notifications.length);

  Widget _buildNotificationTile(NotificationResponse notification, int index) =>
      InkWell(
          onTap: () {
            controller.goToJourney(notification.journeyId, index);
          },
          child: Obx(() => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: notification.isRead.value
                          ? Colors.grey
                          : Colors.black,
                      width: 2)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                          color: notification.isRead.value
                              ? Colors.grey
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    Text(
                      notification.description,
                      style: TextStyle(
                          color: notification.isRead.value
                              ? Colors.grey
                              : Colors.black),
                    )
                  ]))));
}
