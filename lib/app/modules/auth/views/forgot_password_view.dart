import 'package:fishing_helper/app/modules/auth/controllers/auth_controller.dart';
import 'package:fishing_helper/app/widgets/app_bar/secondary_app_bar.dart';
import 'package:fishing_helper/app/widgets/cta_button_widget.dart';
import 'package:fishing_helper/app/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.9,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SecondaryAppBar(
          label: 'Forgot password',
          showBack: true,
          onBack: () {
            controller.pageState.value = AuthPageState.login;
          },
        ),
        const Icon(Icons.lock_reset, size: 120),
        Column(
          children: [
            TextFieldWidget(
                controller: controller.emailController,
                hint: 'Email',
                type: TextInputType.emailAddress),
            const SizedBox(height: 20),
            CTAButton(
                onPressed: () {
                  controller.sendForgotPasswordEmail();
                },
                label: 'Send Email'),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Already reset password?'),
            CTAButton(
                onPressed: () {
                  controller.pageState.value = AuthPageState.login;
                },
                label: 'Sign in')
          ],
        )
      ]),
    );
  }
}
