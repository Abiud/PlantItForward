import 'package:plant_it_forward/services/analytics_service.dart';
import 'package:plant_it_forward/services/authentication_service.dart';
// import 'package:plant_it_forward/services/cloud_storage_service.dart';
import 'package:plant_it_forward/services/firestore_service.dart';
import 'package:plant_it_forward/services/push_notification_service.dart';
// import 'package:plant_it_forward/utils/image_selector.dart';
import 'package:get_it/get_it.dart';
import 'package:plant_it_forward/services/navigation_service.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/viewmodels/produce_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  // locator.registerLazySingleton(() => CloudStorageService());
  // locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => ProduceViewModel());
}
