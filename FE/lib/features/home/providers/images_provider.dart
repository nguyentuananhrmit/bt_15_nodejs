import 'package:flutter/material.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:printest_flutter/features/home/services/home_api_service.dart';

class ImagesProvider extends ChangeNotifier {
  // =========================================================
  // 1. BIẾN TRẠNG THÁI
  // =========================================================

  // Danh sách image lấy từ Backend
  List<ImageModel> _images = [];

  // Danh sách id của các image đã được lưu vào wishlist
  final Set<int> _savedImageIds = {};

  // Trạng thái đang gọi API lấy danh sách image
  bool _isLoading = false;

  // Trạng thái đang thêm hoặc xóa wishlist
  bool _isWishlistLoading = false;

  // Nội dung lỗi nếu gọi API thất bại
  String? _errorMessage;

  // =========================================================
  // 2. GETTER
  // =========================================================

  // Cho giao diện đọc danh sách image
  List<ImageModel> get images => _images;

  // Cho giao diện đọc trạng thái loading danh sách
  bool get isLoading => _isLoading;

  // Cho giao diện đọc trạng thái loading wishlist
  bool get isWishlistLoading => _isWishlistLoading;

  // Cho giao diện đọc nội dung lỗi
  String? get errorMessage => _errorMessage;

  // Kiểm tra một image đã được lưu hay chưa
  bool isImageSaved(int imageId) {
    return _savedImageIds.contains(imageId);
  }

  // =========================================================
  // 3. LẤY TOÀN BỘ DANH SÁCH IMAGE
  // =========================================================

  Future<void> fetchImages() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _images = await HomeApiService.getAllImages();
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // 4. TÌM KIẾM IMAGE
  // =========================================================

  Future<void> searchImages(String keyword) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      if (keyword.trim().isEmpty) {
        _images = await HomeApiService.getAllImages();
      } else {
        _images = await HomeApiService.searchImages(keyword);
      }
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // 5. THÊM IMAGE VÀO WISHLIST
  // =========================================================

  Future<bool> addToWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    _isWishlistLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await HomeApiService.addToWishlist(
        imageId: imageId,
        accessToken: accessToken,
      );

      // Lưu id image vào danh sách đã save trên FE
      _savedImageIds.add(imageId);

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isWishlistLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // 6. XÓA IMAGE KHỎI WISHLIST
  // =========================================================

  Future<bool> removeFromWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    _isWishlistLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await HomeApiService.removeFromWishlist(
        imageId: imageId,
        accessToken: accessToken,
      );

      // Xóa id image khỏi danh sách đã save trên FE
      _savedImageIds.remove(imageId);

      return true;
    } catch (error) {
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      return false;
    } finally {
      _isWishlistLoading = false;

      notifyListeners();
    }
  }

  // =========================================================
  // 7. THÊM HOẶC XÓA WISHLIST
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
}
