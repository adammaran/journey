import 'package:fishing_helper/app/models/journey/accommodation_model.dart';
import 'package:fishing_helper/app/models/journey/spending_money_model.dart';
import 'package:fishing_helper/app/widgets/app_bar/secondary_app_bar.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:fishing_helper/app/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../tools/date_time_tools.dart';
import '../../../models/journey/transportation_model.dart';
import '../controllers/create_journey_controller.dart';

class CreateJourneyView extends GetView<CreateJourneyController> {
  const CreateJourneyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SecondaryAppBar(
          showBack: true,
          label: 'Create journey',
        ),
        bottomSheet: const Padding(
          padding: EdgeInsets.only(bottom: 140),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.addJourney();
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.save, color: Colors.white),
        ),
        body: PageWidget(
          isScrollable: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: controller.journeyKey,
                child: TextFieldWidget(
                  controller: controller.journeyNameController,
                  hint: 'Enter journey name',
                ),
              ),
              const SizedBox(height: 24),
              const Text('Transportation',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 8),
              _buildTransportationList(),
              _buildAddTile(TileType.transportation),
              const SizedBox(height: 24),
              const Text('Accommodation',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              const SizedBox(height: 8),
              _buildAccommodationList(),
              _buildAddTile(TileType.accommodation),
              // SizedBox(height: 24),
              // _buildTransportationList(),
              // _buildAddTile(TileType.spendingMoney)
            ],
          ),
        ));
  }

  ///TRANSPORT
  Widget _buildTransportationList() => Obx(
        () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.addedTransportations.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    _buildTransportTile(
                        controller.addedTransportations.length == 1 &&
                                controller.addedTransportations
                                        .elementAt(index)
                                        .delay !=
                                    null
                            ? 'first'
                            : controller.addedTransportations.length == 1
                                ? 'single'
                                : index == 0
                                    ? 'first'
                                    : index ==
                                            controller.addedTransportations
                                                    .length -
                                                1 && !controller.addedTransportations.elementAt(index).hasDelay!.value
                                        ? 'last'
                                        : '',
                        'transportation',
                        controller.addedTransportations.elementAt(index)),
                    if (controller.addedTransportations
                            .elementAt(index)
                            .delay !=
                        null)
                      Obx(
                        () => controller.addedTransportations
                                .elementAt(index)
                                .hasDelay!
                                .value
                            ? _buildDelayTile(
                                controller.addedTransportations
                                    .elementAt(index)
                                    .delay!,
                                controller.addedTransportations
                                    .elementAt(index)
                                    .transportationId)
                            : const SizedBox.shrink(),
                      )
                  ],
                )),
      );

  SizedBox _buildDelayTile(DelayModel delay, String transportationId) =>
      SizedBox(
        height: 70,
        child: Row(
          children: [
            SizedBox(
                width: Get.width * 0.26,
                child: Center(child: Text(delay.name))),
            SizedBox(
              width: Get.width * 0.1,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 6,
                      color: Colors.grey,
                    ),
                    _buildCircle(Colors.grey, 'delay')
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: Get.width * 0.34,
              child: Text('${delay.duration} minutes'),
            ),
            IconButton(
                onPressed: () {
                  controller.removeDelay(transportationId);
                },
                icon: const Icon(Icons.cancel_outlined))
          ],
        ),
      );

  SizedBox _buildTransportTile(
          String position, String type, Transportation transportation) =>
      SizedBox(
        height: 130,
        child: Row(children: [
          SizedBox(
              width: Get.width * 0.26,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(getOnlyTime(transportation.startTime)),
                      Text(getDateNoYear(transportation.startTime) ?? ''),
                    ],
                  ),
                  Column(
                    children: [
                      Text(getOnlyTime(transportation.startTime)),
                      Text(getDateNoYear(transportation.startTime) ?? ''),
                    ],
                  ),
                ],
              )),
          SizedBox(
            width: Get.width * 0.1,
            child: Center(
                child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: position == 'single'
                      ? const EdgeInsets.symmetric(vertical: 20)
                      : EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: position == 'first' ? 20 : 0,
                          bottom: position == 'last' ? 20 : 0),
                  width: 6,
                  color: Colors.black,
                ),
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircle(Colors.black, transportation.type.name),
                      _buildCircle(Colors.black, transportation.type.name)
                    ],
                  ),
                )
              ],
            )),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: Get.width * 0.35,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.centerLeft,
                      child: Text(transportation.from, maxLines: 2),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(transportation.to),
                    ),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTapUp: (TapUpDetails details) {
                  controller
                      .removeTransportation(transportation.transportationId);
                },
                child: const Icon(Icons.cancel_outlined),
              ),
              GestureDetector(
                  onTap: () {
                    // OpenFilex.open(transportation.filePath ?? '');
                  },
                  onLongPress: () {
                    debugPrint('open edit file');
                  },
                  child: SizedBox(
                    width: Get.width * 0.1,
                    child: Icon(transportation.filePath != null
                        ? Icons.upload
                        : Icons.file_open),
                  )),
              const SizedBox.shrink()
            ],
          )
        ]),
      );

  ///ACCOMMODATION
  Widget _buildAccommodationList() => Obx(
        () => ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => _buildAccommodationTile(
                controller.addedAccommodations.length == 1
                    ? 'single'
                    : index == 0
                        ? 'first'
                        : index == controller.addedAccommodations.length - 1
                            ? 'last'
                            : '',
                'accommodation',
                controller.addedAccommodations.elementAt(index)),
            itemCount: controller.addedAccommodations.length),
      );

  SizedBox _buildAccommodationTile(
          String position, String type, Accommodation accommodation) =>
      SizedBox(
        height: 130,
        child: Row(children: [
          SizedBox(
              width: Get.width * 0.26,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(getOnlyTime(accommodation.startTime)),
                      Text(getDateNoYear(accommodation.startTime) ?? ''),
                    ],
                  ),
                  Column(
                    children: [
                      Text(getOnlyTime(accommodation.startTime)),
                      Text(getDateNoYear(accommodation.startTime) ?? ''),
                    ],
                  ),
                ],
              )),
          SizedBox(
            width: Get.width * 0.1,
            child: Center(
                child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: position == 'single'
                      ? const EdgeInsets.symmetric(vertical: 20)
                      : EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: position == 'first' ? 20 : 0,
                          bottom: position == 'last' ? 20 : 0),
                  width: 6,
                  color: Colors.black,
                ),
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCircle(Colors.black, accommodation.type.name),
                      _buildCircle(Colors.black, accommodation.type.name)
                    ],
                  ),
                )
              ],
            )),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              width: Get.width * 0.34,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.centerLeft,
                    child: Text(accommodation.location),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(accommodation.location),
                  ),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    controller
                        .removeAccommodation(accommodation.accommodationId);
                  },
                  icon: const Icon(Icons.cancel_outlined)),
              GestureDetector(
                onTap: () {
                  controller.selectFile();
                },
                onLongPress: () {
                  debugPrint('open edit file');
                },
                child: SizedBox(
                  width: Get.width * 0.1,
                  child: Icon(accommodation.filePath != null
                      ? Icons.upload
                      : Icons.file_open),
                ),
              ),
              const SizedBox.shrink()
            ],
          )
        ]),
      );

  ///SPENDING MONEY
  Widget _buildSpendingMoneyList() => Obx(
        () => ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (_, index) => _buildSpendingMoneyTile(
                controller.addedSpendingMoney.elementAt(index)),
            separatorBuilder: (_, index) => SizedBox(height: 4),
            itemCount: controller.addedSpendingMoney.length),
      );

  ///DIZAJN ZA POLJE IDE OVDE POZ
  Widget _buildSpendingMoneyTile(SpendingMoney spendingMoney) => Container(
        height: 48,
        width: Get.width,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Center(child: Text('${accommodation.from} -> ${accommodation.to}')),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                controller.removeTransportation(spendingMoney.spendingMoneyId);
              },
            )
          ],
        ),
      );

  Widget _buildAddTile(TileType type) => InkWell(
        onTap: () {
          controller.openDialog(type);
        },
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Add new ${type.name.capitalizeFirst}',
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );

  Container _buildCircle(Color color, String subType) => Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: color),
        child: Icon(
          controller.getIconByType(subType),
          color: Colors.white,
          size: 18,
        ),
      );
}
