import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../service/auth_service.dart';
import '../../../service/journey_service.dart';
import '../../../service/state_service.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.delete<NotificationService>(force: true);
    Get.delete<StateService>(force: true);
    Get.delete<JourneyService>(force: true);

    Get.offAndToNamed(AppPages.auth);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
