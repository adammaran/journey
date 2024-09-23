import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/widgets/app_bar/secondary_app_bar.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/bottom_nav_bar/bottom_nav_bar_widget.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(
          showBack: false,
          label: 'Profile',
        ),
        body: PageWidget(child: _buildSuccessState()));
  }

  Widget _buildSuccessState() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Text(
              'Logged in as: ${FirebaseAuth.instance.currentUser?.email}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/images/png/message-image.png', width: 140),
                const SizedBox(width: 12),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CTAButton(
                            onPressed: () {
                              Get.toNamed(AppPages.listJourneys,
                                  arguments: 'myJourneys');
                            },
                            label: 'My journeys'),
                        const SizedBox(height: 12),
                        CTAButton(
                            onPressed: () {
                              Get.toNamed(AppPages.listJourneys,
                                  arguments: 'sharedWithMe');
                            },
                            label: 'Shared with me'),
                      ],
                    ),
                    const SizedBox.shrink(),
                    CTAButton(
                        onPressed: () {
                          controller.logout();
                        },
                        label: 'Logout')
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
