import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fishing_helper/app/cloud/journey_cloud_api.dart';
import 'package:fishing_helper/app/models/journey/accommodation_model.dart';
import 'package:fishing_helper/app/models/journey/response/confirmation_response.dart';
import 'package:fishing_helper/app/models/journey/wrapper_model/journey_wrapper_model.dart';
import 'package:fishing_helper/app/service/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../database/journey/journey_repository.dart';
import '../models/journey/journey_model.dart';
import '../models/journey/transportation_model.dart';

class JourneyService extends GetxService {
  late JourneyRepository journeyApi;
  late JourneyCloudApi journeyCloudApi;

  RxList<Journey> journeys = RxList.empty();
  RxList<Journey> downloadedJourneys = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    journeyApi = JourneyRepository();
    journeyCloudApi = JourneyCloudApi();
  }

  Future<ConfirmationResponse> addJourney(Journey journey) async =>
      await journeyApi.addJourney(journey);

  Future<void> getMyJourneys() async {
    downloadedJourneys.clear();
    List<Journey> res = await journeyApi.getJourneys();
    downloadedJourneys.value = res;
  }

  Future<ConfirmationResponse> addSharedJourneyToLocal(Journey journey) async =>
      await journeyApi.addSharedJourneyToLocal(journey);

  Future<void> getLocalSharedJourneys() async {
    try {
      downloadedJourneys.value = await journeyApi.getLocalSharedJourneys();
    } catch (e) {
      debugPrint('getLocalSharedJourneys() error: $e');
    }
  }

  Future<ConfirmationResponse> deleteJourney(String journeyId) async =>
      journeyApi.deleteJourney(journeyId);

  Future<ConfirmationResponse> deleteJourneyFromCloud(String journeyId) async =>
      journeyCloudApi.removeJourney(journeyId);

  Future<ConfirmationResponse> deleteSharedJourney(String journeyId) async =>
      journeyApi.deleteSharedJourney(journeyId);

  Future<ConfirmationResponse> uploadJourney(Journey journey) async {
    ConfirmationResponse res = await journeyCloudApi.uploadJourney(journey);
    // if (res.code == '200') {
    //   for (Transportation trans in journey.transportations ?? []) {
    //     if (trans.filePath != null || trans.filePath!.isNotEmpty) {
    //       await uploadFileToStorage(journey.journeyId ?? '', trans.filePath!);
    //     }
    //   }
    //
    //   for (Accommodation accomm in journey.accommodations ?? []) {
    //     if (accomm.filePath != null || accomm.filePath!.isNotEmpty) {
    //       await uploadFileToStorage(journey.journeyId ?? '', accomm.filePath!);
    //     }
    //   }
    // }

    return res;
  }

  void updateJourneyInDB(Journey journey) {
    journeyApi.updateJourneyInDB(journey);
  }

  Future<JourneyWrapperModel> getJourneyById(String journeyId) async {
    try {
      return await journeyCloudApi.getJourneyById(journeyId);
    } catch (e) {
      debugPrint('getJourneyById() error: $e');
      return JourneyWrapperModel('400', 'Error getting journey');
    }
  }

  Future<ConfirmationResponse> shareJourney(
      List<String> uids, Journey journey) async {
    ConfirmationResponse res = await journeyCloudApi.shareJourney(
        uids, journey.journeyId ?? '', journey.journeyName ?? '');
    if (res.code == '200') {
      Get.find<NotificationService>().sendNotification(
          uids, journey.journeyId ?? '', journey.journeyName ?? '');
    }
    return res;
  }

  Future<void> getSharedJourneys() async {
    List<Journey> filteredJourneys = [];
    getLocalSharedJourneys();
    for (Journey j in await journeyCloudApi.getSharedJourneys()) {
      if (downloadedJourneys.firstWhereOrNull(
              (element) => element.journeyId == j.journeyId) ==
          null) {
        filteredJourneys.add(j);
      }
    }
    journeys.value = filteredJourneys;
  }

  void setLastVisitedJourney(String journeyId) {
    journeyApi.setLastVisitedJourney(journeyId);
  }

  Future<Journey?>? getLastVisitedJourney() async {
    try {
      String lastJourneyId = getLastVisitedJourneyId();
      if (lastJourneyId.split('/').last == 'myJourney') {
        await getMyJourneys();
        Journey? journey;
        journey = downloadedJourneys.firstWhereOrNull(
            (element) => element.journeyId == lastJourneyId.split('/').first);
        journey ??= journeys.firstWhereOrNull(
            (element) => element.journeyId == lastJourneyId.split('/').first);
        return journey;
      } else {
        await getSharedJourneys();
        Journey? journey = journeys.firstWhereOrNull(
            (element) => element.journeyId == lastJourneyId.split('/').first);
        journey ??= downloadedJourneys.firstWhereOrNull(
            (element) => element.journeyId == lastJourneyId.split('/').first);
        return journey;
      }
    } catch (e) {
      debugPrint('getLastVisitedJourney() error: $e');
      return null;
    }
  }

  String getLastVisitedJourneyId() => journeyApi.getLastVisitedJourney();

  Future<void> recoverJourneys({bool showSnackbar = false}) async {
    journeys.clear();
    List<Journey> recoveredJourneys = await journeyCloudApi.recoverJourneys();

    for (Journey j in recoveredJourneys) {
      Journey? journey = downloadedJourneys
          .firstWhereOrNull((element) => element.journeyId == j.journeyId);
      if (journey == null) {
        journeys.add(j);
      }
    }
    if (showSnackbar && journeys.isEmpty && downloadedJourneys.isEmpty) {
      Get.snackbar("Info", 'No Journeys found, create one locally');
    }
  }

  Future<void> uploadFileToStorage(String journeyId, String filePath) async {
    final storageRef = FirebaseStorage.instance.ref(
        '${FirebaseAuth.instance.currentUser?.uid}/$journeyId/${filePath.split('/').last}');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.absolute}/$filePath');

    try {
      await storageRef.putFile(file);
    } catch (e) {
      debugPrint('uploadFileToStorage() error: $e');
      Get.snackbar('Error', 'Failed to upload file');
    }
  }
}
