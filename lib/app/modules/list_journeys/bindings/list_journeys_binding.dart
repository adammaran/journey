import 'package:get/get.dart';

import '../controllers/list_journeys_controller.dart';

class ListJourneysBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListJourneysController>(
      () => ListJourneysController(),
    );
  }
}
