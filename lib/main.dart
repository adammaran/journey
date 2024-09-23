import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/constants/api_constants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/routes/app_pages.dart';
import 'app/service/auth_service.dart';
import 'app/service/notification_service.dart';
import 'app/service/state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await intiHive();
  _initServices();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.black, primary: Colors.black)),
      title: "Journey",
      initialRoute: initPage(),
      getPages: AppPages.routes,
    ),
  );
}

Future intiHive() async {
  if (await Permission.storage.request().isGranted) {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init('${dir.path}/traveller');
    await BoxCollection.open('traveller', {ApiConstants.journey},
        path: '${dir.path}/traveller');
  }
}

String initPage() {
  if (FirebaseAuth.instance.currentUser != null) {
    Get.find<NotificationService>().waitForNotifications();
  }

  return FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified
      ? AppPages.INITIAL
      : AppPages.auth;
}

void _initServices() async {
  Get.put(StateService());
  Get.put(AuthService());
  Get.put(JourneyService());
  Get.put(NotificationService());
  await GetStorage.init();
}
