import 'package:fishing_helper/app/models/journey/accommodation_model.dart';
import 'package:fishing_helper/app/models/journey/transportation_model.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../tools/date_time_tools.dart';
import '../../../widgets/app_bar/secondary_app_bar.dart';
import '../../../widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import '../controllers/journey_details_controller.dart';

class JourneyDetailsView extends GetView<JourneyDetailsController> {
  const JourneyDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(showBack: true, label: 'Journey details', icons: [
        controller.isJourneyOwner()
            ? _buildOwnerIcons()
            : Obx(
                () => controller.isJourneyDownloaded.value
                    ? _buildDownloadedIcons()
                    : _buildCanDownloadIcons(),
              ),
      ]),
      body: PageWidget(isScrollable: true, child: _buildSuccessState()),
    );
  }

  Column _buildSuccessState() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          controller.journey.journeyName?.capitalizeFirst ?? '',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
            'Forgot when and where you are traveling?\nAll the information you need is here!'),
        const SizedBox(height: 30),
        if (controller.journey.transportations!.isNotEmpty)
          const Text(
            'Transportation',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        if (controller.journey.transportations!.isNotEmpty)
          _buildTransportationList(),
        const SizedBox(height: 10),
        if (controller.journey.accommodations!.isNotEmpty)
          const Text('Accommodation',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        if (controller.journey.accommodations!.isNotEmpty)
          _buildAccommodationList()
      ]);

  ListView _buildTransportationList() => ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, index) => Column(
            children: [
              _buildTransportTile(
                  controller.journey.transportations!.length == 1
                      ? 'single'
                      : index == 0
                          ? 'first'
                          : index ==
                                      controller
                                              .journey.transportations!.length -
                                          1 &&
                                  controller.journey.transportations!
                                      .elementAt(index)
                                      .hasDelay!
                                      .value
                              ? 'last'
                              : '',
                  'transportation',
                  controller.journey.transportations!.elementAt(index)),
              if (controller.journey.transportations!.elementAt(index).delay !=
                  null)
                _buildDelayTile(
                    controller.journey.transportations!.elementAt(index).delay!)
            ],
          ),
      separatorBuilder: (_, index) => const SizedBox.shrink(),
      itemCount: controller.journey.transportations!.length);

  ListView _buildAccommodationList() => ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, index) => _buildAccommodationTile(
          controller.journey.accommodations!.length == 1
              ? 'single'
              : index == 0
                  ? 'first'
                  : index == controller.journey.accommodations!.length - 1
                      ? 'last'
                      : '',
          'accommodation',
          controller.journey.accommodations!.elementAt(index)),
      separatorBuilder: (_, index) => const SizedBox.shrink(),
      itemCount: controller.journey.accommodations!.length);

  SizedBox _buildDelayTile(DelayModel delay) => SizedBox(
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
              width: Get.width * 0.35,
              child: Text('${delay.duration} minutes'),
            )
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.centerLeft,
                      child: Text(transportation.from),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(transportation.to),
                    ),
                  ],
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox.shrink(),
                  // GestureDetector(
                  //   onTapUp: (TapUpDetails details) {
                  //     controller.openJourneySettings(details);
                  //   },
                  //   child: const Icon(Icons.more_horiz),
                  // ),
                  GestureDetector(
                      onTap: () {
                        if (transportation.filePath == null ||
                            transportation.filePath!.isEmpty) {
                        } else {
                          OpenFilex.open(transportation.filePath ?? '');
                        }
                      },
                      onLongPress: () {
                        debugPrint(
                            'open edit file: ${transportation.filePath}');
                      },
                      child: SizedBox(
                          width: Get.width * 0.1,
                          child: Icon(transportation.filePath == null ||
                                  transportation.filePath!.isEmpty
                              ? Icons.upload
                              : Icons.file_open))),
                  const SizedBox.shrink()
                ])
          ]));

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
              width: Get.width * 0.35,
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
          )
        ]),
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

  Row _buildOwnerIcons() => Row(
        children: [
          if (!Get.arguments['isUploaded'])
            Obx(() => controller.isFileUploading.value
                ? const Center(
                    child: SizedBox(
                        height: 6,
                        width: 6,
                        child: CircularProgressIndicator()))
                : IconButton(
                    color: Colors.black,
                    onPressed: () {
                      controller.uploadJourney();
                    },
                    icon: const Icon(Icons.upload))),
          IconButton(
              color: Colors.black,
              onPressed: () {
                controller.openShareDialog();
              },
              icon: const Icon(Icons.share)),
          IconButton(
              color: Colors.black,
              onPressed: () {
                controller.deleteJourney();
              },
              icon: const Icon(Icons.delete))
        ],
      );

  Row _buildDownloadedIcons() => Row(
        children: [
          Obx(() => controller.isFileDownloading.value
              ? const Center(
                  child: SizedBox(
                      height: 6, width: 6, child: CircularProgressIndicator()))
              : IconButton(
                  color: Colors.black,
                  onPressed: () {
                    controller.deleteJourney();
                  },
                  icon: const Icon(Icons.delete))),
        ],
      );

  Row _buildCanDownloadIcons() => Row(
        children: [
          Obx(() => controller.isFileDownloading.value
              ? const Center(
                  child: SizedBox(
                      height: 6, width: 6, child: CircularProgressIndicator()))
              : IconButton(
                  color: Colors.black,
                  onPressed: () {
                    controller.downloadJourney();
                  },
                  icon: const Icon(Icons.download))),
        ],
      );
}
