import 'package:flutter/material.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:printest_flutter/features/home/services/home_api_service.dart';
import 'package:printest_flutter/features/saved/services/saved_api_service.dart';

class WishlistProvider extends ChangeNotifier {
  // Danh sách image đã được user lưu
  List<ImageModel> _wishlistImages = [];

  // Danh sách id của các image đã lưu
  final Set<int> _savedImageIds = {};

  // Trạng thái đang gọi API wishlist
  bool _isLoading = false;

  // Nội dung lỗi
  String? _errorMessage;

  // Cho giao diện đọc danh sách image đã lưu
  List<ImageModel> get wishlistImages => _wishlistImages;

  // Cho giao diện đọc trạng thái loading
  bool get isLoading => _isLoading;

  // Cho giao diện đọc lỗi
  String? get errorMessage => _errorMessage;

  // Kiểm tra image đã được lưu hay chưa
  bool isImageSaved(int imageId) {
    return _savedImageIds.contains(imageId);
  }

  // =========================================================
  // LẤY DANH SÁCH WISHLIST CỦA USER
  // =========================================================

  Future<void> fetchMyWishlist({required String accessToken}) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _wishlistImages = await SavedApiService.getMyWishlist(
        accessToken: accessToken,
      );

      // Đồng bộ danh sách id đã lưu
      _savedImageIds.clear();

      for (final ImageModel image in _wishlistImages) {
        _savedImageIds.add(image.id);
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // THÊM IMAGE VÀO WISHLIST
  // =========================================================

  Future<bool> addToWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await HomeApiService.addToWishlist(
        imageId: imageId,
        accessToken: accessToken,
      );

      _savedImageIds.add(imageId);

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // XOÁ IMAGE KHỎI WISHLIST
  // =========================================================

  Future<bool> removeFromWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await HomeApiService.removeFromWishlist(
        imageId: imageId,
        accessToken: accessToken,
      );

      // Xoá id khỏi trạng thái bookmark
      _savedImageIds.remove(imageId);

      // Xoá image khỏi danh sách đang render ở SavedListPage
      _wishlistImages.removeWhere((image) => image.id == imageId);

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // THÊM HOẶC XOÁ WISHLIST
  // =========================================================

  Future<bool> toggleWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    final bool isSaved = isImageSaved(imageId);

    if (isSaved) {
      return removeFromWishlist(imageId: imageId, accessToken: accessToken);
    }

    return addToWishlist(imageId: imageId, accessToken: accessToken);
  }

  // =========================================================
  // XOÁ DỮ LIỆU KHI LOGOUT
  // =========================================================

  void clearWishlist() {
    _wishlistImages = [];
    _savedImageIds.clear();
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  }
}
