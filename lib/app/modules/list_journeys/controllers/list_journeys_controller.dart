import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/app/service/state_service.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:get/get.dart';

class ListJourneysController extends GetxController {
  Rx<PageState> state = PageState.loading.obs;

  late JourneyService journeyService;

  RxBool recoverJourneysLoading = RxBool(false);

  @override
  void onInit() {
    journeyService = Get.find<JourneyService>();
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.arguments == 'myJourneys') {
      getMyJourneys();
    } else if (Get.arguments == 'sharedWithMe') {
      getJourneysFromCloud();
    }
    super.onReady();
  }

  void getMyJourneys() async {
    await journeyService.getMyJourneys();
    if (Get.find<StateService>().hasInternet.value) {
      await journeyService.recoverJourneys();
    }
    state.value = PageState.success;
  }

  void getJourneysFromCloud() async {
    journeyService.getSharedJourneys();
    state.value = PageState.success;
  }

  void recoverJourneys() async {
    recoverJourneysLoading.value = true;
    await journeyService.recoverJourneys(showSnackbar: true);
    recoverJourneysLoading.value = false;
  }

  bool isSharedJourneys() => Get.arguments == 'sharedWithMe';

  @override
  void onClose() {
    super.onClose();
  }
}
