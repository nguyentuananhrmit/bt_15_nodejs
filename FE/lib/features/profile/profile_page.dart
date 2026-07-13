import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void logout(BuildContext context) {
    // Xóa user và access token trong AuthProvider
    context.read<AuthProvider>().logout();

    // Chuyển về trang đăng nhập
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    // Theo dõi dữ liệu user hiện tại
    final AuthProvider authProvider = context.watch<AuthProvider>();

    final user = authProvider.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFFFF385C),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 16),

            Text(
              user?.fullName ?? "Chưa đăng nhập",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              user?.email ?? "",
              style: const TextStyle(fontSize: 14, color: Color(0xFF6F6F6F)),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: user == null
                    ? null
                    : () {
                        logout(context);
                      },
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF385C),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
