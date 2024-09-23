import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/create_journey/bindings/create_journey_binding.dart';
import '../modules/create_journey/views/create_journey_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/journey_details/bindings/journey_details_binding.dart';
import '../modules/journey_details/views/journey_details_view.dart';
import '../modules/list_journeys/bindings/list_journeys_binding.dart';
import '../modules/list_journeys/views/list_journeys_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const createTravel = Routes.CREATE_TRAVEL;
  static const listJourneys = Routes.LIST_JOURNEYS;
  static const journeyDetails = Routes.JOURNEY_DETAILS;
  static const auth = Routes.AUTH;
  static const profile = Routes.PROFILE;
  static const notifications = Routes.NOTIFICATIONS;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => const HomeView(),
        binding: HomeBinding(),
        transitionDuration: const Duration(milliseconds: 0)),
    GetPage(
      name: _Paths.CREATE_TRAVEL,
      page: () => const CreateJourneyView(),
      binding: CreateJourneyBinding(),
    ),
    GetPage(
      name: _Paths.LIST_JOURNEYS,
      page: () => const ListJourneysView(),
      binding: ListJourneysBinding(),
    ),
    GetPage(
      name: _Paths.JOURNEY_DETAILS,
      page: () => const JourneyDetailsView(),
      binding: JourneyDetailsBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
        name: _Paths.PROFILE,
        page: () => const ProfileView(),
        binding: ProfileBinding(),
        transitionDuration: const Duration(milliseconds: 0)),
    GetPage(
        name: _Paths.NOTIFICATIONS,
        page: () => const NotificationsView(),
        binding: NotificationsBinding(),
        transitionDuration: const Duration(milliseconds: 0)),
  ];
}
