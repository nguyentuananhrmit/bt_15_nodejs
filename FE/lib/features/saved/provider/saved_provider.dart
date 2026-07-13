import 'package:flutter/material.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:printest_flutter/features/saved/services/saved_api_service.dart';

class SavedProvider extends ChangeNotifier {
  // Danh sách ảnh của user hiện tại
  List<ImageModel> _images = [];

  // Trạng thái đang gọi API
  bool _isLoading = false;

  // Nội dung lỗi
  String? _errorMessage;

  // Cho giao diện đọc danh sách ảnh
  List<ImageModel> get images => _images;

  // Cho giao diện đọc trạng thái loading
  bool get isLoading => _isLoading;

  // Cho giao diện đọc lỗi
  String? get errorMessage => _errorMessage;

  // =========================================================
  // LẤY DANH SÁCH ẢNH THEO USER ID
  // =========================================================

  Future<void> fetchImagesByUserId({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _images = await SavedApiService.getImagesByUserId(userId: userId);
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // SOFT DELETE IMAGE
  // =========================================================

  Future<bool> deleteImage({
    required int imageId,
    required String accessToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await SavedApiService.softDeleteImage(
        imageId: imageId,
        accessToken: accessToken,
      );

      // Xóa ảnh khỏi danh sách đang hiển thị
      _images.removeWhere((image) => image.id == imageId);

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }
}
