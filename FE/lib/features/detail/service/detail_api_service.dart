import 'package:dio/dio.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class DetailApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3061/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static Future<ImageModel> getImageById(int imageId) async {
    try {
      final Response response = await _dio.get('/images/$imageId');

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception('Response không đúng định dạng');
      }

      final dynamic imageData = responseBody['data'];

      if (imageData is! Map) {
        throw Exception('Dữ liệu image không hợp lệ');
      }

      return ImageModel.fromJson(Map<String, dynamic>.from(imageData));
    } on DioException catch (error) {
      final dynamic responseData = error.response?.data;

      if (responseData is Map) {
        final String message =
            responseData['message']?.toString() ??
            'Lấy chi tiết image thất bại';

        throw Exception(message);
      }

      if (error.type == DioExceptionType.connectionError) {
        throw Exception('Không thể kết nối đến máy chủ');
      }

      if (error.type == DioExceptionType.connectionTimeout) {
        throw Exception('Kết nối đến máy chủ quá thời gian');
      }

      throw Exception('Lấy chi tiết image thất bại');
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }
}
