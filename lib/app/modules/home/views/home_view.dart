import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/routes/app_pages.dart';
import 'package:fishing_helper/app/widgets/app_bar/secondary_app_bar.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(label: 'Journey App'),
      body: PageWidget(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (6 / 4.6),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (_, index) =>
                  _buildTile(controller.tiles.elementAt(index))),
        ],
      )),
    );
  }

  Widget _buildTile(HomeTileModel tile) {
    return Obx(
      () => InkWell(
        onTap: controller.hasInternet.value
            ? tile.onTap
            : tile.title == 'My Journeys' || tile.title == 'Create Journey'
                ? tile.onTap
                : tile.title == 'My Journeys' || tile.title == 'Create Journey'
                    ? tile.onTap
                    : () {},
        child: Container(
          color: controller.hasInternet.value
              ? Colors.black
              : tile.title == 'My Journeys' || tile.title == 'Create Journey'
                  ? Colors.black
                  : Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => controller.loadingFavorite.value &&
                        tile.title == 'Last viewed'
                    ? const CircularProgressIndicator()
                    : tile.icon,
              ),
              Text(
                tile.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
