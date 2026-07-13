import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Lấy dữ liệu từ ô email
  final TextEditingController emailController = TextEditingController();

  // Lấy dữ liệu từ ô password
  final TextEditingController passwordController = TextEditingController();

  // Hiện hoặc ẩn password
  bool obscurePassword = true;

  void showMessage(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  bool validateForm({required String email, required String password}) {
    if (email.isEmpty) {
      showMessage("Vui lòng nhập email");
      return false;
    }

    if (!email.contains("@")) {
      showMessage("Email không hợp lệ");
      return false;
    }

    if (password.isEmpty) {
      showMessage("Vui lòng nhập password");
      return false;
    }

    return true;
  }

  Future<void> submitLogin() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final bool isValid = validateForm(email: email, password: password);

    if (!isValid) {
      return;
    }

    // Lấy AuthProvider
    final AuthProvider authProvider = context.read<AuthProvider>();

    // Gọi hàm login trong Provider
    final bool isSuccess = await authProvider.login(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    if (isSuccess) {
      showMessage("Đăng nhập thành công", backgroundColor: Colors.green);

      context.go("/home");
    } else {
      showMessage(authProvider.errorMessage ?? "Đăng nhập thất bại");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi AuthProvider để giao diện cập nhật loading
    final AuthProvider authProvider = context.watch<AuthProvider>();

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
                "Đăng nhập",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  wordSpacing: 2,
                ),
              ),

              const SizedBox(height: 20),

              // Nhập email
              TextField(
                controller: emailController,
                enabled: !authProvider.isLoading,
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
                enabled: !authProvider.isLoading,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
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

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : submitLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF42D56),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Dòng kẻ
              const Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "hoặc",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Đăng nhập bằng Google
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: authProvider.isLoading ? null : () {},
                  child: Center(
                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6U4pRN-hmnCKRp5bBpsxjHfbbutWDEgFRUo0YrTP2ag&s=10",
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Chuyển sang đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chưa có tài khoản?",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () {
                            context.push("/register");
                          },
                    child: const Text(
                      "Đăng ký",
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
