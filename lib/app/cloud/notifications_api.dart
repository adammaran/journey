import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/service/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/notifications/notification_response.dart';

class NotificationApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> listenToNotifications() =>
      _firestore.collection('notifications').snapshots();

  Future<List<NotificationResponse>> getNotifications() {
    return _firestore
        .collection('notifications')
        .where('toUid', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
        .orderBy('time', descending: true)
        .get()
        .then((value) {
      return List.from(
          value.docs.map((e) => NotificationResponse.fromJson(e.data())));
    });
  }

  void setIsRead(String notificationId) {
    _firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  void sendNotification(
      List<String> uids, String journeyId, String journeyName) {
    for (String uid in uids) {
      _firestore.collection('notifications').add({
        'journeyId': journeyId,
        'description':
            'User ${FirebaseAuth.instance.currentUser?.email} sent you his journey!',
        'title': journeyName,
        'toUid': uid,
        'fromUid': FirebaseAuth.instance.currentUser?.uid,
        'isRead': false,
        'time': DateTime.now()
      }).then((value) => _firestore
          .collection('notifications')
          .doc(value.id)
          .update({'notificationId': value.id}));
    }
  }
}
