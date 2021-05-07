import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_it_forward/Models/User.dart';
import 'package:plant_it_forward/exceptions/firestore_api_exception.dart';

class FirestoreApi {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser({required User user}) async {
    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson());
    } catch (error) {
      throw FirestoreApiException(
          message: 'Failed to create new user', devDetails: '$error');
    }
  }

  Future<User?> getUser({required String userId}) async {
    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        return null;
      }

      final userData = userDoc.data();
      return User.fromJson(jsonDecode(userData.toString()));
    } else {
      throw FirestoreApiException(
          message:
              'Your user id passed is empty. Please pass in a valid user if from your Firestore user');
    }
  }
}
