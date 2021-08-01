import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_it_forward/Models/AppUser.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? role;
  // AuthResultStatus _authStatus;

  Stream<AppUser?> get appUser {
    return _auth.userChanges().map(_appUserFromFirebaseUser);
  }

  AppUser? _appUserFromFirebaseUser(User? user) {
    return user != null
        ? AppUser(uid: user.uid, emailVerified: user.emailVerified)
        : null;
  }

  Stream<String?> get onAuthStateChanged =>
      _auth.authStateChanges().map((User? user) => user?.uid);

  // GET UID
  Future<String> getCurrentUID() async {
    return _auth.currentUser!.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> get claims async {
    final user = _auth.currentUser;
    final token = await user!.getIdTokenResult(true);
    final claims = token.claims;
    final String? roleClaim = claims?['role'];
    role = roleClaim ?? 'volunteeer';
    return Future.value(claims);
  }

  // sign in email
  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
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
      User? user = result.user;

      // Create User, set role as volunteer, cloud function makes sure
      // the user can't change this.
      Map<String, dynamic> userData = {
        "name": name,
        "email": user!.email,
        "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
        "id": user.uid
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static saveUser(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int buildNumber = int.parse(packageInfo.buildNumber);

    Map<String, dynamic> userData = {
      "name": user.displayName,
      "email": user.email,
      "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
      "created_at": user.metadata.creationTime!.millisecondsSinceEpoch,
      "role": "user",
      "build_number": buildNumber,
    };
    final userRef = _db.collection("users").doc(user.uid);
    if ((await userRef.get()).exists) {
      await userRef.update({
        "last_login": user.metadata.lastSignInTime!.millisecondsSinceEpoch,
        "build_number": buildNumber,
      });
    } else {
      await _db.collection("users").doc(user.uid).set(userData);
    }
    await _saveDevice(user);
  }

  static _saveDevice(User user) async {
    DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
    String? deviceId;
    Map<String, dynamic>? deviceData;
    if (Platform.isAndroid) {
      final deviceInfo = await devicePlugin.androidInfo;
      deviceId = deviceInfo.androidId;
      deviceData = {
        "os_version": deviceInfo.version.sdkInt.toString(),
        "platform": 'android',
        "model": deviceInfo.model,
        "device": deviceInfo.device,
      };
    }
    if (Platform.isIOS) {
      final deviceInfo = await devicePlugin.iosInfo;
      deviceId = deviceInfo.identifierForVendor;
      deviceData = {
        "os_version": deviceInfo.systemVersion,
        "device": deviceInfo.name,
        "model": deviceInfo.utsname.machine,
        "platform": 'ios',
      };
    }
    final nowMS = DateTime.now().toUtc().millisecondsSinceEpoch;
    final deviceRef = _db
        .collection("users")
        .doc(user.uid)
        .collection("devices")
        .doc(deviceId);
    if ((await deviceRef.get()).exists) {
      await deviceRef.update({
        "updated_at": nowMS,
        "uninstalled": false,
      });
    } else {
      await deviceRef.set({
        "updated_at": nowMS,
        "uninstalled": false,
        "id": deviceId,
        "created_at": nowMS,
        "device_info": deviceData,
      });
    }
  }
}
