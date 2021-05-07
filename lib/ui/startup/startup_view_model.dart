import 'package:plant_it_forward/app/app.locator.dart';
import 'package:plant_it_forward/app/app.router.dart';
import 'package:plant_it_forward/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  Future<void> runStartupLogic() async {
    if (_userService.hasLoggedInUser) {
      await _userService.syncUserAccount();

      // final currentUser = _userService.currentUser;

      // if (!currentUser.hasAddress) {
      //   _navigationService.navigateTo(Routes.addressSelectionView);
      // } else {
      //   // navigate to home view
      // }
      _navigationService.replaceWith(Routes.navbarView);
    } else {
      _navigationService.replaceWith(Routes.authView);
    }
  }
}
