import 'package:plant_it_forward/services/authentication_service.dart';
import 'package:stacked/stacked.dart';

class StartupViewModel extends StreamViewModel<String> {
  final AuthenticationService authenticationService = AuthenticationService();

  @override
  Stream<String> get stream => getStreamFromFirebase();

  Stream<String> getStreamFromFirebase() {
    return authenticationService.onAuthStateChanged;
  }
}
