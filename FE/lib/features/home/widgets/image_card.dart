import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';
import 'package:printest_flutter/features/saved/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ImageCard extends StatelessWidget {
  final ImageModel image;

  const ImageCard({super.key, required this.image});

  void showMessage(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void openDetailPage(BuildContext context) {
    context.push('/images/${image.id}');
  }

  Future<void> toggleWishlist(BuildContext context) async {
    final AuthProvider authProvider = context.read<AuthProvider>();

    final WishlistProvider wishlistProvider = context.read<WishlistProvider>();

    final String? accessToken = authProvider.accessToken;

    // Kiểm tra token trước khi gọi API
    if (accessToken == null || accessToken.isEmpty) {
      showMessage(
        context,
        'Vui lòng đăng nhập để lưu hình',
        backgroundColor: Colors.red,
      );

      return;
    }

    // Tránh gọi API nhiều lần khi đang xử lý
    if (wishlistProvider.isLoading) {
      return;
    }

    // Lưu trạng thái trước khi thay đổi
    final bool wasSaved = wishlistProvider.isImageSaved(image.id);

    final bool isSuccess = await wishlistProvider.toggleWishlist(
      imageId: image.id,
      accessToken: accessToken,
    );

    if (!context.mounted) {
      return;
    }

    if (isSuccess) {
      showMessage(
        context,
        wasSaved ? 'Đã xoá khỏi danh sách lưu' : 'Đã thêm vào danh sách lưu',
        backgroundColor: Colors.green,
      );

      return;
    }

    showMessage(
      context,
      wishlistProvider.errorMessage ?? 'Cập nhật wishlist thất bại',
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    final WishlistProvider wishlistProvider = context.watch<WishlistProvider>();

    final bool isSaved = wishlistProvider.isImageSaved(image.id);
    final bool isLoading = wishlistProvider.isLoading;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          openDetailPage(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 350,
          height: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      image.imageUrl,
                      width: 350,
                      height: 260,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 350,
                          height: 260,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Nút wishlist
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isLoading
                            ? null
                            : () async {
                                await toggleWishlist(context);
                              },
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    image.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
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
