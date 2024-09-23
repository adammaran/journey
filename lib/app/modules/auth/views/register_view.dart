import 'package:fishing_helper/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../widgets/cta_button_widget.dart';
import '../../../widgets/text_field.dart';

class RegisterView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_buildLogo(), _buildTextFields(), _buildChangePage()],
      ),
    );
  }

  Padding _buildLogo() => Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Image.asset(
          'assets/images/png/register-image.png',
          height: 300,
        ),
      );

  Form _buildTextFields() => Form(
      key: controller.loginKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFieldWidget(
              hint: 'Email',
              controller: controller.emailController,
            ),
            const SizedBox(height: 12),
            TextFieldWidget(
              isPassword: true,
              hint: 'Password',
              controller: controller.passwordController,
            ),
            const SizedBox(height: 12),
            TextFieldWidget(
              isPassword: true,
              hint: 'Repeat password',
              controller: controller.rePasswordController,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => CTAButton(
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      controller.register();
                    },
                    label: 'REGISTER'),
              ),
            )
          ],
        ),
      ));

  Column _buildChangePage() => Column(
        children: [
          const Text('Already have an account?',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          InkWell(
            onTap: () {
              controller.pageState.value = AuthPageState.login;
            },
            child: const Text('LOGIN',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          )
        ],
      );
}
