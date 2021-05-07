import 'package:stacked/stacked.dart';

class AuthViewModel extends BaseViewModel {
  bool _showLogin = true;
  bool get showLogin => _showLogin;

  void toggleView() {
    _showLogin = !_showLogin;
  }
}
