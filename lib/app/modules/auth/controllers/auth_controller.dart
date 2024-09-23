import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/service/auth_service.dart';
import 'package:fishing_helper/app/widgets/page_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../service/notification_service.dart';

enum AuthPageState {
  login,
  register,
  forgot,
  emailVerification,
  forgotPassword
}

enum EmailVerificationState { notVerified, verified, loading }

class AuthController extends GetxController {
  Rx<AuthPageState> pageState = AuthPageState.login.obs;
  Rx<EmailVerificationState> emailVerificationState =
      EmailVerificationState.notVerified.obs;

  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();

  AuthService authService = Get.find<AuthService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    setInitPage();
    super.onInit();
  }

  void setInitPage() {
    if (FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.emailVerified) {
      pageState.value = AuthPageState.emailVerification;
    }
  }

  void login() async {
    if (loginKey.currentState!.validate()) {
      isLoading.value = true;
      String code = await authService.login(
          emailController.text, passwordController.text);
      if (code == '200') {
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          Get.toNamed(AppPages.INITIAL);
        } else {
          pageState.value = AuthPageState.emailVerification;
        }
        initListeners();
      } else {
        Get.snackbar('ERROR', code);
      }
      isLoading.value = false;
    }
  }

  void initListeners() {
    Get.find<NotificationService>().waitForNotifications();
  }

  void register() async {
    isLoading.value = true;
    String code = await authService.register(
        emailController.text, passwordController.text);
    if (code == '200') {
      debugPrint('alo ee?');
      pageState.value = AuthPageState.emailVerification;
      sendEmailVerificationLink();
    } else {
      Get.snackbar('ERROR', code);
    }
    isLoading.value = false;
  }

  void sendEmailVerificationLink() {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      Get.snackbar('Success', 'Email successfully sent');
    } catch (e) {
      Get.snackbar('Error', 'error sending email');
    }
  }

  void checkIfEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      emailVerificationState.value = EmailVerificationState.verified;
    } else {
      Get.snackbar('Info', 'Email still not verified');
    }
  }

  void sendForgotPasswordEmail() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text);
    Get.snackbar('Success', 'Email sent successfully');
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    pageState.value = AuthPageState.login;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
