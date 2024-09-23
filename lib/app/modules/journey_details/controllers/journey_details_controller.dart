import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/cloud/auth_api.dart';
import 'package:fishing_helper/app/models/journey/journey_model.dart';
import 'package:fishing_helper/app/models/journey/wrapper_model/journey_wrapper_model.dart';
import 'package:fishing_helper/app/modules/list_journeys/controllers/list_journeys_controller.dart';
import 'package:fishing_helper/app/service/auth_service.dart';
import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/app/widgets/default_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/journey/auth/user_model.dart';
import '../../../models/journey/response/confirmation_response.dart';

class JourneyDetailsController extends GetxController {
  late Journey journey;
  late JourneyService journeyService;

  RxBool isFileUploading = RxBool(false);
  RxBool isFileDownloading = RxBool(false);
  RxBool isJourneyDeleting = RxBool(false);
  RxBool isJourneyDownloaded = RxBool(false);

  List<TileModel> tileUserList = List.empty(growable: true);
  RxBool loadingUserList = RxBool(false);

  @override
  void onInit() {
    journey = Get.arguments['journey'];
    journeyService = Get.find<JourneyService>();
    setLastVisitedJourney();
    setIsJourneyDownloaded();
    getJourneyById();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  IconData getIconByType(String type) {
    switch (type) {
      case 'flight':
        return Icons.flight;
      case 'bus':
        return Icons.directions_bus_filled;
      case 'car':
        return Icons.directions_car;
      case 'other':
        return Icons.question_mark;
      case 'room':
        return Icons.house;
      case 'hotel':
        return Icons.hotel;
      case 'delay':
        return Icons.access_time_rounded;
      default:
        return Icons.question_mark;
    }
  }

  void openJourneySettings(TapUpDetails details) {
    showMenu(
        context: Get.context!,
        position: RelativeRect.fromLTRB(
            details.globalPosition.dx, details.globalPosition.dy, 0, 0),
        items: [
          const PopupMenuItem<String>(value: 'Doge', child: Text('Doge')),
          const PopupMenuItem<String>(value: 'Lion', child: Text('Lion')),
        ]);
  }

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // filePath.value = result.files.single.path ?? '';
      // debugPrint(filePath.value);
    } else {
      // User canceled the picker
    }
  }

  void deleteJourney() {
    if (journey.ownerId != FirebaseAuth.instance.currentUser?.uid) {
      deleteSharedJourney();
    } else {
      showDeleteJourneyFromCloudDialog();
    }
  }

  void deleteSharedJourney() async {
    isJourneyDeleting.value = true;
    try {
      ConfirmationResponse res =
          await journeyService.deleteSharedJourney(journey.journeyId ?? '');

      if (res.code == '200') {
        journeyService.getLocalSharedJourneys();
        journeyService.getSharedJourneys();
        isJourneyDownloaded.value = false;
        DefaultDialog.show(
          title: 'Success',
          description:
              'Successfully deleted shared journey: ${journey.journeyName}',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      }
      isJourneyDeleting.value = false;
    } catch (e) {
      isJourneyDeleting.value = false;
      debugPrint('deleteSharedJourney() error: $e');
    }
  }

  void deleteMyJourney() async {
    try {
      await journeyService.deleteJourney(journey.journeyId ?? '');
      Get.find<ListJourneysController>().getMyJourneys();
      DefaultDialog.show(
        title: 'Success',
        description: 'Successfully deleted journey: ${journey.journeyName}',
        onConfirm: () {
          Get.back();
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      debugPrint('deleteJourney() error: $e');
    }
  }

  void showDeleteJourneyFromCloudDialog() async {
    DefaultDialog.show(
      title: 'Remove Journey from cloud?',
      body: const Text('Remove Journey from cloud?'),
      onConfirmText: 'Remove',
      onConfirm: () async {
        await deleteMyJourneyFromCloud();

        DefaultDialog.show(
          title: 'Success',
          description:
              'Successfully deleted journey from Cloud: ${journey.journeyName}',
          onConfirm: () {
            Get.back();
          },
        );

        deleteMyJourney();
      },
      onCancel: () {
        deleteMyJourney();
      },
    );
  }

  Future<void> deleteMyJourneyFromCloud() async {
    try {
      journeyService.deleteJourneyFromCloud(journey.journeyId ?? '');
    } catch (e) {
      debugPrint('deleteMyJourneyFromCloud() error: $e');
    }
  }

  void openShareDialog() {
    if (Get.arguments['isUploaded']) {
      getAllUsers();
      DefaultDialog.show(
        title: 'Share journey',
        body: Obx(
          () => loadingUserList.value
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: Get.height * 0.80,
                  child: ListView.separated(
                      itemCount: tileUserList.length,
                      separatorBuilder: (_, index) =>
                          const Divider(color: Colors.black),
                      itemBuilder: (_, index) => tileUserList
                                  .elementAt(index)
                                  .user
                                  .uid ==
                              FirebaseAuth.instance.currentUser?.uid
                          ? SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                tileUserList
                                    .elementAt(index)
                                    .isSelected
                                    .toggle();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tileUserList
                                        .elementAt(index)
                                        .user
                                        .email),
                                    Obx(() => tileUserList
                                            .elementAt(index)
                                            .isSelected
                                            .value
                                        ? IconButton(
                                            icon: const Icon(Icons.check_box),
                                            onPressed: () {
                                              tileUserList
                                                  .elementAt(index)
                                                  .isSelected
                                                  .toggle();
                                            },
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              tileUserList
                                                  .elementAt(index)
                                                  .isSelected
                                                  .toggle();
                                            },
                                            icon: const Icon(
                                                Icons.check_box_outline_blank)))
                                  ],
                                ),
                              ),
                            )),
                ),
        ),
        onConfirm: () {
          shareJourney();
        },
        onConfirmText: 'Share',
      );
    } else {
      Get.snackbar('Info', 'Backup this Journey first');
    }
  }

  void getAllUsers() {
    tileUserList.clear();
    loadingUserList.value = true;
    Get.find<AuthService>().getAllUsers().then((value) {
      for (UserModel user in value) {
        tileUserList.add(TileModel(RxBool(false), user));
      }
      loadingUserList.value = false;
    });
  }

  void shareJourney() async {
    List<String> uids = tileUserList
        .where((element) => element.isSelected.value)
        .map((e) => e.user.uid)
        .toList();
    if (uids.isNotEmpty) {
      // await uploadJourney();
      ConfirmationResponse res =
          await journeyService.shareJourney(uids, journey);
      if (res.code == '200') {
        Get.back();
        DefaultDialog.show(
          title: 'Success',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      }
    }
  }

  bool isJourneyOwner() =>
      journey.ownerId == FirebaseAuth.instance.currentUser?.uid;

  Future<void> uploadJourney() async {
    isFileUploading.value = true;
    await journeyService.uploadJourney(journey);
    journeyService.updateJourneyInDB(journey);
    Get.arguments['isUploaded'] = true;
    isFileUploading.value = false;
  }

  void getJourneyById() async {
    JourneyWrapperModel res =
        await journeyService.getJourneyById(journey.journeyId ?? '');
    // if(res)
  }

  void setLastVisitedJourney() {
    journeyService.setLastVisitedJourney(
        '${journey.journeyId}/${isJourneyOwner() ? 'myJourney' : 'sharedWithMe'}' ??
            '');
  }

  void setIsJourneyDownloaded() {
    Journey? journey = journeyService.downloadedJourneys.firstWhereOrNull(
        (element) => element.journeyId == this.journey.journeyId);
    isJourneyDownloaded.value = journey != null ? true : false;
  }

  void downloadJourney() async {
    try {
      isFileDownloading.value = true;
      ConfirmationResponse res =
          await journeyService.addSharedJourneyToLocal(journey);
      if (res.code == '200') {
        isFileDownloading.value = false;
        journeyService.getSharedJourneys();
        journeyService.getLocalSharedJourneys();
        isJourneyDownloaded.value = true;
        DefaultDialog.show(
          title: 'Success',
          description:
              'Successfully downloaded shared journey: ${journey.journeyName}',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      } else {
        DefaultDialog.show(
          title: 'Error',
          description: 'Error downloading journey: ${journey.journeyName}',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      }
    } catch (e) {
      debugPrint('downloadJourney() error: $e');
    }
  }
}

class TileModel {
  RxBool isSelected;
  UserModel user;

  TileModel(this.isSelected, this.user);
}
