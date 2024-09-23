import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fishing_helper/app/models/journey/response/confirmation_response.dart';
import 'package:fishing_helper/app/models/journey/wrapper_model/journey_wrapper_model.dart';
import 'package:flutter/material.dart';

import '../models/journey/journey_model.dart';

class JourneyCloudApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ConfirmationResponse> uploadJourney(Journey journey) {
    return _firestore
        .collection('journey')
        .doc(journey.journeyId)
        .set(journey.toJson())
        .then((value) async => ConfirmationResponse('200', 'SUCCESS'));
  }

  Future<JourneyWrapperModel> getJourneyById(String journeyId) async {
    return _firestore.collection('journey').doc(journeyId).get().then((value) =>
        JourneyWrapperModel('200', 'success',
            journey: Journey.fromJson(value.data() ?? {})));
  }

  Future<ConfirmationResponse> removeJourney(String journeyId) async =>
      _firestore.collection('journey').doc(journeyId).delete().then((value) =>
          ConfirmationResponse(
              '200', 'Successfully removed journey from cloud'));

  Future<ConfirmationResponse> shareJourney(
      List<String> uids, String journeyId, String journeyName) {
    try {
      return _firestore
          .collection('journey')
          .doc(journeyId)
          .update({'sharedUid': uids}).then(
              (value) => ConfirmationResponse('200', 'success'));
    } catch (e) {
      return Future.value(ConfirmationResponse('400', 'error'));
    }
  }

  Future<List<Journey>> getSharedJourneys() async {
    return _firestore
        .collection('journey')
        .where('sharedUid',
            arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return List.from(value.docs.map((e) => Journey.fromJson(e.data())));
    });
  }

  Future<List<Journey>> recoverJourneys() async {
    return _firestore
        .collection('journey')
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      return List.from(value.docs.map((e) {
        return Journey.fromJson(e.data());
      }));
    });
  }
}
