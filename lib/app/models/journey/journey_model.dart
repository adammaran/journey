import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'accommodation_model.dart';
import 'transportation_model.dart';

class Journey {
  String? journeyId;
  String? ownerId;
  String? journeyName;
  String? startDestination;
  String? endDestination;
  String? startDate;
  String? finishDate;
  List<Transportation>? transportations = [];
  List<Accommodation>? accommodations = [];
  List<String>? sharedUids = [];

  Journey(
      {this.journeyId,
      this.ownerId,
      this.journeyName,
      this.startDestination,
      this.endDestination,
      this.startDate,
      this.finishDate,
      this.transportations,
      this.accommodations,
      this.sharedUids});

  Map<String, dynamic> toJson() {
    return {
      "journeyId": journeyId,
      'ownerId': ownerId,
      'journeyName': journeyName,
      'startDestination': startDestination,
      'endDestination': endDestination,
      'startDate': startDate,
      'finishDate': finishDate,
      'transportation': transportations != null
          ? List<dynamic>.from(transportations!.map((x) => x.toJson()))
          : [],
      'accommodation': accommodations != null
          ? List<dynamic>.from(accommodations!.map((x) => x.toJson()))
          : []
    };
  }

  factory Journey.fromJson(Map<dynamic, dynamic> json) {
    return Journey(
        journeyId: json['journeyId'],
        ownerId: json['ownerId'],
        journeyName: json['journeyName'],
        startDestination: json['startDestination'],
        endDestination: json['endDestination'],
        startDate: json['startDate'],
        finishDate: json['finishDate'],
        transportations: json['transportation'] != null
            ? List.from(
                json['transportation'].map((e) => Transportation.fromJson(e)))
            : [],
        accommodations: json['accommodation'] != null
            ? List.from(
                json['accommodation'].map((e) => Accommodation.fromJson(e)))
            : [],
        sharedUids: json['sharedUids'] != null
            ? List.from(json['sharedUids'].map((e) => e))
            : []);
  }
}
