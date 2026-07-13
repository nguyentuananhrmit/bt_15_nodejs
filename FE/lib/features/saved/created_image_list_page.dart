import 'package:flutter/material.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:printest_flutter/features/saved/provider/saved_provider.dart';
import 'package:provider/provider.dart';
import 'package:printest_flutter/features/saved/widgets/created_image_card.dart';

class CreatedImageListPage extends StatefulWidget {
  const CreatedImageListPage({super.key});

  @override
  State<CreatedImageListPage> createState() => _CreatedImageListPageState();
}

class _CreatedImageListPageState extends State<CreatedImageListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      fetchCreatedImages();
    });
  }

  // Lấy danh sách hình của user đang đăng nhập
  Future<void> fetchCreatedImages() async {
    final AuthProvider authProvider = context.read<AuthProvider>();

    final int? userId = authProvider.currentUser?.id;

    if (userId == null) {
      return;
    }

    await context.read<SavedProvider>().fetchImagesByUserId(userId: userId);
  }

  // Soft delete image
  Future<void> deleteImage(int imageId) async {
    final String? accessToken = context.read<AuthProvider>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      showMessage("Bạn cần đăng nhập trước", backgroundColor: Colors.red);

      return;
    }

    final SavedProvider savedProvider = context.read<SavedProvider>();

    final bool isSuccess = await savedProvider.deleteImage(
      imageId: imageId,
      accessToken: accessToken,
    );

    if (!mounted) {
      return;
    }

    if (isSuccess) {
      showMessage("Xoá hình thành công", backgroundColor: Colors.green);
    } else {
      showMessage(
        savedProvider.errorMessage ?? "Xoá hình thất bại",
        backgroundColor: Colors.red,
      );
    }
  }

  void showMessage(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SavedProvider savedProvider = context.watch<SavedProvider>();

    return Scaffold(body: SafeArea(child: buildBody(savedProvider)));
  }

  Widget buildBody(SavedProvider savedProvider) {
    if (savedProvider.isLoading && savedProvider.images.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (savedProvider.errorMessage != null && savedProvider.images.isEmpty) {
      return Center(
        child: Text(savedProvider.errorMessage!, textAlign: TextAlign.center),
      );
    }

    if (savedProvider.images.isEmpty) {
      return const Center(
        child: Text(
          "Bạn chưa tạo hình nào",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchCreatedImages,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: savedProvider.images.length,
        itemBuilder: (context, index) {
          final image = savedProvider.images[index];

          return CreatedImageCard(
            image: image,
            onDelete: () {
              deleteImage(image.id);
            },
          );
        },
      ),
    );
  }
}
