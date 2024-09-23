import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/modules/auth/controllers/auth_controller.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class EmailVerificationView extends GetView<AuthController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: Get.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 120),
            const Icon(Icons.mark_email_unread_outlined,
                color: Colors.black, size: 120),
            Text(
              'Check your email (${controller.emailController.text}) to verify the account and continue using the app!',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            controller.emailVerificationState.value ==
                    EmailVerificationState.notVerified
                ? _waitingForVerificationState()
                : controller.emailVerificationState.value ==
                        EmailVerificationState.verified
                    ? _emailVerifiedState()
                    : _emailVerificationLoadingState(),
            const SizedBox(height: 120),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    controller.pageState.value = AuthPageState.login;
                  },
                  child: const Text(
                    'CHANGE ACCOUNT',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _waitingForVerificationState() => Column(
        children: [
          CTAButton(
              onPressed: () {
                controller.sendEmailVerificationLink();
              },
              label: 'Resend email'),
          const SizedBox(height: 18),
          CTAButton(
              onPressed: () {
                controller.checkIfEmailVerified();
              },
              label: 'Check if verified')
        ],
      );

  Widget _emailVerificationLoadingState() =>
      const Center(child: CircularProgressIndicator());

  Widget _emailVerifiedState() => Column(
        children: [
          const Text('Email verified successfully'),
          const SizedBox(height: 18),
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                controller.pageState.value = AuthPageState.login;
              },
              child: const Text(
                'CHANGE ACCOUNT',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ))
        ],
      );
}
