enum AccommodationType { room, hotel, other }

class Accommodation {
  String accommodationId;
  AccommodationType type;
  String? filePath;
  String location;
  String startTime;
  String endTime;

  Accommodation(this.accommodationId, this.type, this.filePath, this.location,
      this.startTime, this.endTime);

  Map<String, dynamic> toJson() => {
        'accommodationId': accommodationId,
        'type': type.name,
        'filePath': filePath,
        'location': location,
        'startTime': startTime,
        'endTime': endTime
      };

  factory Accommodation.fromJson(Map<dynamic, dynamic> json) => Accommodation(
      json['accommodationId'],
      mapAccommodationType(json['type']),
      json['filePath'],
      json['location'],
      json['startTime'],
      json['endTime']);

  static AccommodationType mapAccommodationType(String typeAsString) {
    switch (typeAsString) {
      case 'Room':
        return AccommodationType.room;
      case 'Hotel':
        return AccommodationType.hotel;
      case 'Other':
        return AccommodationType.other;
      default:
        return AccommodationType.other;
    }
  }
}
