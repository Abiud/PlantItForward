import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/Models/UserData.dart';
import 'package:plant_it_forward/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:plant_it_forward/services/firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  UserData _currentUser;
  UserData get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = UserData(
        id: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: 'admin',
      );

      await _firestoreService.createUser(_currentUser);
      await _analyticsService.setUserProperties(
        userId: authResult.user.uid,
        userRole: _currentUser.userRole,
      );

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  // sign out
  Future signOut() async {
    try {
      print("Sign out");
      _currentUser = new UserData();
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Stream<String> get onAuthStateChanged {
    _populateCurrentUser(_firebaseAuth.currentUser);
    return _firebaseAuth.authStateChanges().map((User user) => user?.uid);
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: _currentUser.userRole,
      );
    }
  }
}
