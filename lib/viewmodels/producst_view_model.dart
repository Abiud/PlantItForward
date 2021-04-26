import 'package:plant_it_forward/Models/Product.dart';
import 'package:plant_it_forward/locator.dart';
import 'package:plant_it_forward/services/dialog_service.dart';
import 'package:plant_it_forward/services/firestore_service.dart';
import 'package:plant_it_forward/viewmodels/base_model.dart';

class ProductsViewModel extends BaseModel {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  // final CloudStorageService _cloudStorageService =
  //     locator<CloudStorageService>();

  List<Product> _posts;
  List<Product> get posts => _posts;

  void listenToPosts() {
    setBusy(true);

    _firestoreService.listenToProductsRealTime().listen((postsData) {
      List<Product> updatedPosts = postsData;
      if (updatedPosts != null && updatedPosts.length > 0) {
        _posts = updatedPosts;
        notifyListeners();
      }

      setBusy(false);
    });
  }

  Future deleteProduct(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to delete this item?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );

    if (dialogResponse.confirmed) {
      var productToDelete = _posts[index];
      setBusy(true);
      await _firestoreService.deleteProduct(productToDelete.documentId);
      // Delete the image after the post is deleted
      // await _cloudStorageService.deleteImage(postToDelete.imageFileName);
      setBusy(false);
    }
  }

  Future navigateToCreateView() async {
    await _navigationService.navigateTo(CreatePostViewRoute);
  }

  void editPost(int index) {
    _navigationService.navigateTo(CreatePostViewRoute,
        arguments: _posts[index]);
  }

  void requestMoreData() => _firestoreService.requestMoreData();
}
