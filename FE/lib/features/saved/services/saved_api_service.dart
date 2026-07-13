import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:printest_flutter/core/api_error_helper.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class SavedApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3061/api",
      headers: {"Content-Type": "application/json"},
    ),
  );

  // =========================================================
  // 1. LẤY DANH SÁCH HÌNH USER ĐÃ TẠO
  // =========================================================

  static Future<List<ImageModel>> getImagesByUserId({
    required int userId,
  }) async {
    try {
      final Response<dynamic> response = await dio.get("/images/user/$userId");

      debugPrint("Get images by user status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic imageListData = responseBody["data"];

      if (imageListData is! List) {
        throw Exception("Danh sách image không hợp lệ");
      }

      final List<ImageModel> images = imageListData.map((item) {
        if (item is! Map) {
          throw Exception("Dữ liệu image không hợp lệ");
        }

        final Map<String, dynamic> imageJson = Map<String, dynamic>.from(item);

        return ImageModel.fromJson(imageJson);
      }).toList();

      return images;
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // =========================================================
  // 2. SOFT DELETE HÌNH USER ĐÃ TẠO
  // =========================================================

  static Future<void> softDeleteImage({
    required int imageId,
    required String accessToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.delete(
        "/images/$imageId",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      debugPrint("Delete image status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      debugPrint("Delete image message: ${responseBody["message"]}");
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // =========================================================
  // 3. LẤY DANH SÁCH HÌNH ĐÃ LƯU TRONG WISHLIST
  // =========================================================

  static Future<List<ImageModel>> getMyWishlist({
    required String accessToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        "/wishlists",
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      debugPrint("Get wishlist status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic imageListData = responseBody["data"];

      if (imageListData is! List) {
        throw Exception("Danh sách wishlist không hợp lệ");
      }

      final List<ImageModel> images = imageListData.map((item) {
        if (item is! Map) {
          throw Exception("Dữ liệu image trong wishlist không hợp lệ");
        }

        final Map<String, dynamic> imageJson = Map<String, dynamic>.from(item);

        return ImageModel.fromJson(imageJson);
      }).toList();

      return images;
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }
}
