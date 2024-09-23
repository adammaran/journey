import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/app/service/state_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/journey/journey_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/auth_service.dart';
import '../../../service/notification_service.dart';

class HomeController extends GetxController {
  RxBool loadingFavorite = RxBool(false);

  late List<HomeTileModel> tiles;
  late RxBool hasInternet;

  @override
  void onInit() {
    _initServices();
    hasInternet = Get.find<StateService>().hasInternet;
    tiles = [
      HomeTileModel(
          'My Journeys',
          () => Get.toNamed(AppPages.listJourneys, arguments: 'myJourneys'),
          const Icon(Icons.airplanemode_active, color: Colors.white, size: 42)),
      HomeTileModel(
          'Shared Journeys',
          () => Get.toNamed(AppPages.listJourneys, arguments: 'sharedWithMe'),
          const Icon(Icons.people, color: Colors.white, size: 42)),
      HomeTileModel('Create Journey', () => Get.toNamed(AppPages.createTravel),
          const Icon(Icons.add, color: Colors.white, size: 42)),
      HomeTileModel(
        'Last viewed',
        () {
          getLastViewedJourney();
        },
        const Icon(
          Icons.access_time_rounded,
          color: Colors.white,
          size: 42,
        ),
      ),
    ];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void getLastViewedJourney() async {
    loadingFavorite.value = true;
    Journey? journey = await Get.find<JourneyService>().getLastVisitedJourney();
    if (journey != null) {
      Get.toNamed(AppPages.journeyDetails,
          arguments: {'journey': journey, 'isUploaded': false});
    } else {
      Get.snackbar('Info', 'No journeys viewed');
    }
    loadingFavorite.value = false;
  }

  void _initServices() async {
    Get.put(StateService());
    Get.put(AuthService());
    Get.put(JourneyService());
    Get.put(NotificationService());
  }
}

class HomeTileModel {
  String title;
  Function() onTap;
  Icon icon;

  HomeTileModel(this.title, this.onTap, this.icon);
}
