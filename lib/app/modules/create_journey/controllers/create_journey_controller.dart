import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/models/journey/accommodation_model.dart';
import 'package:fishing_helper/app/models/journey/response/confirmation_response.dart';
import 'package:fishing_helper/app/models/journey/spending_money_model.dart';
import 'package:fishing_helper/app/service/auth_service.dart';
import 'package:fishing_helper/app/service/journey_service.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/date_time_picker.dart';
import 'package:fishing_helper/app/widgets/simple_button.dart';
import 'package:fishing_helper/tools/date_time_tools.dart';
import 'package:fishing_helper/tools/file_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/journey/journey_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../models/journey/transportation_model.dart';
import '../../../widgets/default_dialog.dart';
import '../../../widgets/text_field.dart';

enum TileType { transportation, accommodation, spendingMoney }

class CreateJourneyController extends GetxController {
  final GlobalKey<FormState> journeyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _transportKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _accommodationKey = GlobalKey<FormState>();

  late JourneyService _journeyService;

  late Journey newJourney;

  RxList<Transportation> addedTransportations = RxList.empty();
  RxList<Accommodation> addedAccommodations = RxList.empty();
  RxList<SpendingMoney> addedSpendingMoney = RxList.empty();

  TextEditingController journeyNameController = TextEditingController();

  List<String> transportTypes = ['Flight', 'Bus', 'Car', 'Other'];
  List<String> accommodationType = ['Room', 'Hotel'];

  RxString selectedDeparture = RxString('');
  RxString selectedLanding = RxString('');

  RxString filePath = RxString('');

  RxString selectedAccomArival = RxString('');
  RxString selectedLeaveTime = RxString('');

  RxString selectedTravelType = RxString('Flight');
  RxString selectedAccommodationType = RxString('Room');
  TextEditingController startController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController delayDurationController = TextEditingController();
  TextEditingController delayNameController = TextEditingController();
  DelayModel? newDelay;

  @override
  void onInit() {
    _journeyService = Get.find<JourneyService>();

    newJourney = Journey(journeyId: const Uuid().v4());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void openDialog(TileType type) {
    switch (type) {
      case TileType.transportation:
        openAddTransportDialog(type);
      case TileType.accommodation:
        openAddAccommodationDialog();
      case TileType.spendingMoney:
      // openAddSpendingMoneyDialog()
    }
  }

  void openAddTransportDialog(TileType type) {
    if (addedTransportations.isNotEmpty) {
      startController.text = addedTransportations.last.to;
      selectedDeparture.value = addedTransportations.last.delay != null
          ? addDelayToTime()
          : addedTransportations.last.arrivalTime;
    }
    DefaultDialog.show(
      padding: const EdgeInsets.all(16),
      title: 'Add ${type.name}',
      body: Column(
        children: [
          Row(
            children: [
              CTAButton(
                  onPressed: () async {
                    selectedDeparture.value =
                        await DateTimePicker().showDateTimePicker();
                  },
                  label: 'Select departure'),
              const SizedBox(width: 4),
              Obx(() => Expanded(
                      child: Text(
                    selectedDeparture.value,
                    style: selectedDeparture.value == 'Enter departure date'
                        ? const TextStyle(color: Colors.red)
                        : null,
                  )))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CTAButton(
                  onPressed: () async {
                    selectedLanding.value =
                        await DateTimePicker().showDateTimePicker();
                  },
                  label: 'Select arrival'),
              const SizedBox(width: 4),
              Obx(() => Text(
                    selectedLanding.value,
                    style: selectedLanding.value == 'Enter arrival date'
                        ? const TextStyle(color: Colors.red)
                        : null,
                  ))
            ],
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton(
                    value: selectedTravelType.value,
                    items: transportTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (e) => selectedTravelType.value = e ?? ''),
                IconButton(
                    onPressed: () {
                      selectFile();
                    },
                    icon: Icon(filePath.isEmpty
                        ? Icons.upload_outlined
                        : Icons.upload))
              ],
            ),
          ),
          Form(
              key: _transportKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    controller: startController,
                    hint: 'Start',
                  ),
                  const SizedBox(height: 4),
                  TextFieldWidget(
                    controller: destinationController,
                    hint: 'Destination',
                  ),
                  const SizedBox(height: 4),
                  TextFieldWidget(
                    controller: priceController,
                    hint: 'Price',
                  )
                ],
              )),
          const SizedBox(height: 12),
          CTAButton(
            onPressed: () => openAddDelayDialog(),
            label: 'Add delay',
          )
        ],
      ),
      onConfirmText: 'Add',
      onConfirm: () {
        if (validateNewTransport()) {
          addTransportToList();
          Get.back();
        }
      },
      onCancel: () {
        Get.back();
        clearFields();
      },
    );
  }

  String addDelayToTime() {
    return DateFormat('yyyy/MM/dd - HH:mm').format(
        DateTime.parse(formatDateTime(addedTransportations.last.arrivalTime))
            .add(Duration(
                minutes:
                    int.parse(addedTransportations.last.delay!.duration))));
  }

  void openAddDelayDialog() {
    delayNameController.text = destinationController.text;
    DefaultDialog.show(
      padding: const EdgeInsets.all(16),
      title: 'Add delay',
      body: Column(
        children: [
          Form(
              child: Column(
            children: [
              TextFieldWidget(
                controller: delayNameController,
                hint: 'Delay location',
              ),
              const SizedBox(height: 4),
              TextFieldWidget(
                controller: delayDurationController,
                hint: 'Delay duration (minutes)',
              )
            ],
          ))
        ],
      ),
      onConfirmText: 'Add delay',
      onConfirm: () {
        addDelay();
        Get.back();
      },
    );
  }

  bool validateNewTransport() {
    bool isValid = true;

    if (!_transportKey.currentState!.validate()) {
      isValid = false;
    }

    if (selectedDeparture.value.isEmpty &&
        selectedDeparture.value != 'Enter departure date') {
      selectedDeparture.value = 'Enter departure date';
      isValid = false;
    }

    if (selectedLanding.value.isEmpty &&
        selectedLanding.value != 'Enter arrival date') {
      selectedLanding.value = 'Enter arrival date';
      isValid = false;
    }
    return isValid;
  }

  bool validateNewAccommodation() {
    bool isValid = true;

    if (!_accommodationKey.currentState!.validate()) {
      isValid = false;
    }

    if (selectedAccomArival.value.isEmpty &&
        selectedAccomArival.value != 'Enter arrival date') {
      selectedAccomArival.value = 'Enter arrival date';
      isValid = false;
    }

    if (selectedLeaveTime.value.isEmpty &&
        selectedLeaveTime.value != 'Enter leave date') {
      selectedLeaveTime.value = 'Enter leave date';
      isValid = false;
    }
    return isValid;
  }

  void addDelay() {
    newDelay = DelayModel(const Uuid().v4(), delayNameController.text,
        delayDurationController.text);
  }

  void addTransportToList() {
    var uuid = const Uuid();
    Transportation transport = Transportation(
        uuid.v4(),
        startController.text,
        destinationController.text,
        priceController.text,
        filePath.value,
        selectedDeparture.value,
        selectedLanding.value,
        Transportation.mapTransportationType(selectedTravelType.value),
        newDelay);
    if (newDelay != null) {
      transport.hasDelay?.value = true;
    }
    addedTransportations.add(transport);
    newDelay = null;
    clearDelayFields();
    clearFields();
  }

  void selectFile() async {
    filePath.value = await FileHandler().selectFile() ?? '';
  }

  void openAddAccommodationDialog() {
    if (addedTransportations.isNotEmpty) {
      destinationController.text = addedTransportations.last.to;
      selectedAccomArival.value = addedTransportations.last.arrivalTime;
    }
    DefaultDialog.show(
      padding: const EdgeInsets.all(16),
      title: 'Add accommodation',
      body: Column(
        children: [
          Row(
            children: [
              CTAButton(
                  onPressed: () async {
                    selectedAccomArival.value =
                        await DateTimePicker().showDateTimePicker();
                  },
                  label: 'Select arrival'),
              const SizedBox(width: 4),
              Obx(() => Text(selectedAccomArival.value,
                  style: selectedAccomArival.value == 'Enter arrival date'
                      ? const TextStyle(color: Colors.red)
                      : null))
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CTAButton(
                  onPressed: () async {
                    selectedLeaveTime.value =
                        await DateTimePicker().showDateTimePicker();
                  },
                  label: 'Select Leave date'),
              const SizedBox(width: 4),
              Obx(() => Text(selectedLeaveTime.value,
                  style: selectedLeaveTime.value == 'Enter leave date'
                      ? const TextStyle(color: Colors.red)
                      : null))
            ],
          ),
          Obx(
            () => DropdownButton(
                value: selectedAccommodationType.value,
                items: accommodationType
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (e) => selectedAccommodationType.value = e ?? ''),
          ),
          Form(
              key: _accommodationKey,
              child: Column(children: [
                TextFieldWidget(
                    controller: destinationController, hint: 'Destination'),
                SizedBox(height: 4),
                TextFieldWidget(controller: priceController, hint: 'Price')
              ]))
        ],
      ),
      onConfirmText: 'Add',
      onCancel: () {
        Get.back();
        clearFields();
      },
      onConfirm: () {
        if (validateNewAccommodation()) {
          addAccommodationToList();
          Get.back();
        }
      },
    );
  }

  void addAccommodationToList() {
    Accommodation accommodation = Accommodation(
        const Uuid().v4(),
        Accommodation.mapAccommodationType(selectedAccommodationType.value),
        '',
        destinationController.text,
        selectedAccomArival.value,
        selectedLeaveTime.value);
    addedAccommodations.add(accommodation);
    newJourney.accommodations?.add(accommodation);
    clearFields();
  }

  void removeFromList(int index, String type) {
    if (type == 'accommodation') {
      addedAccommodations.removeAt(index);
    } else {
      addedTransportations.removeAt(index);
    }
  }

  void clearDelayFields() {
    delayNameController.clear();
    delayDurationController.clear();
  }

  void clearFields() {
    selectedDeparture.value = '';
    selectedLanding.value = '';
    selectedAccomArival.value = '';
    selectedLeaveTime.value = '';
    filePath.value = '';
    selectedTravelType.value = 'Flight';
    selectedAccommodationType.value = 'Room';
    startController.clear();
    destinationController.clear();
    priceController.clear();
  }

  void removeTransportation(String transportId) {
    addedTransportations
        .removeWhere((element) => element.transportationId == transportId);
  }

  void removeAccommodation(String accommodationId) {
    addedAccommodations
        .removeWhere((element) => element.accommodationId == accommodationId);
  }

  void removeDelay(String transportationId) {
    addedTransportations
        .firstWhere((element) => element.transportationId == transportationId)
      ..delay = null
      ..hasDelay!.value = false;
  }

  void addJourney() async {
    if (journeyKey.currentState!.validate()) {
      try {
        ConfirmationResponse res = await addJourneyToDB();
        if (res.code == '200') {
          DefaultDialog.show(
            title: 'Success',
            description:
                'Journey ${journeyNameController.text} successfully added do local database',
            onConfirm: () {
              Get.back();
              Get.back();
            },
          );
        } else {
          DefaultDialog.show(
              title: 'Error',
              body: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('An errro occured'),
              ));
        }
      } catch (e) {
        DefaultDialog.show(
            title: 'Error',
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('An errro occured: $e'),
            ));
        debugPrint('addJourney() error: $e');
      }
    }
  }

  Future<ConfirmationResponse> addJourneyToDB() async {
    newJourney.ownerId = FirebaseAuth.instance.currentUser?.uid;
    newJourney.journeyName = journeyNameController.text;
    newJourney.startDestination = addedTransportations.first.from;
    newJourney.endDestination = addedTransportations.last.to;
    newJourney.startDate = addedTransportations.first.startTime;
    newJourney.finishDate = addedTransportations.last.arrivalTime;
    newJourney.transportations = addedTransportations;
    newJourney.accommodations = addedAccommodations;
    ConfirmationResponse res = await _journeyService.addJourney(newJourney);
    _journeyService.getMyJourneys();
    return res;
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

  @override
  void onClose() {
    super.onClose();
  }
}
