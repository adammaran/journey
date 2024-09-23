import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/v4.dart';

enum TransportationType { flight, bus, car, other }

class Transportation {
  String transportationId;
  String from;
  String to;
  String price;
  String startTime;
  String arrivalTime;
  DelayModel? delay;
  RxBool? hasDelay = RxBool(false);

  TransportationType type;

  String? filePath;

  Transportation(this.transportationId, this.from, this.to, this.price,
      this.filePath, this.startTime, this.arrivalTime, this.type, this.delay);

  Map<String, dynamic> toJson() => {
        'transportationId': transportationId,
        'from': from,
        'to': to,
        'filePath': filePath,
        'price': price,
        'startTime': startTime,
        'arrivalTime': arrivalTime,
        'type': type.name,
        'delay': delay != null ? delay!.toJson() : null
      };

  factory Transportation.fromJson(Map<dynamic, dynamic> json) => Transportation(
      json['transportationId'],
      json['from'],
      json['to'],
      json['price'],
      json['filePath'],
      json['startTime'],
      json['arrivalTime'],
      mapTransportationType(json['type']),
      json['delay'] != null ? DelayModel.fromJson(json['delay']) : null);

  static TransportationType mapTransportationType(String typeAsString) {
    switch (typeAsString.toLowerCase()) {
      case 'flight':
        return TransportationType.flight;
      case 'bus':
        return TransportationType.bus;
      case 'car':
        return TransportationType.car;
      case 'other':
        return TransportationType.other;
      default:
        return TransportationType.other;
    }
  }
}

class DelayModel {
  String delayId;
  String name;
  String duration;

  DelayModel(this.delayId, this.name, this.duration);

  factory DelayModel.fromJson(Map<dynamic, dynamic> json) =>
      DelayModel(json['delayId'], json['name'], json['duration']);

  Map<dynamic, dynamic> toJson() =>
      {'delayId': delayId, 'name': name, 'duration': duration};
}
