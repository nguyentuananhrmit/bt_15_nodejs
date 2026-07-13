import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:printest_flutter/core/api_error_helper.dart';
import 'package:printest_flutter/features/auth/models/user_model.dart';

class AuthApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:3061/api",
      headers: {"Content-Type": "application/json"},
    ),
  );

  // Đăng ký tài khoản
  static Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        "/auth/register",
        data: {"full_name": fullName, "email": email, "password": password},
      );

      debugPrint("Register status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic userData = responseBody["data"];

      if (userData is! Map) {
        throw Exception("Dữ liệu user không hợp lệ");
      }

      final Map<String, dynamic> userJson = Map<String, dynamic>.from(userData);

      return UserModel.fromJson(userJson);
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }

  // Đăng nhập
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        "/auth/login",
        data: {"email": email, "password": password},
      );

      debugPrint("Login status code: ${response.statusCode}");

      final dynamic responseBody = response.data;

      if (responseBody is! Map) {
        throw Exception("Body Backend trả về không hợp lệ");
      }

      final dynamic loginData = responseBody["data"];

      if (loginData is! Map) {
        throw Exception("Dữ liệu đăng nhập không hợp lệ");
      }

      final dynamic userData = loginData["user"];
      final dynamic accessToken = loginData["accessToken"];

      if (userData is! Map) {
        throw Exception("Dữ liệu user không hợp lệ");
      }

      if (accessToken is! String || accessToken.isEmpty) {
        throw Exception("Access token không hợp lệ");
      }

      final UserModel user = UserModel.fromJson(
        Map<String, dynamic>.from(userData),
      );

      return {"user": user, "accessToken": accessToken};
    } on DioException catch (error) {
      ApiErrorHelper.handleDioError(error);

      rethrow;
    }
  }
}
