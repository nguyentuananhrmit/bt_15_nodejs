import 'package:flutter/material.dart';
import 'package:printest_flutter/features/auth/models/user_model.dart';
import 'package:printest_flutter/features/auth/services/auth_api_service.dart';

class AuthProvider extends ChangeNotifier {
  // User đang đăng nhập
  UserModel? _currentUser;

  // Access token dùng để gọi các API cần đăng nhập
  String? _accessToken;

  // Trạng thái đang gọi API
  bool _isLoading = false;

  // Nội dung lỗi nếu đăng nhập thất bại
  String? _errorMessage;

  // Cho giao diện đọc user hiện tại
  UserModel? get currentUser => _currentUser;

  // Cho giao diện đọc access token
  String? get accessToken => _accessToken;

  // Cho giao diện đọc trạng thái loading
  bool get isLoading => _isLoading;

  // Cho giao diện đọc nội dung lỗi
  String? get errorMessage => _errorMessage;

  // Kiểm tra người dùng đã đăng nhập hay chưa
  bool get isLoggedIn {
    return _currentUser != null && _accessToken != null;
  }

  // Gọi service để đăng nhập
  Future<bool> login({required String email, required String password}) async {
    // Bắt đầu gọi API
    _isLoading = true;

    // Xóa lỗi cũ
    _errorMessage = null;

    // Báo giao diện rebuild để hiện loading
    notifyListeners();

    try {
      // Gọi AuthApiService để đăng nhập
      final Map<String, dynamic> result = await AuthApiService.login(
        email: email,
        password: password,
      );

      // Lưu user từ kết quả service
      _currentUser = result["user"] as UserModel;

      // Lưu access token từ kết quả service
      _accessToken = result["accessToken"] as String;

      // Báo đăng nhập thành công
      return true;
    } catch (error) {
      // Lấy nội dung lỗi để giao diện hiển thị
      _errorMessage = error.toString().replaceFirst("Exception: ", "");

      // Báo đăng nhập thất bại
      return false;
    } finally {
      // Dù thành công hay thất bại cũng tắt loading
      _isLoading = false;

      // Báo giao diện rebuild lại
      notifyListeners();
    }
  }

  // Đăng xuất
  void logout() {
    _currentUser = null;
    _accessToken = null;
    _errorMessage = null;

    notifyListeners();
  }
}
