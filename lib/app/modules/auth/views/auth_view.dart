import 'package:fishing_helper/app/modules/auth/views/email_verification_view.dart';
import 'package:fishing_helper/app/modules/auth/views/forgot_password_view.dart';
import 'package:fishing_helper/app/modules/auth/views/login_view.dart';
import 'package:fishing_helper/app/modules/auth/views/register_view.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: PageWidget(
            showBottomNav: false,
            child: Obx(() => controller.pageState.value == AuthPageState.login
                ? LoginView()
                : controller.pageState.value == AuthPageState.register
                    ? RegisterView()
                    : controller.pageState.value == AuthPageState.forgotPassword
                        ? ForgotPasswordView()
                        : const EmailVerificationView())));
  }
}
