import 'package:flutter/foundation.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/services/authentication_service.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  UserData get currentUser => _authenticationService.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
