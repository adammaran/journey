import 'package:get/get.dart';

import '../controllers/journey_details_controller.dart';

class JourneyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneyDetailsController>(
      () => JourneyDetailsController(),
    );
  }
}
