import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:printest_flutter/core/api_error_helper.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class HomeApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3061/api",
      headers: {"Content-Type": "application/json"},
    ),
  );

  // =========================================================
  // 1. LẤY TẤT CẢ IMAGE
  // =========================================================

  static Future<List<ImageModel>> getAllImages() async {
    try {
      final Response<dynamic> response = await dio.get("/images");

      debugPrint("Get images status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic imageListData = responseBody["data"];

      if (imageListData is! List) {
        throw Exception("Danh sách image không hợp lệ");
      }

      final List<ImageModel> images = imageListData.map((item) {
        final Map<String, dynamic> imageJson = Map<String, dynamic>.from(
          item as Map,
        );

        return ImageModel.fromJson(imageJson);
      }).toList();

      return images;
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // =========================================================
  // 2. TÌM KIẾM IMAGE
  // =========================================================

  static Future<List<ImageModel>> searchImages(String keyword) async {
    try {
      final Response<dynamic> response = await dio.get(
        "/images/search",
        queryParameters: {"keyword": keyword},
      );

      debugPrint("Search images status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic imageListData = responseBody["data"];

      if (imageListData is! List) {
        throw Exception("Danh sách image không hợp lệ");
      }

      final List<ImageModel> images = imageListData.map((item) {
        final Map<String, dynamic> imageJson = Map<String, dynamic>.from(
          item as Map,
        );

        return ImageModel.fromJson(imageJson);
      }).toList();

      return images;
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // =========================================================
  // 3. THÊM IMAGE VÀO WISHLIST
  // =========================================================

  static Future<void> addToWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        "/wishlists",
        data: {"image_id": imageId},
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      debugPrint("Add wishlist status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      debugPrint("Add wishlist message: ${responseBody["message"]}");
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // =========================================================
  // 4. XOÁ IMAGE KHỎI WISHLIST
  // =========================================================

  static Future<void> removeFromWishlist({
    required int imageId,
    required String accessToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.delete(
        "/wishlists/$imageId",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      debugPrint("Remove wishlist status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      debugPrint("Remove wishlist message: ${responseBody["message"]}");
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }
}
