import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/auth/services/auth_api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Lấy dữ liệu người dùng nhập từ các TextField
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // Kiểm tra API đăng ký có đang chạy không
  bool isLoading = false;

  // Hiển thị thông báo
  void showMessage(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  // Kiểm tra dữ liệu trước khi gọi API
  bool validateForm({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.isEmpty) {
      showMessage("Vui lòng nhập họ và tên", backgroundColor: Colors.red);

      return false;
    }

    if (email.isEmpty) {
      showMessage("Vui lòng nhập email", backgroundColor: Colors.red);

      return false;
    }

    if (!email.contains("@")) {
      showMessage("Email không hợp lệ", backgroundColor: Colors.red);

      return false;
    }

    if (password.isEmpty) {
      showMessage("Vui lòng nhập password", backgroundColor: Colors.red);

      return false;
    }

    if (password.length < 6) {
      showMessage(
        "Password phải có ít nhất 6 ký tự",
        backgroundColor: Colors.red,
      );

      return false;
    }

    return true;
  }

  // Gọi API đăng ký
  Future<void> submitRegister() async {
    // Lấy dữ liệu từ TextField và bỏ khoảng trắng đầu cuối
    final String fullName = fullNameController.text.trim();

    final String email = emailController.text.trim();

    final String password = passwordController.text.trim();

    // Kiểm tra dữ liệu
    final bool isValid = validateForm(
      fullName: fullName,
      email: email,
      password: password,
    );

    if (!isValid) {
      return;
    }

    // Bật loading và khóa nút
    setState(() {
      isLoading = true;
    });

    try {
      // Gọi service đăng ký
      await AuthApiService.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      if (!mounted) {
        return;
      }

      showMessage("Đăng ký thành công", backgroundColor: Colors.green);

      // Quay về trang đăng nhập
      context.pop();
    } catch (error) {
      if (!mounted) {
        return;
      }

      // ApiErrorHelper throw lỗi dạng:
      // Exception: Email đã tồn tại
      final String errorMessage = error.toString().replaceFirst(
        "Exception: ",
        "",
      );

      showMessage(errorMessage, backgroundColor: Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Image.network(
                "https://img.magnific.com/free-vector/stylish-welcome-lettering-banner-join-with-joy-happiness_1017-57675.jpg?semt=ais_hybrid&w=740&q=80",
                height: 180,
                fit: BoxFit.contain,
              ),

              const Text(
                "Tạo tài khoản",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  wordSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              // Nhập họ tên
              TextField(
                controller: fullNameController,
                enabled: !isLoading,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Họ và tên",
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nhập email
              TextField(
                controller: emailController,
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nhập password
              TextField(
                controller: passwordController,
                enabled: !isLoading,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: const Color(0xFFF7F7F7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nút tạo tài khoản
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  // Đang loading thì khóa nút
                  onPressed: isLoading ? null : submitRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF42D56),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Tạo tài khoản",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 12),

              // Chuyển về đăng nhập
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đã có tài khoản?",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.pop();
                          },
                    child: const Text(
                      "Đăng nhập",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF42D56),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
