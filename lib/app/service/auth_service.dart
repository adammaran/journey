import 'package:fishing_helper/app/cloud/auth_api.dart';
import 'package:fishing_helper/app/models/journey/auth/auth_response.dart';
import 'package:fishing_helper/app/service/state_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/journey/auth/user_model.dart';
import 'journey_service.dart';
import 'notification_service.dart';

class AuthService extends GetxService {
  final AuthApi authApi = AuthApi();

  late AuthResponse? currentUser;

  Future<String> login(String email, String password) async {
    AuthResponse res = await authApi.login(email, password);
    if (res.code == '200') {
      Get.put(StateService());
      Get.put(JourneyService());
      Get.put(NotificationService());
      currentUser = res;
    }
    return res.code;
  }

  Future<String> register(String email, String password) async {
    AuthResponse res = await authApi.register(email, password);
    if (res.code == '200') {
      currentUser = res;
    }
    return res.code;
  }

  Future<List<UserModel>> getAllUsers() async => authApi.getAllUsers();
}
