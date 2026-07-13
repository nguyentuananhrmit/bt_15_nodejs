import 'package:dio/dio.dart';

class ApiErrorHelper {
  // Hàm này nhận lỗi Dio từ file service
  static void handleDioError(DioException error) {
    // Thông báo mặc định
    String message = "Có lỗi xảy ra";

    // Nếu Backend có trả response lỗi về
    if (error.response != null) {
      // Lấy toàn bộ Body lỗi từ Backend
      final dynamic responseData = error.response?.data;

      // Trường hợp Backend trả JSON object
      //
      // Ví dụ:
      // {
      //   "statusCode": 400,
      //   "message": "title đã tồn tại"
      // }
      //
      // Dio sẽ tự chuyển JSON object thành Map của Dart
      if (responseData is Map) {
        // Lấy trường message trong Body
        message = responseData["message"]?.toString() ?? "Có lỗi xảy ra";
      }
      // Trường hợp Backend trả chuỗi thường
      //
      // Ví dụ:
      // "Server đang bảo trì"
      else if (responseData is String && responseData.trim().isNotEmpty) {
        message = responseData;
      }
    }
    // Nếu không kết nối được đến Backend
    else if (error.type == DioExceptionType.connectionError) {
      message = "Không thể kết nối đến máy chủ";
    }
    // Nếu thời gian kết nối quá lâu
    else if (error.type == DioExceptionType.connectionTimeout) {
      message = "Kết nối đến máy chủ quá thời gian";
    }
    // Nếu gửi dữ liệu lên Backend quá lâu
    else if (error.type == DioExceptionType.sendTimeout) {
      message = "Gửi dữ liệu lên máy chủ quá thời gian";
    }
    // Nếu chờ Backend trả dữ liệu quá lâu
    else if (error.type == DioExceptionType.receiveTimeout) {
      message = "Máy chủ phản hồi quá thời gian";
    }

    // Quăng lỗi về nơi gọi service
    // Sau đó file page sẽ catch và hiển thị lỗi
    throw Exception(message);
  }
}
