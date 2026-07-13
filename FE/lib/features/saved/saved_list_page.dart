import 'package:flutter/material.dart';
import 'package:printest_flutter/features/saved/provider/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:printest_flutter/features/auth/provider/auth_provider.dart';
import 'package:printest_flutter/features/home/models/image_model.dart';

class SavedListPage extends StatefulWidget {
  const SavedListPage({super.key});

  @override
  State<SavedListPage> createState() => _SavedListPageState();
}

class _SavedListPageState extends State<SavedListPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      fetchWishlist();
    });
  }

  // Lấy danh sách hình đã lưu
  Future<void> fetchWishlist() async {
    final String? accessToken = context.read<AuthProvider>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      return;
    }

    await context.read<WishlistProvider>().fetchMyWishlist(
      accessToken: accessToken,
    );
  }

  // Xóa hình khỏi wishlist
  Future<void> removeFromWishlist(int imageId) async {
    final String? accessToken = context.read<AuthProvider>().accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      showMessage("Bạn cần đăng nhập trước", backgroundColor: Colors.red);

      return;
    }

    final WishlistProvider wishlistProvider = context.read<WishlistProvider>();

    final bool isSuccess = await wishlistProvider.removeFromWishlist(
      imageId: imageId,
      accessToken: accessToken,
    );

    if (!mounted) {
      return;
    }

    if (isSuccess) {
      showMessage("Đã bỏ lưu hình", backgroundColor: Colors.green);
    } else {
      showMessage(
        wishlistProvider.errorMessage ?? "Bỏ lưu hình thất bại",
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
    final WishlistProvider wishlistProvider = context.watch<WishlistProvider>();

    return Scaffold(body: SafeArea(child: buildBody(wishlistProvider)));
  }

  Widget buildBody(WishlistProvider wishlistProvider) {
    // Đang tải dữ liệu
    if (wishlistProvider.isLoading && wishlistProvider.wishlistImages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Gọi API thất bại
    if (wishlistProvider.errorMessage != null &&
        wishlistProvider.wishlistImages.isEmpty) {
      return Center(
        child: Text(
          wishlistProvider.errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    // Chưa lưu hình nào
    if (wishlistProvider.wishlistImages.isEmpty) {
      return const Center(
        child: Text(
          "Bạn chưa lưu hình nào",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Render danh sách hình đã lưu
    return RefreshIndicator(
      onRefresh: fetchWishlist,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: wishlistProvider.wishlistImages.length,
        itemBuilder: (context, index) {
          final ImageModel image = wishlistProvider.wishlistImages[index];

          return _SavedImageCard(
            image: image,
            onRemove: () {
              removeFromWishlist(image.id);
            },
          );
        },
      ),
    );
  }
}

// =========================================================
// CARD HIỂN THỊ HÌNH ĐÃ LƯU
// =========================================================

class _SavedImageCard extends StatelessWidget {
  final ImageModel image;
  final VoidCallback onRemove;

  const _SavedImageCard({required this.image, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  image.imageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 260,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Nút bỏ lưu
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    onPressed: onRemove,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.bookmark_remove_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            image.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
