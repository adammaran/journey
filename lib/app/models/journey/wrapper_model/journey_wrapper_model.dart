import 'package:fishing_helper/app/models/journey/response/confirmation_response.dart';

import '../journey_model.dart';

class JourneyWrapperModel extends ConfirmationResponse {
  Journey? journey;

  JourneyWrapperModel(super.code, super.errorMessage, {this.journey});

  factory JourneyWrapperModel.fromJson(Map<dynamic, dynamic> json) =>
      JourneyWrapperModel(
        json['code'],
        json['errorMessage'],
        journey: Journey.fromJson(json['journey']),
      );
}
