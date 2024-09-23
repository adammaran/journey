import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/models/journey/response/confirmation_response.dart';
import 'package:fishing_helper/app/models/journey/transportation_model.dart';
import 'package:fishing_helper/constants/api_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

import '../../models/journey/accommodation_model.dart';
import '../../models/journey/journey_model.dart';
import '../hive_client.dart';

class JourneyRepository {
  late Box hiveBox;

  Future<ConfirmationResponse> addJourney(Journey journey) async {
    hiveBox = await HiveClient().openBox(ApiConstants.journey);
    try {
      await hiveBox.put(journey.journeyId, journey.toJson());
      return ConfirmationResponse('200', 'Success adding new journey');
    } catch (e) {
      return ConfirmationResponse('400', 'Unknown error occurred');
    }
  }

  Future<List<Journey>> getJourneys() async {
    hiveBox = await HiveClient().openBox(ApiConstants.journey);
    List<Journey> journeys = [];
    for (var json in hiveBox.values.where((element) =>
        element['ownerId'] == FirebaseAuth.instance.currentUser?.uid)) {
      Journey journey = Journey.fromJson(json);
      journey.transportations = json['transportation']
          .map<Transportation>((e) => Transportation.fromJson(e))
          .toList();
      journey.accommodations = json['accommodation']
          .map<Accommodation>((e) => Accommodation.fromJson(e))
          .toList();
      journeys.add(journey);
    }
    return journeys;
  }

  Future<ConfirmationResponse> addSharedJourneyToLocal(Journey journey) async {
    Box box = await HiveClient().openBox(ApiConstants.sharedJourneys);
    try {
      await box.put(
          '${journey.journeyId}/${FirebaseAuth.instance.currentUser?.uid}',
          journey.toJson());
      return ConfirmationResponse('200', 'Success adding new journey');
    } catch (e) {
      debugPrint('addSharedJourneyToLocal() error: $e');
      return ConfirmationResponse('400', 'Unknown error occurred');
    }
  }

  Future<List<Journey>> getLocalSharedJourneys() async {
    Box box = await HiveClient().openBox(ApiConstants.sharedJourneys);
    List<Journey> journeys = [];
    for (var key in box.keys.where((element) =>
        element.split('/').last == FirebaseAuth.instance.currentUser?.uid)) {
      Journey journey = Journey.fromJson(box.get(key));
      // journey.transportations = json['transportation']
      //     .map<Transportation>((e) => Transportation.fromJson(e))
      //     .toList();
      // journey.accommodations = json['accommodation']
      //     .map<Accommodation>((e) => Accommodation.fromJson(e))
      //     .toList();
      journeys.add(journey);
    }
    return journeys;
  }

  Future<ConfirmationResponse> deleteJourney(String journeyId) async {
    try {
      hiveBox = await HiveClient().openBox(ApiConstants.journey);
      hiveBox.delete(journeyId);
      return ConfirmationResponse('200', 'Journey deleted successfully');
    } catch (e) {
      return ConfirmationResponse('500', 'Error while deleting journey');
    }
  }

  Future<ConfirmationResponse> deleteSharedJourney(String journeyId) async {
    try {
      Box box = await HiveClient().openBox(ApiConstants.sharedJourneys);
      debugPrint('nesto? $journeyId/${FirebaseAuth.instance.currentUser?.uid}');
      for (var i in box.keys) {
        debugPrint(i);
      }
      await box.delete('$journeyId/${FirebaseAuth.instance.currentUser?.uid}');
      return ConfirmationResponse('200', 'Journey deleted successfully');
    } catch (e) {
      return ConfirmationResponse('500', 'Error while deleting journey');
    }
  }

  void updateJourneyInDB(Journey journey) async {
    hiveBox = await HiveClient().openBox(ApiConstants.journey);
    hiveBox.put(journey.journeyId ?? '', journey.toJson());
  }

  void setLastVisitedJourney(String journeyId) {
    GetStorage().write(ApiConstants.lastVisitedJourney, journeyId);
  }

  String getLastVisitedJourney() =>
      GetStorage().read(ApiConstants.lastVisitedJourney);
}
