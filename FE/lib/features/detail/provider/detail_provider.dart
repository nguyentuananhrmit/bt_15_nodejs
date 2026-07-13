import 'package:flutter/material.dart';
import 'package:printest_flutter/features/detail/service/detail_api_service.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class DetailProvider extends ChangeNotifier {
  bool isLoading = false;

  String? errorMessage;

  ImageModel? image;

  Future<void> fetchImageById(int imageId) async {
    try {
      isLoading = true;
      errorMessage = null;
      image = null;

      notifyListeners();

      final ImageModel result = await DetailApiService.getImageById(imageId);

      image = result;
    } catch (error) {
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  void clearDetail() {
    image = null;
    errorMessage = null;

    notifyListeners();
  }
}
