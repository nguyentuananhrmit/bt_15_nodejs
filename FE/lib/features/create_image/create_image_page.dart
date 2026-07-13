import 'package:flutter/material.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:printest_flutter/features/create_image/data/services/image_api_service.dart';

class CreateImagePage extends StatefulWidget {
  const CreateImagePage({super.key});

  @override
  State<CreateImagePage> createState() => _CreateImagePageState();
}

class _CreateImagePageState extends State<CreateImagePage> {
  // =========================================================
  // 1. CONTROLLER - LẤY DỮ LIỆU TỪ TEXTFIELD
  // =========================================================

  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController imageUrlController = TextEditingController();

  // =========================================================
  // 2. BIẾN TRẠNG THÁI
  // =========================================================

  bool isLoading = false;

  // =========================================================
  // 3. HIỂN THỊ THÔNG BÁO
  // =========================================================

  void showMessage(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  // =========================================================
  // 4. KIỂM TRA DỮ LIỆU
  // =========================================================

  bool validateForm({
    required String name,
    required String description,
    required String imageUrl,
  }) {
    if (name.isEmpty) {
      showMessage("Vui lòng nhập tên hình", backgroundColor: Colors.red);

      return false;
    }

    if (description.isEmpty) {
      showMessage("Vui lòng nhập mô tả", backgroundColor: Colors.red);

      return false;
    }

    if (imageUrl.isEmpty) {
      showMessage("Vui lòng nhập URL hình", backgroundColor: Colors.red);

      return false;
    }

    final Uri? uri = Uri.tryParse(imageUrl);

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        (uri.scheme != "http" && uri.scheme != "https")) {
      showMessage("URL hình không hợp lệ", backgroundColor: Colors.red);

      return false;
    }

    return true;
  }

  // =========================================================
  // 5. GỌI API TẠO HÌNH
  // =========================================================

  Future<void> submitImage() async {
    final String name = nameController.text.trim();
    final String description = descriptionController.text.trim();
    final String imageUrl = imageUrlController.text.trim();

    final bool isValid = validateForm(
      name: name,
      description: description,
      imageUrl: imageUrl,
    );

    if (!isValid) {
      return;
    }

    // Lấy access token đã lưu trong AuthProvider
    final String? accessToken = context.read<AuthProvider>().accessToken;

    // Không có token nghĩa là user chưa đăng nhập
    if (accessToken == null || accessToken.isEmpty) {
      showMessage(
        "Bạn cần đăng nhập trước khi tạo hình",
        backgroundColor: Colors.red,
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ImageApiService.createImage(
        title: name,
        description: description,
        imageUrl: imageUrl,

        // Gửi token sang service
        accessToken: accessToken,
      );

      if (!mounted) {
        return;
      }

      showMessage("Tạo hình thành công", backgroundColor: Colors.green);

      clearForm();
    } catch (error) {
      if (!mounted) {
        return;
      }

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

  // =========================================================
  // 6. XÓA DỮ LIỆU FORM
  // =========================================================

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    imageUrlController.clear();
  }

  // =========================================================
  // 7. GIẢI PHÓNG CONTROLLER
  // =========================================================

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();

    super.dispose();
  }

  // =========================================================
  // 8. GIAO DIỆN
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tạo hình",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                enabled: !isLoading,
                decoration: InputDecoration(
                  labelText: "Tên hình",
                  hintText: "Nhập tên hình",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: descriptionController,
                enabled: !isLoading,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Mô tả",
                  hintText: "Nhập mô tả hình",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: imageUrlController,
                enabled: !isLoading,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: "URL hình",
                  hintText: "https://example.com/image.jpg",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitImage,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Tạo hình",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
