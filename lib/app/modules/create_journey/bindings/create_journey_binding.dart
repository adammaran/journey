import 'package:get/get.dart';

import '../controllers/create_journey_controller.dart';

class CreateJourneyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateJourneyController>(
      () => CreateJourneyController(),
    );
  }
}
