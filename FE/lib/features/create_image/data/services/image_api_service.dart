import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:printest_flutter/core/api_error_helper.dart';

class ImageApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3061/api",
      headers: {"Content-Type": "application/json"},
    ),
  );

  static Future<void> createImage({
    required String title,
    required String description,
    required String imageUrl,
    required String accessToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        "/images",
        data: {
          "title": title,
          "description": description,
          "image_url": imageUrl,
        },

        // Gửi access token lên Backend
        options: Options(headers: {"Authorization": "Bearer $accessToken"}),
      );

      debugPrint("Status code: ${response.statusCode}");

      final dynamic responseData = response.data;

      if (responseData is Map) {
        debugPrint("Message service: ${responseData["message"]}");
      }
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      // Ném lỗi về CreateImagePage để catch và hiện SnackBar
      rethrow;
    }
  }
}
