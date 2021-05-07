import 'package:plant_it_forward/api/firestore_api.dart';
import 'package:plant_it_forward/services/user_service.dart';
import 'package:plant_it_forward/ui/auth/auth_view.dart';
import 'package:plant_it_forward/ui/navbar/navbar_view.dart';
import 'package:plant_it_forward/ui/produce/price/price_create/price_create_view.dart';
import 'package:plant_it_forward/ui/produce/price/price_history/price_history_view.dart';
import 'package:plant_it_forward/ui/produce/price/price_list/price_list_view.dart';
import 'package:plant_it_forward/ui/produce/produce_view.dart';
import 'package:plant_it_forward/ui/startup/startup_view.dart';
import 'package:plant_it_forward/ui/statistics/statistics_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartupView, initial: true),
  MaterialRoute(page: NavbarView),
  MaterialRoute(page: StatisticsView),
  MaterialRoute(page: AuthView),
  MaterialRoute(page: ProduceView, children: [
    MaterialRoute(page: PriceListView, children: [
      MaterialRoute(page: PriceCreateView),
      MaterialRoute(page: PriceHistoryView)
    ])
  ]),
  // MaterialRoute(page: )
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: UserService),
  LazySingleton(classType: FirestoreApi),
  Singleton(classType: FirebaseAuthenticationService),
])
class AppSetup {
  /** */
}
