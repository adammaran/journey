import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/app/service/notification_service.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../models/journey/journey_model.dart';
import '../../../routes/app_pages.dart';

class NotificationsController extends GetxController {
  NotificationService notificationService = Get.find<NotificationService>();
  JourneyService journeyService = Get.find<JourneyService>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void goToJourney(String journeyId, int index) async {
    notificationService.notifications.elementAt(index).isRead.value = true;
    notificationService.setIsRead(
        notificationService.notifications.elementAt(index).notificationId);
    Journey? journey = (await journeyService.getJourneyById(journeyId)).journey;
    debugPrint(journey.toString());
    if (journey?.journeyId != null) {
      Get.toNamed(AppPages.journeyDetails, arguments:{'journey': journey, 'isUploaded': false});
    } else {
      Get.snackbar('Info', 'The owner deleted this journey');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
