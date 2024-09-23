import 'package:fishing_helper/app/models/journey/journey_model.dart';
import 'package:fishing_helper/app/routes/app_pages.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/app_bar/secondary_app_bar.dart';
import '../../../widgets/state/page_state.dart';
import '../controllers/list_journeys_controller.dart';

class ListJourneysView extends GetView<ListJourneysController> {
  const ListJourneysView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
          showBack: true,
          label:
              controller.isSharedJourneys() ? 'Shared with me' : 'My Journeys'),
      body: PageWidget(
        isScrollable: controller.journeyService.journeys.isNotEmpty,
        child: _buildSuccessState(),
      ),
    );
  }

  Widget _buildSuccessState() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            controller.isSharedJourneys()
                ? 'All of the Journeys other shared with you are here!'
                : 'All of your journeys are kept here',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset('assets/images/png/from-to-airplane.png'),
        ),
        if (controller.journeyService.journeys.isNotEmpty)
          const SizedBox(height: 30),
        Obx(
          () => controller.state.value == PageState.loading
              ? LoadingState()
              : Column(
                  children: [
                    if (controller.journeyService.journeys.isNotEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Journeys from cloud',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    if (controller.journeyService.journeys.isNotEmpty)
                      const SizedBox(height: 10),
                    if (controller.journeyService.journeys.isNotEmpty)
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, index) => _buildJourneyTile(
                              controller.journeyService.journeys
                                  .elementAt(index),
                              true),
                          separatorBuilder: (_, index) => const SizedBox(
                                height: 12,
                              ),
                          itemCount: controller.journeyService.journeys.length),
                    if (controller.journeyService.downloadedJourneys.isNotEmpty)
                      const SizedBox(height: 30),
                    if (controller.journeyService.downloadedJourneys.isNotEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Downloaded Journeys',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    if (controller.journeyService.downloadedJourneys.isNotEmpty)
                      const SizedBox(height: 10),
                    if (controller.journeyService.downloadedJourneys.isNotEmpty)
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, index) => _buildJourneyTile(
                              controller.journeyService.downloadedJourneys
                                  .elementAt(index),
                              false),
                          separatorBuilder: (_, index) => const SizedBox(
                                height: 12,
                              ),
                          itemCount: controller
                              .journeyService.downloadedJourneys.length),
                  ],
                ),
        ),
        const SizedBox(height: 30),
        if (!controller.isSharedJourneys())
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CTAButton(
                  onPressed: () {
                    Get.toNamed(AppPages.createTravel);
                  },
                  label: 'Add new Journey'),
              Obx(
                () => CTAButton(
                    isLoading: controller.recoverJourneysLoading.value,
                    onPressed: () {
                      controller.recoverJourneys();
                    },
                    label: 'Recover Journeys'),
              ),
            ],
          )
      ]);

  Widget _buildJourneyTile(Journey journey, bool isUploaded) => GestureDetector(
        onTap: () {
          Get.toNamed(AppPages.journeyDetails,
              arguments: {'journey': journey, 'isUploaded': isUploaded});
        },
        child: Container(
          height: 68,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          child: Center(
            child: Row(
              children: [
                Text(
                  journey.journeyName?.capitalizeFirst ?? 'empty name',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      );
}
