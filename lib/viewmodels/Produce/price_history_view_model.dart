import 'package:flutter/material.dart';
import 'package:plant_it_forward/app/app.locator.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/services/firestore_service.dart';
import 'package:plant_it_forward/viewmodels/base_model.dart';
import 'package:stacked_services/stacked_services.dart';

class PriceHistoryViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String _productId;
}
