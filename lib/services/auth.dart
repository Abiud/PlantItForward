import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_it_forward/models/UserData.dart';
import 'package:plant_it_forward/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create UserData object based on Firebase User
  UserData _userFromFirebaseUser(User user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<UserData> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in email
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create a new doc for the user
      await DatabaseService(uid: user.uid).updateUserData("0", name, 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
