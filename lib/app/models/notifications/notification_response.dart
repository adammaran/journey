import 'package:get/get.dart';

class NotificationResponse {
  String notificationId;
  String title;
  String description;
  String journeyId;
  String fromUid;
  RxBool isRead;

  NotificationResponse(this.notificationId, this.title, this.description,
      this.journeyId, this.fromUid, this.isRead);

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
          json['notificationId'],
          json['title'],
          json['description'],
          json['journeyId'],
          json['fromUid'],
          RxBool(json['isRead']));

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'journeyId': journeyId,
        'fromUid': fromUid,
        'isRead': isRead,
        'time': DateTime.now()
      };
}
